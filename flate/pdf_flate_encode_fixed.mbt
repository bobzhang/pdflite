///|
fn pdf_flate_fixed_literal_code(symbol : Int32) -> (UInt32, Int32) {
  if symbol <= 143 {
    ((0x30 + symbol).reinterpret_as_uint(), 8)
  } else if symbol <= 255 {
    ((0x190 + symbol - 144).reinterpret_as_uint(), 9)
  } else if symbol <= 279 {
    ((symbol - 256).reinterpret_as_uint(), 7)
  } else {
    ((0xC0 + symbol - 280).reinterpret_as_uint(), 8)
  }
}

///|
fn pdf_flate_write_fixed_literal(
  writer : FlateBitWriter,
  symbol : Int32,
) -> Unit {
  let (code, width) = pdf_flate_fixed_literal_code(symbol)
  writer.write_bits(pdf_flate_reverse_bits(code, width), width)
}

///|
fn pdf_flate_length_code(
  length : Int32,
) -> (Int32, Int32, Int32) raise @core.PdfError {
  for index, base in pdf_flate_length_base {
    let extra_width = pdf_flate_length_extra[index]
    let max = base + ((1 << extra_width) - 1)
    if length >= base && length <= max {
      break (257 + index, length - base, extra_width)
    }
  } nobreak {
    raise InvalidFlateData
  }
}

///|
fn pdf_flate_distance_code(
  distance : Int32,
) -> (Int32, Int32, Int32) raise @core.PdfError {
  for index, base in pdf_flate_distance_base {
    let extra_width = pdf_flate_distance_extra[index]
    let max = base + ((1 << extra_width) - 1)
    if distance >= base && distance <= max {
      break (index, distance - base, extra_width)
    }
  } nobreak {
    raise InvalidFlateData
  }
}

///|
fn pdf_flate_write_fixed_distance(
  writer : FlateBitWriter,
  distance : Int32,
) -> Unit raise @core.PdfError {
  let (symbol, extra, extra_width) = pdf_flate_distance_code(distance)
  writer.write_bits(pdf_flate_reverse_bits(symbol.reinterpret_as_uint(), 5), 5)
  writer.write_bits(extra.reinterpret_as_uint(), extra_width)
}

///|
fn pdf_flate_write_fixed_length_distance(
  writer : FlateBitWriter,
  length : Int32,
  distance : Int32,
) -> Unit raise @core.PdfError {
  let (symbol, extra, extra_width) = pdf_flate_length_code(length)
  pdf_flate_write_fixed_literal(writer, symbol)
  writer.write_bits(extra.reinterpret_as_uint(), extra_width)
  pdf_flate_write_fixed_distance(writer, distance)
}

///|
fn pdf_flate_write_canonical_symbol(
  writer : FlateBitWriter,
  symbol : Int32,
  codes : ArrayView[Int32],
  lengths : ArrayView[Int32],
) -> Unit raise @core.PdfError {
  guard symbol >= 0 && symbol < lengths.length() && lengths[symbol] > 0 else {
    raise InvalidFlateData
  }
  let width = lengths[symbol]
  writer.write_bits(
    pdf_flate_reverse_bits(codes[symbol].reinterpret_as_uint(), width),
    width,
  )
}

///|
fn pdf_flate_push_fixed_literal_block(
  output : Array[Byte],
  data : BytesView,
  final_block : Bool,
) -> Unit {
  let writer = FlateBitWriter::new(output)
  writer.write_bits(if final_block { 1 } else { 0 }, 1)
  writer.write_bits(1, 2)
  for byte in data {
    pdf_flate_write_fixed_literal(writer, byte.to_int())
  }
  pdf_flate_write_fixed_literal(writer, 256)
  writer.finish()
}

///|
fn pdf_flate_repeated_previous_length(
  data : BytesView,
  position : Int32,
) -> Int32 {
  if position <= 0 || position >= data.length() {
    0
  } else {
    let previous = data[position - 1]
    let mut length = 0
    while position + length < data.length() &&
          data[position + length] == previous &&
          length < 258 {
      length += 1
    }
    length
  }
}

///|
fn pdf_flate_push_fixed_repeat_block(
  output : Array[Byte],
  data : BytesView,
  final_block : Bool,
) -> Unit raise @core.PdfError {
  let writer = FlateBitWriter::new(output)
  writer.write_bits(if final_block { 1 } else { 0 }, 1)
  writer.write_bits(1, 2)
  let mut index = 0
  while index < data.length() {
    let repeated = pdf_flate_repeated_previous_length(data, index)
    if repeated >= 3 {
      pdf_flate_write_fixed_length_distance(writer, repeated, 1)
      index += repeated
    } else {
      pdf_flate_write_fixed_literal(writer, data[index].to_int())
      index += 1
    }
  }
  pdf_flate_write_fixed_literal(writer, 256)
  writer.finish()
}

///|
fn pdf_flate_match_key(data : BytesView, position : Int32) -> Int32 {
  (data[position].to_int() << 8) | data[position + 1].to_int()
}

///|
fn pdf_flate_remember_match_prefix(
  table : Array[Int32],
  previous : Array[Int32],
  data : BytesView,
  position : Int32,
) -> Unit {
  if position + 1 < data.length() {
    let key = pdf_flate_match_key(data, position)
    previous[position] = table[key]
    table[key] = position
  }
}

///|
fn pdf_flate_previous_match_length(
  data : BytesView,
  source : Int32,
  position : Int32,
) -> Int32 {
  let mut length = 0
  while position + length < data.length() &&
        length < 258 &&
        data[source + length] == data[position + length] {
    length += 1
  }
  length
}

///|
fn pdf_flate_best_previous_match(
  data : BytesView,
  last_by_prefix : ArrayView[Int32],
  previous_by_position : ArrayView[Int32],
  position : Int32,
  max_probes : Int32,
) -> (Int32, Int32) {
  let mut match_length = 0
  let mut match_distance = 0
  if position + 2 < data.length() {
    let mut candidate = last_by_prefix[pdf_flate_match_key(data, position)]
    let mut probes = 0
    while candidate >= 0 && probes < max_probes {
      let distance = position - candidate
      if distance > 0 && distance <= 32768 {
        let length = pdf_flate_previous_match_length(data, candidate, position)
        if length > match_length {
          match_length = length
          match_distance = distance
          if length == 258 {
            break
          }
        }
      }
      candidate = previous_by_position[candidate]
      probes += 1
    }
  }
  (match_length, match_distance)
}

///|
priv enum PdfFlateToken {
  PdfFlateLiteral(Int32)
  PdfFlateLengthDistance(Int32, Int32)
}

///|
fn pdf_flate_match_tokens(
  data : BytesView,
  max_probes : Int32,
) -> Array[PdfFlateToken] {
  let tokens : Array[PdfFlateToken] = Array(capacity=data.length())
  let last_by_prefix : Array[Int32] = Array::make(65536, -1)
  let previous_by_position : Array[Int32] = Array::make(data.length(), -1)
  let mut index = 0
  while index < data.length() {
    let (match_length, match_distance) = pdf_flate_best_previous_match(
      data, last_by_prefix, previous_by_position, index, max_probes,
    )
    if match_length >= 3 {
      tokens.push(PdfFlateLengthDistance(match_length, match_distance))
      let next_index = index + match_length
      while index < next_index {
        pdf_flate_remember_match_prefix(
          last_by_prefix, previous_by_position, data, index,
        )
        index += 1
      }
    } else {
      tokens.push(PdfFlateLiteral(data[index].to_int()))
      pdf_flate_remember_match_prefix(
        last_by_prefix, previous_by_position, data, index,
      )
      index += 1
    }
  }
  tokens
}

///|
fn pdf_flate_push_fixed_match_block(
  output : Array[Byte],
  data : BytesView,
  final_block : Bool,
  max_probes : Int32,
) -> Unit raise @core.PdfError {
  let writer = FlateBitWriter::new(output)
  writer.write_bits(if final_block { 1 } else { 0 }, 1)
  writer.write_bits(1, 2)
  let last_by_prefix : Array[Int32] = Array::make(65536, -1)
  let previous_by_position : Array[Int32] = Array::make(data.length(), -1)
  let mut index = 0
  while index < data.length() {
    let (match_length, match_distance) = pdf_flate_best_previous_match(
      data, last_by_prefix, previous_by_position, index, max_probes,
    )
    if match_length >= 3 {
      pdf_flate_write_fixed_length_distance(
        writer, match_length, match_distance,
      )
      let next_index = index + match_length
      while index < next_index {
        pdf_flate_remember_match_prefix(
          last_by_prefix, previous_by_position, data, index,
        )
        index += 1
      }
    } else {
      pdf_flate_write_fixed_literal(writer, data[index].to_int())
      pdf_flate_remember_match_prefix(
        last_by_prefix, previous_by_position, data, index,
      )
      index += 1
    }
  }
  pdf_flate_write_fixed_literal(writer, 256)
  writer.finish()
}

///|
fn pdf_flate_encode_fixed_literal_view_with_header(
  data : BytesView,
  header : ArrayView[Byte],
) -> @core.PdfBytes {
  let output = pdf_flate_output_with_header(header, data.length() + 8)
  pdf_flate_push_fixed_literal_block(output, data, true)
  pdf_flate_push_adler32(output, data)
  Bytes::from_array(output)
}

///|
fn pdf_flate_encode_fixed_repeat_view_with_header(
  data : BytesView,
  header : ArrayView[Byte],
) -> @core.PdfBytes raise @core.PdfError {
  let output = pdf_flate_output_with_header(header, data.length() + 8)
  pdf_flate_push_fixed_repeat_block(output, data, true)
  pdf_flate_push_adler32(output, data)
  Bytes::from_array(output)
}

///|
fn pdf_flate_encode_fixed_match_view_with_header(
  data : BytesView,
  header : ArrayView[Byte],
  max_probes : Int32,
) -> @core.PdfBytes raise @core.PdfError {
  let output = pdf_flate_output_with_header(header, data.length() + 8)
  pdf_flate_push_fixed_match_block(output, data, true, max_probes)
  pdf_flate_push_adler32(output, data)
  Bytes::from_array(output)
}

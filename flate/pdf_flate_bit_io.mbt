///|
priv struct FlateBitReader {
  bytes : BytesView
  mut byte_pos : Int32
  mut bit_buf : UInt32
  mut bit_count : Int32
}

///|
fn FlateBitReader::new(bytes : BytesView) -> FlateBitReader {
  { bytes, byte_pos: 0, bit_buf: 0, bit_count: 0, }
}

///|
fn FlateBitReader::ensure_bits(
  self : FlateBitReader,
  count : Int32,
) -> Unit raise @core.PdfError {
  if count < 0 {
    raise InvalidFlateData
  }
  while self.bit_count < count {
    if self.byte_pos >= self.bytes.length() || self.byte_pos < 0 {
      raise InvalidFlateData
    }
    let byte = self.bytes[self.byte_pos].to_uint()
    self.bit_buf = self.bit_buf | (byte << self.bit_count)
    self.bit_count += 8
    self.byte_pos += 1
  }
}

///|
fn FlateBitReader::read_bits(
  self : FlateBitReader,
  count : Int32,
) -> UInt32 raise @core.PdfError {
  self.ensure_bits(count)
  let mask = pdf_flate_bit_mask(count)
  let value = self.bit_buf & mask
  self.bit_buf = self.bit_buf >> count
  self.bit_count -= count
  value
}

///|
fn FlateBitReader::peek_bits(self : FlateBitReader, count : Int32) -> UInt32? {
  if count < 0 {
    return None
  }
  let mut bit_buf = self.bit_buf
  let mut bit_count = self.bit_count
  let mut byte_pos = self.byte_pos
  while bit_count < count {
    if byte_pos >= self.bytes.length() || byte_pos < 0 {
      return None
    }
    let byte = self.bytes[byte_pos].to_uint()
    bit_buf = bit_buf | (byte << bit_count)
    bit_count += 8
    byte_pos += 1
  }
  Some(bit_buf & pdf_flate_bit_mask(count))
}

///|
fn FlateBitReader::drop_bits(
  self : FlateBitReader,
  count : Int32,
) -> Unit raise @core.PdfError {
  self.ensure_bits(count)
  self.bit_buf = self.bit_buf >> count
  self.bit_count -= count
}

///|
fn FlateBitReader::align_byte(
  self : FlateBitReader,
) -> Unit raise @core.PdfError {
  let drop = self.bit_count % 8
  if drop != 0 {
    self.drop_bits(drop)
  }
}

///|
fn FlateBitReader::read_byte(
  self : FlateBitReader,
) -> Byte raise @core.PdfError {
  self.read_bits(8).to_byte()
}

///|
let pdf_flate_bit_mask_table : Array[UInt32] = [
  0, 1, 3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047, 4095, 8191, 16383, 32767, 65535,
]

///|
fn pdf_flate_bit_mask(count : Int32) -> UInt32 {
  if count >= 0 && count < pdf_flate_bit_mask_table.length() {
    pdf_flate_bit_mask_table[count]
  } else {
    let mut mask : UInt32 = 0
    for _ in 0..<count {
      mask = (mask << 1) | 1
    }
    mask
  }
}

///|
fn pdf_flate_reverse_bits(value : UInt32, bits : Int32) -> UInt32 {
  let mut current = value
  let mut result : UInt32 = 0
  for _ in 0..<bits {
    result = (result << 1) | (current & 1)
    current = current >> 1
  }
  result
}

///|
priv struct FlateBitWriter {
  output : Array[Byte]
  mut current_byte : Int32
  mut bit_count : Int32
}

///|
fn FlateBitWriter::new(output : Array[Byte]) -> FlateBitWriter {
  { output, current_byte: 0, bit_count: 0, }
}

///|
fn FlateBitWriter::write_bits(
  self : FlateBitWriter,
  value : UInt32,
  width : Int32,
) -> Unit {
  for bit_index in 0..<width {
    if ((value >> bit_index) & 1) == 1 {
      self.current_byte = self.current_byte | (1 << self.bit_count)
    }
    self.bit_count += 1
    if self.bit_count == 8 {
      self.output.push(self.current_byte.to_byte())
      self.current_byte = 0
      self.bit_count = 0
    }
  }
}

///|
fn FlateBitWriter::finish(self : FlateBitWriter) -> Unit {
  if self.bit_count > 0 {
    self.output.push(self.current_byte.to_byte())
    self.current_byte = 0
    self.bit_count = 0
  }
}

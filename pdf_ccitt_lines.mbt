///|
fn pdf_ccitt_blank_line(columns : Int32, whiteval : Int32) -> Array[Int32] {
  [
    for _ in 0..<columns => whiteval
  ]
}

///|
fn pdf_ccitt_output_span(
  line : Array[Int32],
  column : Int32,
  length : Int32,
  value : Int32,
) -> Int32 raise @core.PdfError {
  if length < 0 || column < 0 || column + length > line.length() {
    raise InvalidCCITTData
  }
  for index in column..<(column + length) {
    line[index] = value
  }
  column + length
}

///|
fn pdf_ccitt_output_line(
  output : @core.BitWriter,
  line : ArrayView[Int32],
) -> Unit raise @core.PdfError {
  for bit in line {
    output.put_bit(bit)
  }
  output.align()
}

///|
fn pdf_ccitt_find_value(
  line : ArrayView[Int32],
  start : Int32,
  value : Int32,
) -> Int32 {
  let mut position = start
  while position >= 0 && position < line.length() && line[position] != value {
    position += 1
  }
  if position > line.length() {
    line.length()
  } else {
    position
  }
}

///|
fn pdf_ccitt_find_b1(
  reference : ArrayView[Int32],
  column : Int32,
  white : Bool,
  whiteval : Int32,
  blackval : Int32,
) -> Int32 {
  let current = if white { whiteval } else { blackval }
  let opposite = if white { blackval } else { whiteval }
  let mut position = column
  if !(column == 0 && white) {
    position = pdf_ccitt_find_value(reference, position, current)
  }
  pdf_ccitt_find_value(reference, position, opposite)
}

///|
fn pdf_ccitt_find_b2(
  reference : ArrayView[Int32],
  column : Int32,
  white : Bool,
  whiteval : Int32,
  blackval : Int32,
) -> Int32 {
  let current = if white { whiteval } else { blackval }
  let opposite = if white { blackval } else { whiteval }
  let mut position = column
  if !(column == 0 && white) {
    position = pdf_ccitt_find_value(reference, position, current)
  }
  position = pdf_ccitt_find_value(reference, position, opposite)
  pdf_ccitt_find_value(reference, position, current)
}

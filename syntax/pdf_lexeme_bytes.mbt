///|
/// Return the integer value of one ASCII hex digit, or `None` for non-hex bytes.
pub fn pdf_hex_value(value : Int32) -> Int32? {
  if value >= 48 && value <= 57 {
    Some(value - 48)
  } else if value >= 65 && value <= 70 {
    Some(value - 55)
  } else if value >= 97 && value <= 102 {
    Some(value - 87)
  } else {
    None
  }
}

///|
fn pdf_is_octal_digit_byte(value : Int32) -> Bool {
  value >= 48 && value <= 55
}

///|
fn pdf_lexeme_write_byte_at(
  output : Array[Byte],
  position : Int32,
  value : Byte,
) -> Int32 {
  output[position] = value
  position + 1
}

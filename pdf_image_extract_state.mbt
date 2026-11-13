///|
priv struct PdfImageExtractionJbig2Global {
  object_number : Int32
  serial : Int32
}

///|
priv struct PdfImageExtractionState {
  next_jbig2_serial : Ref[Int32]
  globals : Array[PdfImageExtractionJbig2Global]
}

///|
fn PdfImageExtractionState::jbig2_serial(
  self : PdfImageExtractionState,
  object_number : Int32,
) -> Int32? {
  for entry in self.globals {
    if entry.object_number == object_number {
      break Some(entry.serial)
    }
  } nobreak {
    None
  }
}

///|
fn PdfImageExtractionState::add_jbig2_global(
  self : PdfImageExtractionState,
  object_number : Int32,
) -> Int32 {
  self.next_jbig2_serial.val += 1
  let serial = self.next_jbig2_serial.val
  self.globals.push({ object_number, serial, })
  serial
}

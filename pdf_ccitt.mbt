///|
priv struct PdfCCITTCode {
  bits : Int32
  width : Int32
  run : Int32
  makeup : Bool
}

///|
priv struct PdfCCITTMode {
  bits : Int32
  width : Int32
  mode : PdfCCITTModeKind
}

///|
priv enum PdfCCITTModeKind {
  CCITTPass
  CCITTHorizontal
  CCITTVertical(Int32)
  CCITTUncompressed
  CCITTEOFB
}

///|
priv struct PdfCCITTRun {
  run : Int32
  makeup : Bool
}

///|
priv struct PdfCCITTParams {
  k : Int32
  end_of_line : Bool
  encoded_byte_align : Bool
  columns : Int32
  rows : Int32
  end_of_block : Bool
  black_is_1 : Bool
  damaged_rows_before_error : Int32
}

///|
fn pdf_ccitt_default_params() -> PdfCCITTParams {
  {
    k: 0,
    end_of_line: false,
    encoded_byte_align: false,
    columns: 1728,
    rows: 0,
    end_of_block: true,
    black_is_1: false,
    damaged_rows_before_error: 0,
  }
}

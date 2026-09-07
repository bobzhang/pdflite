///|
/// Text rotation values used by cpdf's add-text positioning helpers.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfAddTextRotation {
  PdfAddTextRot0
  PdfAddTextRot90
  PdfAddTextRot180
  PdfAddTextRot270
}

///|
pub extend PdfAddTextRotation with Debug::{to_repr}

///|
pub extend PdfAddTextRotation with Eq::{not_equal, equal}

///|
pub extend PdfAddTextRotation with ToJson::{to_json}

///|
/// Text justification values used by cpdf's add-text positioning helpers.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfAddTextJustification {
  PdfAddTextLeftJustify
  PdfAddTextCentreJustify
  PdfAddTextRightJustify
}

///|
pub extend PdfAddTextJustification with Debug::{to_repr}

///|
pub extend PdfAddTextJustification with Eq::{not_equal, equal}

///|
pub extend PdfAddTextJustification with ToJson::{to_json}

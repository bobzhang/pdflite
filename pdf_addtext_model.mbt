///|
/// Font source options for cpdf add-text.
///
/// This ports the source-level non-embedding `Cpdfembed.cpdffont` variants.
/// TrueType `EmbedInfo` remains a separate embedding slice.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfAddTextFontSource {
  PdfAddTextPreMadeFontPack(PdfFontPack)
  PdfAddTextExistingNamedFont
}

///|
pub extend PdfAddTextFontSource with Debug::{to_repr}

///|
pub extend PdfAddTextFontSource with Eq::{not_equal, equal}

///|
pub extend PdfAddTextFontSource with ToJson::{to_json}

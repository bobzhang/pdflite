///|
/// Source-facing cpdf font source descriptor.
///
/// This mirrors `Cpdfembed.cpdffont`: callers may supply a prebuilt font pack,
/// request TrueType embedding from bytes and an encoding, or reuse an existing
/// named font resource.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfEmbedFontSource {
  PdfEmbedPreMadeFontPack(PdfFontPack)
  PdfEmbedInfo(@core.PdfBytes, String, PdfEncoding)
  PdfEmbedExistingNamedFont
}

///|
pub extend PdfEmbedFontSource with Debug::{to_repr}

///|
pub extend PdfEmbedFontSource with Eq::{not_equal, equal}

///|
pub extend PdfEmbedFontSource with ToJson::{to_json}

///|
/// One `/Differences` entry in a simple-font encoding dictionary.
///
/// `code` is the one-byte character code that maps to `name`.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfEncodingDifference {
  name : @core.PdfName
  code : Int32
}

///|
pub extend PdfEncodingDifference with Debug::{to_repr}

///|
pub extend PdfEncodingDifference with Eq::{not_equal, equal}

///|
pub extend PdfEncodingDifference with ToJson::{to_json}

///|
/// Simple-font character encoding.
///
/// `PdfCustomEncoding` layers `/Differences` over a base encoding.
/// `PdfFillUndefinedWithStandard` models TrueType behavior where undefined
/// entries fall back to StandardEncoding.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfEncoding {
  PdfImplicitInFontFile
  PdfStandardEncoding
  PdfMacRomanEncoding
  PdfWinAnsiEncoding
  PdfMacExpertEncoding
  PdfCustomEncoding(PdfEncoding, Array[PdfEncodingDifference])
  PdfFillUndefinedWithStandard(PdfEncoding)
}

///|
pub extend PdfEncoding with Debug::{to_repr}

///|
pub extend PdfEncoding with Eq::{not_equal, equal}

///|
pub extend PdfEncoding with ToJson::{to_json}

///|
/// Parsed font model used by text extraction and font writing.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfFont {
  PdfFontStandard(PdfStandardFontData)
  PdfFontSimple(PdfSimpleFont)
  PdfFontCIDKeyed(PdfCIDKeyedFont)
}

///|
pub extend PdfFont with Debug::{to_repr}

///|
pub extend PdfFont with Eq::{not_equal, equal}

///|
pub extend PdfFont with ToJson::{to_json}

///|
/// Text extractor bound to a parsed font.
///
/// The extractor converts PDF text-string bytes to character codes, glyph
/// names, and Unicode codepoints according to the font's encoding data.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTextExtractor {
  font : PdfFont
}

///|
pub extend PdfTextExtractor with Debug::{to_repr}

///|
pub extend PdfTextExtractor with Eq::{not_equal, equal}

///|
pub extend PdfTextExtractor with ToJson::{to_json}

///|
/// Extracted glyph result for one character code.
///
/// `glyphname` is the resolved PDF glyph name and `codepoints` is the Unicode
/// scalar sequence inferred from ToUnicode, CMap, or Adobe glyph-list data.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTextGlyph {
  glyphname : @core.PdfName
  codepoints : Array[Int32]
}

///|
pub extend PdfTextGlyph with Debug::{to_repr}

///|
pub extend PdfTextGlyph with Eq::{not_equal, equal}

///|
pub extend PdfTextGlyph with ToJson::{to_json}

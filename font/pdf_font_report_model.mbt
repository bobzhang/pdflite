///|
/// One font resource entry reported by cpdf-style font listing.
///
/// `page` is one-based. `name`, `subtype`, `basefont`, and `encoding` are PDF
/// names rendered with their leading slash; missing non-name fields are empty
/// strings to match cpdf's text listing and JSON-null conversion.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfFontListEntry {
  page : Int32
  name : String
  subtype : String
  basefont : String
  encoding : String
  font : @syntax.PdfObject
}

///|
pub extend PdfFontListEntry with Debug::{to_repr}

///|
pub extend PdfFontListEntry with Eq::{not_equal, equal}

///|
pub extend PdfFontListEntry with ToJson::{to_json}

///|
/// One cpdf-style missing-font report entry.
///
/// `encoding == "Built-in"` records cpdf's fallback when a missing font does
/// not have a named `/Encoding`.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfMissingFontEntry {
  page : Int32
  name : String
  subtype : String
  basefont : String
  encoding : String
}

///|
pub extend PdfMissingFontEntry with Debug::{to_repr}

///|
pub extend PdfMissingFontEntry with Eq::{not_equal, equal}

///|
pub extend PdfMissingFontEntry with ToJson::{to_json}

///|
/// One row from cpdf's font encoding table.
///
/// `unicode_name` is empty when this port has no Unicode character-name table
/// entry for the codepoint. `utf8` is `<nonprintable>` for C0/C1 controls.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfFontTableEntry {
  code : Int32
  unicode : String
  utf8 : String
  unicode_name : String
  glyphnames : String
}

///|
pub extend PdfFontTableEntry with Debug::{to_repr}

///|
pub extend PdfFontTableEntry with Eq::{not_equal, equal}

///|
pub extend PdfFontTableEntry with ToJson::{to_json}

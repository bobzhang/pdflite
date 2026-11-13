///|
/// TrueType table-directory record.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTrueTypeTableRecord {
  tag : String
  checksum : UInt32
  offset : Int32
  length : Int32
}

///|
pub extend PdfTrueTypeTableRecord with Debug::{to_repr}

///|
pub extend PdfTrueTypeTableRecord with Eq::{not_equal, equal}

///|
pub extend PdfTrueTypeTableRecord with ToJson::{to_json}

///|
/// Core metrics extracted from TrueType `head`, `hhea`, `hmtx`, and `maxp`.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTrueTypeMetrics {
  units_per_em : Int32
  minx : Int32
  miny : Int32
  maxx : Int32
  maxy : Int32
  index_to_loc_format : Int32
  num_glyphs : Int32
  num_of_long_hor_metrics : Int32
  advance_widths : Array[Int32]
  max_width : Int32
}

///|
pub extend PdfTrueTypeMetrics with Debug::{to_repr}

///|
pub extend PdfTrueTypeMetrics with Eq::{not_equal, equal}

///|
pub extend PdfTrueTypeMetrics with ToJson::{to_json}

///|
/// Font descriptor metrics derived from TrueType tables.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTrueTypeDescriptorMetrics {
  ascent : Int32
  descent : Int32
  capheight : Int32
  xheight : Int32
  avgwidth : Int32
  italicangle : Int32
  nonsymbolic_flags : Int32
  symbolic_flags : Int32
}

///|
pub extend PdfTrueTypeDescriptorMetrics with Debug::{to_repr}

///|
pub extend PdfTrueTypeDescriptorMetrics with Eq::{not_equal, equal}

///|
pub extend PdfTrueTypeDescriptorMetrics with ToJson::{to_json}

///|
/// Mapping from a Unicode codepoint to a TrueType glyph index.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTrueTypeCMapGlyph {
  codepoint : Int32
  glyph_index : Int32
}

///|
pub extend PdfTrueTypeCMapGlyph with Debug::{to_repr}

///|
pub extend PdfTrueTypeCMapGlyph with Eq::{not_equal, equal}

///|
pub extend PdfTrueTypeCMapGlyph with ToJson::{to_json}

///|
/// Byte range for one glyph inside the TrueType `glyf` table.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTrueTypeGlyphByteRange {
  glyph_index : Int32
  start_offset : Int32
  end_offset : Int32
}

///|
pub extend PdfTrueTypeGlyphByteRange with Debug::{to_repr}

///|
pub extend PdfTrueTypeGlyphByteRange with Eq::{not_equal, equal}

///|
pub extend PdfTrueTypeGlyphByteRange with ToJson::{to_json}

///|
/// Result of splitting a TrueType Unicode subset into cpdf's main and higher
/// subset groups.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfTrueTypeSubsetPartition {
  main_subset : Array[Int32]
  higher_subsets : Array[Array[Int32]]
}

///|
pub extend PdfTrueTypeSubsetPartition with Debug::{to_repr}

///|
pub extend PdfTrueTypeSubsetPartition with Eq::{not_equal, equal}

///|
pub extend PdfTrueTypeSubsetPartition with ToJson::{to_json}

///|
/// Rebuilt subset-table bytes and their unpadded logical length.
#derive(Debug, Eq)
pub(all) struct PdfTrueTypeSubsetTable {
  length : Int32
  bytes : Bytes
}

///|
pub extend PdfTrueTypeSubsetTable with Debug::{to_repr}

///|
pub extend PdfTrueTypeSubsetTable with Eq::{not_equal, equal}

///|
/// One subset record returned by cpdf-style TrueType parsing.
#derive(Debug, Eq)
pub(all) struct PdfTrueTypeParsedSubset {
  flags : Int32
  minx : Int32
  miny : Int32
  maxx : Int32
  maxy : Int32
  italicangle : Int32
  ascent : Int32
  descent : Int32
  capheight : Int32
  stemv : Int32
  xheight : Int32
  avgwidth : Int32
  maxwidth : Int32
  firstchar : Int32
  lastchar : Int32
  widths : Array[Int32]
  subset_fontfile : Bytes
  subset : Array[Int32]
  tounicode : Array[(Int32, Bytes)]?
}

///|
pub extend PdfTrueTypeParsedSubset with Debug::{to_repr}

///|
pub extend PdfTrueTypeParsedSubset with Eq::{not_equal, equal}

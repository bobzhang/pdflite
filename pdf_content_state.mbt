///|
/// Colour operands carried by cpdfcontent's path drawing state.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentColourValues {
  PdfContentColourFloats(Array[Double])
  PdfContentColourNamed(String, Array[Double])
  PdfContentColourPattern
}

///|
pub extend PdfContentColourValues with Debug::{to_repr}

///|
pub extend PdfContentColourValues with Eq::{not_equal, equal}

///|
pub extend PdfContentColourValues with ToJson::{to_json}

///|
/// Dash pattern carried by cpdfcontent's path drawing state.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentDashPattern {
  array : Array[Double]
  phase : Double
}

///|
pub extend PdfContentDashPattern with Debug::{to_repr}

///|
pub extend PdfContentDashPattern with Eq::{not_equal, equal}

///|
pub extend PdfContentDashPattern with ToJson::{to_json}

///|
/// Path drawing state exported by cpdfcontent's JSON view.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentPathState {
  clipping_path : Array[@shape.PdfPath]
  colourspace_stroke : PdfColourSpace
  colourspace_non_stroke : PdfColourSpace
  colour_stroke : PdfContentColourValues
  colour_non_stroke : PdfContentColourValues
  line_width : Double
  line_cap : Int32
  line_join : Int32
  dash_pattern : PdfContentDashPattern
  rendering_intent : String
}

///|
pub extend PdfContentPathState with Debug::{to_repr}

///|
pub extend PdfContentPathState with Eq::{not_equal, equal}

///|
pub extend PdfContentPathState with ToJson::{to_json}

///|
/// Clipping-only state exported for inline images, images, and shadings.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentClippingState {
  clipping_path : Array[@shape.PdfPath]
}

///|
pub extend PdfContentClippingState with Debug::{to_repr}

///|
pub extend PdfContentClippingState with Eq::{not_equal, equal}

///|
pub extend PdfContentClippingState with ToJson::{to_json}

///|
/// Text state fields exported alongside glyph content objects.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentGlyphState {
  rendering_mode : Int32
  knockout : Bool
  font : String
  font_size : Double
  clipping_path : Array[@shape.PdfPath]
}

///|
pub extend PdfContentGlyphState with Debug::{to_repr}

///|
pub extend PdfContentGlyphState with Eq::{not_equal, equal}

///|
pub extend PdfContentGlyphState with ToJson::{to_json}

///|
/// Content objects emitted by cpdfcontent's JSON exporter.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentObject {
  PdfContentGlyphObject(Int32, String, String)
  PdfContentInlineImageObject
  PdfContentImageObject(String)
  PdfContentPathObject(@shape.PdfDrawnPath)
  PdfContentShadingObject(String)
}

///|
pub extend PdfContentObject with Debug::{to_repr}

///|
pub extend PdfContentObject with Eq::{not_equal, equal}

///|
pub extend PdfContentObject with ToJson::{to_json}

///|
/// Content state variant carried by one cpdfcontent JSON entry.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentState {
  PdfContentStateGlyph(PdfContentGlyphState)
  PdfContentStatePath(PdfContentPathState)
  PdfContentStateClipping(PdfContentClippingState)
}

///|
pub extend PdfContentState with Debug::{to_repr}

///|
pub extend PdfContentState with Eq::{not_equal, equal}

///|
pub extend PdfContentState with ToJson::{to_json}

///|
/// Eight-point cpdfcontent bounding box quad.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentBoundingBox {
  x0 : Double
  y0 : Double
  x1 : Double
  y1 : Double
  x2 : Double
  y2 : Double
  x3 : Double
  y3 : Double
}

///|
pub extend PdfContentBoundingBox with Debug::{to_repr}

///|
pub extend PdfContentBoundingBox with Eq::{not_equal, equal}

///|
pub extend PdfContentBoundingBox with ToJson::{to_json}

///|
/// One item in cpdfcontent's JSON content list.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentJsonEntry {
  object : PdfContentObject
  state : PdfContentState
  bounding_box : PdfContentBoundingBox
}

///|
pub extend PdfContentJsonEntry with Debug::{to_repr}

///|
pub extend PdfContentJsonEntry with Eq::{not_equal, equal}

///|
pub extend PdfContentJsonEntry with ToJson::{to_json}

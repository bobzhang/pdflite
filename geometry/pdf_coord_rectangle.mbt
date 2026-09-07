///|
/// A cpdf coordinate rectangle: origin plus width and height.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfCoordRectangle {
  x : Double
  y : Double
  width : Double
  height : Double
}

///|
pub extend PdfCoordRectangle with Debug::{to_repr}

///|
pub extend PdfCoordRectangle with Eq::{not_equal, equal}

///|
pub extend PdfCoordRectangle with ToJson::{to_json}

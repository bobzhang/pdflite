///|
/// Fill rule for a cpdf-style path.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfPathWindingRule {
  PdfPathEvenOdd
  PdfPathNonZero
}

///|
pub extend PdfPathWindingRule with Debug::{to_repr}

///|
pub extend PdfPathWindingRule with Eq::{not_equal, equal}

///|
pub extend PdfPathWindingRule with ToJson::{to_json}

///|
/// One straight or Bezier path segment.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfPathSegment {
  PdfPathStraight(Point2, Point2)
  PdfPathBezier(Point2, Point2, Point2, Point2)
}

///|
pub extend PdfPathSegment with Debug::{to_repr}

///|
pub extend PdfPathSegment with Eq::{not_equal, equal}

///|
pub extend PdfPathSegment with ToJson::{to_json}

///|
/// Whether a subpath is a hole in the containing path.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfPathHole {
  PdfPathHole
  PdfPathNotHole
}

///|
pub extend PdfPathHole with Debug::{to_repr}

///|
pub extend PdfPathHole with Eq::{not_equal, equal}

///|
pub extend PdfPathHole with ToJson::{to_json}

///|
/// Whether a subpath is open or closed.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfPathClosure {
  PdfPathClosed
  PdfPathOpen
}

///|
pub extend PdfPathClosure with Debug::{to_repr}

///|
pub extend PdfPathClosure with Eq::{not_equal, equal}

///|
pub extend PdfPathClosure with ToJson::{to_json}

///|
/// A cpdf-style subpath.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfPathSubpath {
  hole : PdfPathHole
  closure : PdfPathClosure
  segments : Array[PdfPathSegment]
}

///|
pub extend PdfPathSubpath with Debug::{to_repr}

///|
pub extend PdfPathSubpath with Eq::{not_equal, equal}

///|
pub extend PdfPathSubpath with ToJson::{to_json}

///|
/// A cpdf-style path.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfPath {
  winding_rule : PdfPathWindingRule
  subpaths : Array[PdfPathSubpath]
}

///|
pub extend PdfPath with Debug::{to_repr}

///|
pub extend PdfPath with Eq::{not_equal, equal}

///|
pub extend PdfPath with ToJson::{to_json}

///|
/// A cpdfcontent drawn path, pairing path geometry with paint flags.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfDrawnPath {
  stroked : Bool
  filled : Bool
  path : PdfPath
}

///|
pub extend PdfDrawnPath with Debug::{to_repr}

///|
pub extend PdfDrawnPath with Eq::{not_equal, equal}

///|
pub extend PdfDrawnPath with ToJson::{to_json}

///|
/// Partial path under construction while interpreting path-building content
/// operators.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentPartialPath {
  PdfContentNoPartialPath
  PdfContentPartialPath(PdfContentPartialPathState)
}

///|
pub extend PdfContentPartialPath with Debug::{to_repr}

///|
pub extend PdfContentPartialPath with Eq::{not_equal, equal}

///|
pub extend PdfContentPartialPath with ToJson::{to_json}

///|
/// Mutable data for an open PDF path subpath.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentPartialPathState {
  start_point : Point2
  current_point : Point2
  segments : Array[PdfPathSegment]
  subpaths : Array[PdfPathSubpath]
}

///|
pub extend PdfContentPartialPathState with Debug::{to_repr}

///|
pub extend PdfContentPartialPathState with Eq::{not_equal, equal}

///|
pub extend PdfContentPartialPathState with ToJson::{to_json}

///|
/// Result of applying a path-painting operator to the current partial path.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentPathOpResult {
  partial_path : PdfContentPartialPath
  drawn_path : PdfDrawnPath?
}

///|
pub extend PdfContentPathOpResult with Debug::{to_repr}

///|
pub extend PdfContentPathOpResult with Eq::{not_equal, equal}

///|
pub extend PdfContentPathOpResult with ToJson::{to_json}

///|
/// Result of applying a clipping-path operator to the current partial path.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentClippingOpResult {
  partial_path : PdfContentPartialPath
  clipping_path : Array[PdfPath]
}

///|
pub extend PdfContentClippingOpResult with Debug::{to_repr}

///|
pub extend PdfContentClippingOpResult with Eq::{not_equal, equal}

///|
pub extend PdfContentClippingOpResult with ToJson::{to_json}

///|
/// Return an empty partial path state.
pub fn pdf_content_no_partial_path() -> PdfContentPartialPath {
  PdfContentNoPartialPath
}

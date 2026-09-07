///|
/// A two-dimensional point in PDF user-space coordinates.
#derive(Debug, Eq, ToJson)
pub(all) struct Point2 {
  x : Double
  y : Double
}

///|
pub extend Point2 with Debug::{to_repr}

///|
pub extend Point2 with Eq::{not_equal, equal}

///|
pub extend Point2 with ToJson::{to_json}

///|
/// A high-level affine transform operation.
///
/// Operation lists preserve CamlPDF's transform model; they can be rendered for
/// diagnostics or lowered to `TransformMatrix` for application to points.
#derive(Debug, Eq, ToJson)
pub(all) enum TransformOp {
  Scale(Point2, Double, Double)
  Rotate(Point2, Double)
  Translate(Double, Double)
  ShearX(Point2, Double)
  ShearY(Point2, Double)
}

///|
pub extend TransformOp with Debug::{to_repr}

///|
pub extend TransformOp with Eq::{not_equal, equal}

///|
pub extend TransformOp with ToJson::{to_json}

///|
/// A PDF affine transform matrix.
///
/// The fields correspond to PDF's six-operand matrix `[a b c d e f]`, where a
/// point is transformed as `x' = a*x + c*y + e` and
/// `y' = b*x + d*y + f`.
#derive(Debug, Eq, ToJson)
pub(all) struct TransformMatrix {
  a : Double
  b : Double
  c : Double
  d : Double
  e : Double
  f : Double
}

///|
pub extend TransformMatrix with Debug::{to_repr}

///|
pub extend TransformMatrix with Eq::{not_equal, equal}

///|
pub extend TransformMatrix with ToJson::{to_json}

///|
/// The decomposed components of an affine transform matrix.
///
/// Values are expressed as scale, aspect ratio, rotation, shear, and
/// translation components suitable for recomposition.
#derive(Debug, Eq, ToJson)
pub(all) struct TransformDecomposition {
  scale : Double
  aspect : Double
  rotation : Double
  shear : Double
  translate_x : Double
  translate_y : Double
}

///|
pub extend TransformDecomposition with Debug::{to_repr}

///|
pub extend TransformDecomposition with Eq::{not_equal, equal}

///|
pub extend TransformDecomposition with ToJson::{to_json}

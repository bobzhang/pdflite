///|
/// Placeholder for a tiling pattern; detailed tiling-paint payloads are not
/// expanded by the content reader yet.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentTiling {
  PdfContentTiling
}

///|
pub extend PdfContentTiling with Debug::{to_repr}

///|
pub extend PdfContentTiling with Eq::{not_equal, equal}

///|
pub extend PdfContentTiling with ToJson::{to_json}

///|
/// Function-based shading dictionary data.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentFunctionShading {
  funshading_domain : (Double, Double, Double, Double)
  funshading_matrix : @geometry.TransformMatrix
  funshading_function : PdfFunction
}

///|
pub extend PdfContentFunctionShading with Debug::{to_repr}

///|
pub extend PdfContentFunctionShading with Eq::{not_equal, equal}

///|
pub extend PdfContentFunctionShading with ToJson::{to_json}

///|
/// Radial shading dictionary data.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentRadialShading {
  radialshading_coords : (Double, Double, Double, Double, Double, Double)
  radialshading_domain : (Double, Double)
  radialshading_function : Array[PdfFunction]
  radialshading_extend : (Bool, Bool)
}

///|
pub extend PdfContentRadialShading with Debug::{to_repr}

///|
pub extend PdfContentRadialShading with Eq::{not_equal, equal}

///|
pub extend PdfContentRadialShading with ToJson::{to_json}

///|
/// Axial shading dictionary data.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentAxialShading {
  axialshading_coords : (Double, Double, Double, Double)
  axialshading_domain : (Double, Double)
  axialshading_function : Array[PdfFunction]
  axialshading_extend : (Bool, Bool)
}

///|
pub extend PdfContentAxialShading with Debug::{to_repr}

///|
pub extend PdfContentAxialShading with Eq::{not_equal, equal}

///|
pub extend PdfContentAxialShading with ToJson::{to_json}

///|
/// Parsed shading kind selected from `/ShadingType`.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentShadingKind {
  PdfContentFunctionShading(PdfContentFunctionShading)
  PdfContentAxialShading(PdfContentAxialShading)
  PdfContentRadialShading(PdfContentRadialShading)
  PdfContentFreeFormGouraudShading
  PdfContentLatticeFormGouraudShading
  PdfContentCoonsPatchMesh
  PdfContentTensorProductPatchMesh
}

///|
pub extend PdfContentShadingKind with Debug::{to_repr}

///|
pub extend PdfContentShadingKind with Eq::{not_equal, equal}

///|
pub extend PdfContentShadingKind with ToJson::{to_json}

///|
/// Parsed shading with shared colour-space, matrix, graphics-state, and
/// antialias metadata.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfContentShading {
  shading_colourspace : @syntax.PdfObject
  shading_background : @syntax.PdfObject?
  shading_bbox : @syntax.PdfObject?
  shading_antialias : Bool
  shading_matrix : @geometry.TransformMatrix
  shading_extgstate : @syntax.PdfObject
  shading : PdfContentShadingKind
}

///|
pub extend PdfContentShading with Debug::{to_repr}

///|
pub extend PdfContentShading with Eq::{not_equal, equal}

///|
pub extend PdfContentShading with ToJson::{to_json}

///|
/// Parsed pattern resource, either a tiling-pattern placeholder or a shading
/// pattern.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentPattern {
  PdfContentColouredTilingPattern(PdfContentTiling)
  PdfContentUncolouredTilingPattern(PdfContentTiling)
  PdfContentShadingPattern(PdfContentShading)
}

///|
pub extend PdfContentPattern with Debug::{to_repr}

///|
pub extend PdfContentPattern with Eq::{not_equal, equal}

///|
pub extend PdfContentPattern with ToJson::{to_json}

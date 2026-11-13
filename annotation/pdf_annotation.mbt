///|
/// Border style used by an annotation border dictionary.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfAnnotationStyle {
  AnnotationNoStyle
  AnnotationSolid
  AnnotationDashed
  AnnotationBeveled
  AnnotationInset
  AnnotationUnderlineStyle
}

///|
pub extend PdfAnnotationStyle with Debug::{to_repr}

///|
pub extend PdfAnnotationStyle with Eq::{not_equal, equal}

///|
pub extend PdfAnnotationStyle with ToJson::{to_json}

///|
/// Parsed annotation border information.
///
/// `vertical_radius` and `horizontal_radius` come from the legacy `/Border`
/// array form. `style` and `dash_array` represent `/BS` dictionary entries when
/// present.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfAnnotationBorder {
  width : Double
  vertical_radius : Double
  horizontal_radius : Double
  style : PdfAnnotationStyle
  dash_array : Array[Int32]
}

///|
pub extend PdfAnnotationBorder with Debug::{to_repr}

///|
pub extend PdfAnnotationBorder with Eq::{not_equal, equal}

///|
pub extend PdfAnnotationBorder with ToJson::{to_json}

///|
/// RGB annotation colour from the `/C` entry.
///
/// Components are stored as integer channel values after parsing PDF numbers.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfAnnotationColour {
  red : Int32
  green : Int32
  blue : Int32
}

///|
pub extend PdfAnnotationColour with Debug::{to_repr}

///|
pub extend PdfAnnotationColour with Eq::{not_equal, equal}

///|
pub extend PdfAnnotationColour with ToJson::{to_json}

///|
/// Supported annotation subtype.
///
/// Popup annotations embed their resolved parent annotation when available.
/// Unknown subtype names are preserved as `AnnotationUnknown`.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfAnnotationSubtype {
  AnnotationText
  AnnotationLink
  AnnotationFreeText
  AnnotationLine
  AnnotationSquare
  AnnotationCircle
  AnnotationPolygon
  AnnotationPolyLine
  AnnotationHighlight
  AnnotationUnderline
  AnnotationSquiggly
  AnnotationStrikeOut
  AnnotationStamp
  AnnotationCaret
  AnnotationInk
  AnnotationPopup(PdfAnnotation)
  AnnotationFileAttachment
  AnnotationSound
  AnnotationMovie
  AnnotationWidget
  AnnotationScreen
  AnnotationPrinterMark
  AnnotationTrapNet
  AnnotationWatermark
  AnnotationThreeDee
  AnnotationUnknown(PdfName)
}

///|
pub extend PdfAnnotationSubtype with Debug::{to_repr}

///|
pub extend PdfAnnotationSubtype with Eq::{not_equal, equal}

///|
pub extend PdfAnnotationSubtype with ToJson::{to_json}

///|
/// Parsed PDF annotation dictionary.
///
/// `contents` and `subject` are raw PDF string bytes. `rectangle` is required
/// when reading from a PDF. `rest` preserves dictionary entries not modeled by
/// the typed fields so they can be written back.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfAnnotation {
  subtype : PdfAnnotationSubtype
  contents : PdfBytes?
  subject : PdfBytes?
  rectangle : PdfRectangle
  border : PdfAnnotationBorder
  colour : PdfAnnotationColour?
  rest : PdfObject
}

///|
pub extend PdfAnnotation with Debug::{to_repr}

///|
pub extend PdfAnnotation with Eq::{not_equal, equal}

///|
pub extend PdfAnnotation with ToJson::{to_json}

///|
fn pdf_annotation_default_border() -> PdfAnnotationBorder {
  {
    width: 1.0,
    vertical_radius: 0.0,
    horizontal_radius: 0.0,
    style: AnnotationNoStyle,
    dash_array: [],
  }
}

///|
fn pdf_annotation_zero_rectangle() -> PdfRectangle {
  { min_x: 0.0, min_y: 0.0, max_x: 0.0, max_y: 0.0, }
}

///|
/// Build an annotation border, copying the supplied dash array.
pub fn pdf_annotation_make_border(
  width : Double,
  vertical_radius~ : Double = 0.0,
  horizontal_radius~ : Double = 0.0,
  style~ : PdfAnnotationStyle = AnnotationNoStyle,
  dash_array~ : ArrayView[Int32] = [],
) -> PdfAnnotationBorder {
  {
    width,
    vertical_radius,
    horizontal_radius,
    style,
    dash_array: [
      for dash in dash_array => dash
    ],
  }
}

///|
/// Build an annotation value with CamlPDF-compatible defaults.
///
/// Defaults are no contents, no subject, a zero rectangle, default border, no
/// colour, and no preserved extra dictionary entries.
pub fn pdf_annotation_make(
  subtype : PdfAnnotationSubtype,
  contents~ : PdfBytes? = None,
  border~ : PdfAnnotationBorder = pdf_annotation_default_border(),
  rectangle~ : PdfRectangle = pdf_annotation_zero_rectangle(),
  colour~ : PdfAnnotationColour? = None,
  subject~ : PdfBytes? = None,
) -> PdfAnnotation {
  { subtype, contents, subject, rectangle, border, colour, rest: PdfNull, }
}

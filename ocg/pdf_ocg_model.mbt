///|
/// Usage dictionary for a PDF optional content group.
///
/// Byte fields preserve PDF string bytes exactly. Name fields preserve the
/// corresponding PDF names for creator, language, export, zoom, print, view,
/// user, and page-element usage hints.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfOcgUsage {
  creator_info : (PdfBytes, PdfName)?
  language : (PdfBytes, PdfName?)?
  export_state : PdfName?
  zoom_min : Double?
  zoom_max : Double?
  print_subtype : PdfName?
  print_state : PdfName?
  view_state : PdfName?
  user : (PdfName, Array[PdfBytes])?
  page_element_subtype : PdfName?
}

///|
pub extend PdfOcgUsage with Debug::{to_repr}

///|
pub extend PdfOcgUsage with Eq::{not_equal, equal}

///|
pub extend PdfOcgUsage with ToJson::{to_json}

///|
/// One PDF optional content group dictionary.
///
/// The group's indirect object number is stored outside this record in
/// `PdfOptionalContent.ocgs`; `name` is the raw PDF string bytes.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfOcg {
  name : PdfBytes
  intent : Array[PdfName]
  usage : PdfOcgUsage?
}

///|
pub extend PdfOcg with Debug::{to_repr}

///|
pub extend PdfOcg with Eq::{not_equal, equal}

///|
pub extend PdfOcg with ToJson::{to_json}

///|
/// Default visibility state for optional content groups in a configuration.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfOcgState {
  OcgOn
  OcgOff
  OcgUnchanged
}

///|
pub extend PdfOcgState with Debug::{to_repr}

///|
pub extend PdfOcgState with Eq::{not_equal, equal}

///|
pub extend PdfOcgState with ToJson::{to_json}

///|
/// Policy for whether the layer list is shown on all pages or only visible pages.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfOcgListMode {
  OcgAllPages
  OcgVisiblePages
}

///|
pub extend PdfOcgListMode with Debug::{to_repr}

///|
pub extend PdfOcgListMode with Eq::{not_equal, equal}

///|
pub extend PdfOcgListMode with ToJson::{to_json}

///|
/// Event context used by optional-content usage application dictionaries.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfOcgEvent {
  OcgView
  OcgPrint
  OcgExport
}

///|
pub extend PdfOcgEvent with Debug::{to_repr}

///|
pub extend PdfOcgEvent with Eq::{not_equal, equal}

///|
pub extend PdfOcgEvent with ToJson::{to_json}

///|
/// Optional-content usage application dictionary.
///
/// `ocgs` contains indirect object numbers of optional content groups, and
/// `category` stores the PDF usage-category names for the application.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfOcgAppDict {
  event : PdfOcgEvent
  ocgs : Array[Int32]
  category : Array[PdfName]
}

///|
pub extend PdfOcgAppDict with Debug::{to_repr}

///|
pub extend PdfOcgAppDict with Eq::{not_equal, equal}

///|
pub extend PdfOcgAppDict with ToJson::{to_json}

///|
/// Optional-content configuration dictionary.
///
/// Arrays such as `on`, `off`, `locked`, radio-button groups, and order entries
/// contain OCG indirect object numbers. `order` preserves the PDF layer-panel
/// grouping labels as raw string bytes.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfOcgConfig {
  name : PdfBytes?
  creator : PdfBytes?
  base_state : PdfOcgState
  on : Array[Int32]
  off : Array[Int32]
  intent : Array[PdfName]
  usage_applications : Array[PdfOcgAppDict]
  order : Array[(PdfBytes?, Array[Int32])]?
  list_mode : PdfOcgListMode
  radio_button_groups : Array[Array[Int32]]?
  locked : Array[Int32]
}

///|
pub extend PdfOcgConfig with Debug::{to_repr}

///|
pub extend PdfOcgConfig with Eq::{not_equal, equal}

///|
pub extend PdfOcgConfig with ToJson::{to_json}

///|
/// Complete catalog optional-content properties.
///
/// `ocgs` pairs each group's existing indirect object number with the parsed
/// group dictionary. `default_config` maps `/D`; `configs` maps alternate
/// entries from `/Configs`.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfOptionalContent {
  ocgs : Array[(Int32, PdfOcg)]
  default_config : PdfOcgConfig
  configs : Array[PdfOcgConfig]
}

///|
pub extend PdfOptionalContent with Debug::{to_repr}

///|
pub extend PdfOptionalContent with Eq::{not_equal, equal}

///|
pub extend PdfOptionalContent with ToJson::{to_json}

///|
fn pdf_ocg_default_view_name() -> PdfName {
  @core.pdf_name_of_bytes(@ascii.encode("/View"))
}

///|
/// Return the PDF default optional-content configuration used when none is set.
///
/// The default has base state `OcgOn`, `/Intent /View`, no explicit on/off
/// lists, no order, no radio-button groups, and no locked groups.
pub fn pdf_ocg_default_config() -> PdfOcgConfig {
  {
    name: None,
    creator: None,
    base_state: OcgOn,
    on: [],
    off: [],
    intent: [pdf_ocg_default_view_name()],
    usage_applications: [],
    order: None,
    list_mode: OcgAllPages,
    radio_button_groups: None,
    locked: [],
  }
}

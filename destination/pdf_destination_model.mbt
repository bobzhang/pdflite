///|
/// A destination target page reference.
///
/// PDF destination arrays may refer either to a page object or to a page number
/// in another document.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfTargetPage {
  TargetPageObject(Int32)
  TargetOtherDocPageNumber(Int32)
}

///|
pub extend PdfTargetPage with Debug::{to_repr}

///|
pub extend PdfTargetPage with Eq::{not_equal, equal}

///|
pub extend PdfTargetPage with ToJson::{to_json}

///|
/// A normalized PDF destination.
///
/// The variants cover action dictionaries, named/string destinations, null
/// destinations, and all standard page-view destination array forms.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfDestination {
  DestAction(@syntax.PdfObject)
  DestNull
  DestNamed(@core.PdfName)
  DestString(@core.PdfBytes)
  DestXYZ(PdfTargetPage, Double?, Double?, Double?)
  DestFit(PdfTargetPage)
  DestFitH(PdfTargetPage, Double?)
  DestFitV(PdfTargetPage, Double?)
  DestFitR(PdfTargetPage, Double, Double, Double, Double)
  DestFitB(PdfTargetPage)
  DestFitBH(PdfTargetPage, Double?)
  DestFitBV(PdfTargetPage, Double?)
}

///|
pub extend PdfDestination with Debug::{to_repr}

///|
pub extend PdfDestination with Eq::{not_equal, equal}

///|
pub extend PdfDestination with ToJson::{to_json}

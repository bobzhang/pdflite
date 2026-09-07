///|
/// Colour value used by cpdf-style content colour rewrite operations.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfContentColour {
  PdfContentGrey(Double)
  PdfContentRGB(Double, Double, Double)
  PdfContentCMYK(Double, Double, Double, Double)
}

///|
pub extend PdfContentColour with Debug::{to_repr}

///|
pub extend PdfContentColour with Eq::{not_equal, equal}

///|
pub extend PdfContentColour with ToJson::{to_json}

///|
/// The default black content colour.
pub let pdf_content_black : PdfContentColour = PdfContentGrey(0.0)

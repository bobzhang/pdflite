///|
/// Encoding policy used when reading PDF information dictionary metadata.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfMetadataEncoding {
  PdfMetadataRaw
  PdfMetadataUTF8
  PdfMetadataStripped
}

///|
pub extend PdfMetadataEncoding with Debug::{to_repr}

///|
pub extend PdfMetadataEncoding with Eq::{not_equal, equal}

///|
pub extend PdfMetadataEncoding with ToJson::{to_json}

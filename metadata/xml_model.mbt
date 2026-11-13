///|
/// Qualified XML name used by the metadata XML tree parser.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfMetadataXmlName {
  uri : String
  local_name : String
  prefix : String?
}

///|
pub extend PdfMetadataXmlName with Debug::{to_repr}

///|
pub extend PdfMetadataXmlName with Eq::{not_equal, equal}

///|
pub extend PdfMetadataXmlName with ToJson::{to_json}

///|
/// XML attribute used by the metadata XML tree parser.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfMetadataXmlAttribute {
  name : PdfMetadataXmlName
  value : String
}

///|
pub extend PdfMetadataXmlAttribute with Debug::{to_repr}

///|
pub extend PdfMetadataXmlAttribute with Eq::{not_equal, equal}

///|
pub extend PdfMetadataXmlAttribute with ToJson::{to_json}

///|
/// XML element tag name and attributes used by metadata trees.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfMetadataXmlTag {
  name : PdfMetadataXmlName
  attributes : Array[PdfMetadataXmlAttribute]
}

///|
pub extend PdfMetadataXmlTag with Debug::{to_repr}

///|
pub extend PdfMetadataXmlTag with Eq::{not_equal, equal}

///|
pub extend PdfMetadataXmlTag with ToJson::{to_json}

///|
/// Minimal XML tree representation used for XMP metadata.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfMetadataXmlTree {
  PdfMetadataXmlElement(PdfMetadataXmlTag, Array[PdfMetadataXmlTree])
  PdfMetadataXmlData(String)
}

///|
pub extend PdfMetadataXmlTree with Debug::{to_repr}

///|
pub extend PdfMetadataXmlTree with Eq::{not_equal, equal}

///|
pub extend PdfMetadataXmlTree with ToJson::{to_json}

///|
/// Parsed XML metadata document with an optional DTD fragment.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfMetadataXmlDocument {
  dtd : String?
  tree : PdfMetadataXmlTree
}

///|
pub extend PdfMetadataXmlDocument with Debug::{to_repr}

///|
pub extend PdfMetadataXmlDocument with Eq::{not_equal, equal}

///|
pub extend PdfMetadataXmlDocument with ToJson::{to_json}

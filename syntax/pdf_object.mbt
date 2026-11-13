///|
/// A deferred stream-data slice read from an input cursor.
///
/// `position` and `length` identify the raw byte range in `input`; `crypt`
/// records the decryption operation to apply when the bytes are materialized.
/// This lets the reader keep large stream bodies lazy until a caller requests
/// their bytes.
#derive(Debug, Eq, ToJson)
pub(all) struct ToGet {
  input : @core.ByteCursor
  position : Int32
  length : Int32
  crypt : PdfStreamDataCrypt
}

///|
pub extend ToGet with Debug::{to_repr}

///|
pub extend ToGet with Eq::{not_equal, equal}

///|
pub extend ToGet with ToJson::{to_json}

///|
/// Storage state for a PDF stream body.
///
/// `StreamGot` stores already materialized bytes. `StreamToGet` stores a
/// deferred slice of an input buffer, optionally with stream decryption metadata
/// that is applied when the data is read.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfStreamData {
  StreamGot(@core.PdfBytes)
  StreamToGet(ToGet)
}

///|
pub extend PdfStreamData with Debug::{to_repr}

///|
pub extend PdfStreamData with Eq::{not_equal, equal}

///|
pub extend PdfStreamData with ToJson::{to_json}

///|
/// Decryption metadata associated with deferred stream data.
///
/// The variants correspond to the stream ciphers supported by the PDF security
/// handler. Object-specific ciphers store object number, generation, file key,
/// and key length; AES-V3 stores the already derived file key.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfStreamDataCrypt {
  PdfStreamDataNoCrypt
  PdfStreamDataArc4Decrypt(Int32, Int32, @core.PdfBytes, Int32)
  PdfStreamDataAesV2Decrypt(Int32, Int32, @core.PdfBytes, Int32)
  PdfStreamDataAesV3Decrypt(@core.PdfBytes)
}

///|
pub extend PdfStreamDataCrypt with Debug::{to_repr}

///|
pub extend PdfStreamDataCrypt with Eq::{not_equal, equal}

///|
pub extend PdfStreamDataCrypt with ToJson::{to_json}

///|
/// A PDF stream object: dictionary metadata plus stream bytes.
///
/// The dictionary and data fields are mutable because helpers such as
/// `get_stream` and the dictionary update methods materialize stream data and
/// update stream dictionaries in place.
#derive(Debug, Eq, ToJson)
pub(all) struct PdfStream {
  mut dictionary : PdfObject
  mut data : PdfStreamData
}

///|
pub extend PdfStream with Debug::{to_repr}

///|
pub extend PdfStream with Eq::{not_equal, equal}

///|
pub extend PdfStream with ToJson::{to_json}

///|
/// The core in-memory representation of a parsed PDF object.
///
/// Strings and names are byte-oriented PDF values, not MoonBit Unicode strings.
/// `PdfIndirect(number)` is an unresolved reference by object number; callers
/// that need the referenced object should resolve it through a `PdfDocument`.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfObject {
  PdfNull
  PdfBoolean(Bool)
  PdfInteger(Int32)
  PdfReal(Double)
  PdfString(@core.PdfBytes)
  PdfNameObject(@core.PdfName)
  PdfArray(Array[PdfObject])
  PdfDictionary(Array[(@core.PdfName, PdfObject)])
  PdfStreamObject(PdfStream)
  PdfIndirect(Int32)
}

///|
pub extend PdfObject with Debug::{to_repr}

///|
pub extend PdfObject with Eq::{not_equal, equal}

///|
pub extend PdfObject with ToJson::{to_json}

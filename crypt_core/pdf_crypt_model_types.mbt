///|
/// Encryption method detected from or requested for a document.
///
/// AES entries carry the effective `EncryptMetadata` flag. The
/// `PdfEncryptionAlreadyEncrypted` value is used by writer paths that preserve
/// existing encrypted object data rather than decrypting and re-encrypting it.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfEncryptionMethod {
  PdfEncryption40Bit
  PdfEncryption128Bit
  PdfEncryptionAES128(Bool)
  PdfEncryptionAES256(Bool)
  PdfEncryptionAES256ISO(Bool)
  PdfEncryptionAlreadyEncrypted
}

///|
pub extend PdfEncryptionMethod with Debug::{to_repr}

///|
pub extend PdfEncryptionMethod with Eq::{not_equal, equal}

///|
pub extend PdfEncryptionMethod with ToJson::{to_json}

///|
/// Random material requested while constructing PDF 2.0 AESV3 encryption data.
///
/// Provider callbacks receive this field tag and a byte length, allowing tests
/// and reproducible builds to supply deterministic file keys, salts, and
/// permissions padding.
#derive(Debug, Eq, ToJson)
pub(all) enum PdfAesV3RandomField {
  PdfAesV3FileKey
  PdfAesV3UserValidationSalt
  PdfAesV3UserKeySalt
  PdfAesV3OwnerValidationSalt
  PdfAesV3OwnerKeySalt
  PdfAesV3PermissionsPadding
}

///|
pub extend PdfAesV3RandomField with Debug::{to_repr}

///|
pub extend PdfAesV3RandomField with Eq::{not_equal, equal}

///|
pub extend PdfAesV3RandomField with ToJson::{to_json}

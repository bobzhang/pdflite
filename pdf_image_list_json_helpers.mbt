///|
fn pdf_image_json_int(value : Int32) -> Json {
  Json::number(value.to_double(), repr=value.to_string())
}

///|
fn pdf_image_json_int_or_null(value : Int32?) -> Json {
  match value {
    Some(value) => pdf_image_json_int(value)
    None => Json::null()
  }
}

///|
fn pdf_image_json_string_or_null(value : String?) -> Json {
  match value {
    Some(value) => Json::string(value)
    None => Json::null()
  }
}

///|
fn pdf_image_name_to_string(
  name : @core.PdfName,
) -> String raise @core.PdfError {
  @ascii.decode(name.bytes()) catch {
    _ =>
      @ascii.decode(pdf_write_object(PdfNameObject(name))) catch {
        _ => raise InvalidUTF8
      }
  }
}

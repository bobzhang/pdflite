///|
fn pdf_addtext_validate_page_numbers(
  page_numbers : ArrayView[Int32],
  end_page : Int32,
  context : String,
) -> Unit raise @core.PdfError {
  for page_number in page_numbers {
    if page_number < 1 || page_number > end_page {
      raise BadPageSpecification(
        context + ": range contains pages not present in pdf",
      )
    }
  }
}

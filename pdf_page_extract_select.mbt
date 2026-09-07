///|
fn pdf_page_select_pages(
  pages : ArrayView[@page.PdfPage],
  page_numbers : ArrayView[Int32],
) -> Array[@page.PdfPage] raise @core.PdfError {
  if page_numbers.length() == 0 {
    raise PageTreeExpected
  }
  let selected : Array[@page.PdfPage] = Array(capacity=page_numbers.length())
  for page_number in page_numbers {
    if page_number < 1 || page_number > pages.length() {
      raise PageTreeExpected
    }
    selected.push(pages[page_number - 1])
  }
  selected
}

///|
fn pdf_page_select_numbers(
  numbers : ArrayView[Int32],
  page_numbers : ArrayView[Int32],
) -> Array[Int32] raise @core.PdfError {
  if page_numbers.length() == 0 {
    raise PageTreeExpected
  }
  let selected : Array[Int32] = Array(capacity=page_numbers.length())
  for page_number in page_numbers {
    if page_number < 1 || page_number > numbers.length() {
      raise PageTreeExpected
    }
    selected.push(numbers[page_number - 1])
  }
  selected
}

///|
fn pdf_page_number_index(numbers : ArrayView[Int32], number : Int32) -> Int32? {
  for i in 0..<numbers.length() {
    if numbers[i] == number {
      break Some(i)
    }
  } nobreak {
    None
  }
}

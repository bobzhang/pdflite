///|
priv enum PdfPageSpecToken {
  PageSpecNumber(Int32)
  PageSpecWord(String)
  PageSpecDash
  PageSpecComma
}

///|
priv struct PdfPageSpecContext {
  end_page : Int32
  selectors : PdfPageSpecSelectors?
  source : String
}

///|
fn PdfPageSpecContext::bad(self : PdfPageSpecContext) -> Unit raise PdfError {
  raise BadPageSpecification(self.source)
}

///|
/// Document-dependent hooks used by the page-spec parser.
///
/// Pure count-based parsing passes no selectors. Document parsing supplies
/// selectors for page labels, orientation filters, and annotation filters.
pub(all) struct PdfPageSpecSelectors {
  resolve_references : (BytesView) -> Bytes raise PdfError
  select_dimensions : (ArrayView[Int32], Bool) -> Array[Int32] raise PdfError
  select_annotated : (ArrayView[Int32]) -> Array[Int32] raise PdfError
}

///|
fn PdfPageSpecContext::resolve_references(
  self : PdfPageSpecContext,
  spec : BytesView,
) -> Bytes raise PdfError {
  match self.selectors {
    Some(selectors) => (selectors.resolve_references)(spec)
    None => spec.to_owned()
  }
}

///|
fn PdfPageSpecContext::select_dimensions(
  self : PdfPageSpecContext,
  candidates : ArrayView[Int32],
  portrait : Bool,
) -> Array[Int32] raise PdfError {
  match self.selectors {
    Some(selectors) => (selectors.select_dimensions)(candidates, portrait)
    None => {
      self.bad()
      []
    }
  }
}

///|
fn PdfPageSpecContext::select_annotated(
  self : PdfPageSpecContext,
  candidates : ArrayView[Int32],
) -> Array[Int32] raise PdfError {
  match self.selectors {
    Some(selectors) => (selectors.select_annotated)(candidates)
    None => {
      self.bad()
      []
    }
  }
}

///|
priv struct PdfPageReferenceMap {
  values : @hashmap.HashMap[Int32, Int32]
}

///|
fn pdf_page_reference_map(
  changes : ArrayView[(Int32, Int32)],
) -> PdfPageReferenceMap {
  let values : @hashmap.HashMap[Int32, Int32] = HashMap([])
  for change in changes {
    let (old_number, new_number) = change
    if !values.contains(old_number) {
      values[old_number] = new_number
    }
  }
  { values, }
}

///|
fn PdfPageReferenceMap::changed_reference(
  self : PdfPageReferenceMap,
  number : Int32,
) -> Int32 {
  match self.values.get(number) {
    Some(new_number) => new_number
    None => number
  }
}

///|
fn pdf_page_renumber_object_with_map(
  object : @syntax.PdfObject,
  changes : PdfPageReferenceMap,
) -> @syntax.PdfObject {
  match object {
    PdfIndirect(number) => PdfIndirect(changes.changed_reference(number))
    PdfArray(items) => {
      let output : Array[@syntax.PdfObject] = Array(capacity=items.length())
      for item in items {
        output.push(pdf_page_renumber_object_with_map(item, changes))
      }
      PdfArray(output)
    }
    PdfDictionary(entries) => {
      let output : Array[(@core.PdfName, @syntax.PdfObject)] = Array(
        capacity=entries.length(),
      )
      for entry in entries {
        let (key, value) = entry
        output.push((key, pdf_page_renumber_object_with_map(value, changes)))
      }
      PdfDictionary(output)
    }
    PdfStreamObject(stream) =>
      PdfStreamObject({
        dictionary: pdf_page_renumber_object_with_map(
          stream.dictionary,
          changes,
        ),
        data: stream.data,
      })
    _ => object
  }
}

///|
fn pdf_page_renumber_entry_with_map(
  entry : PdfObjectEntry,
  changes : PdfPageReferenceMap,
) -> PdfObjectEntry {
  match entry.data {
    ObjectParsed(object) =>
      {
        data: ObjectParsed(pdf_page_renumber_object_with_map(object, changes)),
        generation: entry.generation,
      }
    ObjectParsedAlreadyDecrypted(object) =>
      {
        data: ObjectParsedAlreadyDecrypted(
          pdf_page_renumber_object_with_map(object, changes),
        ),
        generation: entry.generation,
      }
    _ => { data: entry.data, generation: entry.generation, }
  }
}

///|
fn PdfDocument::pdf_page_renumber_references(
  self : PdfDocument,
  changes : ArrayView[(Int32, Int32)],
) -> Unit {
  let change_map = pdf_page_reference_map(changes)
  for number in self.object_numbers() {
    let entry = self.objects.get_entry(number).unwrap()
    self.objects.set_entry(
      number,
      pdf_page_renumber_entry_with_map(entry, change_map),
    )
  }
}

///|
fn pdf_page_reference_changes(
  old_numbers : ArrayView[Int32],
  new_numbers : ArrayView[Int32],
) -> Array[(Int32, Int32)] raise @core.PdfError {
  if old_numbers.length() != new_numbers.length() {
    raise PageTreeExpected
  }
  let changes : Array[(Int32, Int32)] = Array(capacity=old_numbers.length())
  for i in 0..<old_numbers.length() {
    changes.push((old_numbers[i], new_numbers[i]))
  }
  changes
}

///|
fn pdf_page_reference_changes_from_serials(
  old_numbers : ArrayView[Int32],
  new_numbers : ArrayView[Int32],
  changes : ArrayView[(Int32, Int32)],
) -> Array[(Int32, Int32)] raise @core.PdfError {
  let output : Array[(Int32, Int32)] = Array(capacity=changes.length())
  for change in changes {
    let (old_page, new_page) = change
    if old_page < 1 ||
      old_page > old_numbers.length() ||
      new_page < 1 ||
      new_page > new_numbers.length() {
      raise PageTreeExpected
    }
    output.push((old_numbers[old_page - 1], new_numbers[new_page - 1]))
  }
  output
}

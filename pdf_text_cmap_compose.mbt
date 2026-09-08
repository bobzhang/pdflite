///|
fn pdf_text_tounicode_has_charcode(
  entries : ArrayView[(Int32, @core.PdfBytes)],
  code : Int32,
) -> Bool {
  for entry in entries {
    if entry.0 == code {
      break true
    }
  } nobreak {
    false
  }
}

///|
fn pdf_text_compose_tounicode_entries(
  current : ArrayView[(Int32, @core.PdfBytes)],
  inherited : ArrayView[(Int32, @core.PdfBytes)],
) -> Array[(Int32, @core.PdfBytes)] {
  let output : Array[(Int32, @core.PdfBytes)] = Array::new(
    capacity=current.length() + inherited.length(),
  )
  let seen : @hashmap.HashMap[Int32, Bool] = HashMap([])
  for entry in current {
    output.push(entry)
    seen[entry.0] = true
  }
  for entry in inherited {
    if !seen.contains(entry.0) {
      seen[entry.0] = true
      output.push(entry)
    }
  }
  output
}

///|
fn pdf_text_compose_cid_entries(
  current : ArrayView[(Int32, Int32)],
  inherited : ArrayView[(Int32, Int32)],
) -> Array[(Int32, Int32)] {
  let output : Array[(Int32, Int32)] = Array::new(
    capacity=current.length() + inherited.length(),
  )
  let seen : @hashmap.HashMap[Int32, Bool] = HashMap([])
  for entry in current {
    output.push(entry)
    seen[entry.0] = true
  }
  for entry in inherited {
    if !seen.contains(entry.0) {
      seen[entry.0] = true
      output.push(entry)
    }
  }
  output
}

///|
fn pdf_text_compose_codespaces(
  current : ArrayView[PdfCMapCodeSpace],
  inherited : ArrayView[PdfCMapCodeSpace],
) -> Array[PdfCMapCodeSpace] {
  let output : Array[PdfCMapCodeSpace] = Array::new(
    capacity=current.length() + inherited.length(),
  )
  for entry in current {
    output.push(entry)
  }
  for entry in inherited {
    output.push(entry)
  }
  output
}

///|
fn pdf_text_compose_parsed_cmap(
  current : PdfParsedCMap,
  inherited : PdfParsedCMap,
) -> PdfParsedCMap {
  {
    map: pdf_text_compose_tounicode_entries(current.map, inherited.map),
    cid_map: pdf_text_compose_cid_entries(current.cid_map, inherited.cid_map),
    notdef_map: pdf_text_compose_cid_entries(
      current.notdef_map,
      inherited.notdef_map,
    ),
    codespaces: pdf_text_compose_codespaces(
      current.codespaces,
      inherited.codespaces,
    ),
    usecmap: match current.usecmap {
      Some(_) => current.usecmap
      None => inherited.usecmap
    },
    wmode: match current.wmode {
      Some(_) => current.wmode
      None => inherited.wmode
    },
    cmap_name: match current.cmap_name {
      Some(_) => current.cmap_name
      None => inherited.cmap_name
    },
    cmap_type: match current.cmap_type {
      Some(_) => current.cmap_type
      None => inherited.cmap_type
    },
    cid_system_info: match current.cid_system_info {
      Some(_) => current.cid_system_info
      None => inherited.cid_system_info
    },
  }
}

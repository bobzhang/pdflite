///|
fn pdf_text_cns1_codepoint_of_cid(cid : Int32) -> Int32? {
  guard cid >= 0 && cid < @cmapdata.pdf_text_cns1_unicode_table.length() else {
    return None
  }
  let codepoint = @cmapdata.pdf_text_cns1_unicode_table[cid]
  if codepoint == 0 {
    None
  } else {
    Some(codepoint)
  }
}

///|
fn pdf_text_gb1_codepoint_of_cid(cid : Int32) -> Int32? {
  guard cid >= 0 && cid < @cmapdata.pdf_text_gb1_unicode_table.length() else {
    return None
  }
  let codepoint = @cmapdata.pdf_text_gb1_unicode_table[cid]
  if codepoint == 0 {
    None
  } else {
    Some(codepoint)
  }
}

///|
fn pdf_text_predefined_cns1_codepoint(
  ranges : Array[(Int32, Int32, Int32)],
  code : Int32,
) -> Int32? {
  match pdf_text_predefined_cid_range_lookup(ranges, code) {
    Some(cid) => pdf_text_cns1_codepoint_of_cid(cid)
    None => None
  }
}

///|
fn pdf_text_predefined_cns1_codepoint_unsigned(
  ranges : Array[(Int32, Int32, Int32)],
  code : Int32,
) -> Int32? {
  match pdf_text_predefined_cid_range_lookup_unsigned(ranges, code) {
    Some(cid) => pdf_text_cns1_codepoint_of_cid(cid)
    None => None
  }
}

///|
fn pdf_text_predefined_cns1_charcode(
  ranges : Array[(Int32, Int32, Int32)],
  codepoint : Int32,
) -> Int32? {
  pdf_text_predefined_unicode_table_charcode(
    @cmapdata.pdf_text_cns1_unicode_table, ranges, codepoint,
  )
}

///|
fn pdf_text_predefined_cns1_builtin_codepoints(
  name : @core.PdfName,
  code : Int32,
) -> Array[Int32]? {
  match
    pdf_text_predefined_vertical_codepoint(
      pdf_text_predefined_cns1_vertical_codepoint_table(name),
      code,
    ) {
    Some(codepoint) => Some([codepoint])
    None =>
      match pdf_text_predefined_cns1_b5_cid_ranges(name) {
        Some(ranges) =>
          match pdf_text_predefined_cns1_codepoint(ranges, code) {
            Some(codepoint) => Some([codepoint])
            None => None
          }
        None =>
          if pdf_text_predefined_cmap_uses_hkscs_charcodes(name) {
            match pdf_text_predefined_hkscs_codepoint(code) {
              Some(codepoint) => Some([codepoint])
              None => None
            }
          } else {
            match pdf_text_predefined_cns_euc_cid_ranges(name) {
              Some(ranges) =>
                match
                  pdf_text_predefined_cns1_codepoint_unsigned(ranges, code) {
                  Some(codepoint) => Some([codepoint])
                  None => None
                }
              None =>
                if pdf_text_predefined_cmap_uses_b5pc_charcodes(name) {
                  match pdf_text_predefined_b5pc_codepoint(code) {
                    Some(codepoint) => Some([codepoint])
                    None => None
                  }
                } else if pdf_text_predefined_cmap_uses_big5_charcodes(name) {
                  match pdf_text_predefined_big5_codepoint(code) {
                    Some(codepoint) => Some([codepoint])
                    None => None
                  }
                } else {
                  None
                }
            }
          }
      }
  }
}

///|
fn pdf_text_predefined_cns1_builtin_charcode(
  name : @core.PdfName,
  codepoint : Int32,
) -> Int32? {
  match
    pdf_text_predefined_vertical_charcode(
      pdf_text_predefined_cns1_vertical_charcode_table(name),
      codepoint,
    ) {
    Some(code) => Some(code)
    None =>
      match pdf_text_predefined_cns1_b5_cid_ranges(name) {
        Some(ranges) => pdf_text_predefined_cns1_charcode(ranges, codepoint)
        None =>
          if pdf_text_predefined_cmap_uses_hkscs_charcodes(name) {
            pdf_text_predefined_hkscs_charcode(codepoint)
          } else {
            match pdf_text_predefined_cns_euc_cid_ranges(name) {
              Some(ranges) =>
                pdf_text_predefined_cns1_charcode(ranges, codepoint)
              None =>
                if pdf_text_predefined_cmap_uses_b5pc_charcodes(name) {
                  pdf_text_predefined_b5pc_charcode(codepoint)
                } else if pdf_text_predefined_cmap_uses_big5_charcodes(name) {
                  pdf_text_predefined_big5_charcode(codepoint)
                } else {
                  None
                }
            }
          }
      }
  }
}

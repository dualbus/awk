function event_field(f) {
  printf "%s@@", csv_escape_field(f);
}

function event_record(f) {
  printf "%s\r\n", csv_escape_field(f);
}

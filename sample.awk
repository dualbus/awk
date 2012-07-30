function event_field(f) {
    f = csv_escape_field(f);
    printf "%s,", f;
}
function event_record(f) {
    f = csv_escape_field(f);
    printf "%s\r\n", f;
}

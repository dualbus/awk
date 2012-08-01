function escape(f) {
    gsub(/[\n]/, "\\n", f);
    gsub(/[\r]/, "\\r", f);
    gsub(/[\f]/, "\\f", f);
    gsub(/[\t]/, "\\t", f);
    gsub(/[\v]/, "\\v", f);
    return f;
}

function event_field(f) {
    f = escape(f);
    printf "%s\t", f;
}

function event_record(f) {
    f = escape(f);
    printf "%s\n", f;
}

#!/usr/bin/awk -f

function unescape_string(s) {
    t = "";
    while(0 < match(s, /\\./)) {
        t = t substr(s, 1, RSTART-1);
        e = substr(s, RSTART, RLENGTH);
        sub(/\\"/,  "\"",  e);
        sub(/\\n/,  "\n",  e);
        sub(/\\r/,  "\r",  e);
        sub(/\\f/,  "\f",  e);
        sub(/\\t/,  "\t",  e);
        sub(/\\v/,  "\v",  e);
        sub(/\\\\/, "\\",  e);
        t = t e;
        s = substr(s, RSTART+RLENGTH);
    }
    return (t s);
}

{
    if(0 >= (i=index($0, ":"))) {
        print "XXX";
        exit 1;
    }
    #substr($0, 1, i-1);
    s = substr($0, i+1);
    gsub(/^[[:space:]]+|[[:space:]]$/, "", s);
    if("\"" == substr(s, 1, 1) && "\"" == substr(s, length(s))) {
        s = substr(s, 2, length(s)-2);
    }
    printf "%s", unescape_string(s);
}

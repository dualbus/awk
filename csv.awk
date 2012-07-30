#!/usr/bin/awk -f

# Awk implementation of RFC4180 <http://www.ietf.org/rfc/rfc4180.txt>.

function die(i, s, c, msg) {
    error_fmt = "E [R=%d,C=%d,s=%d,\"i=%s\"]: %s.\n";
    gsub(/"/, "\"\"", c);
    printf error_fmt, NR, i, s, c, msg > "/dev/stderr";
    exit 1;
}

function escape_field(f,    i, e, n) {
    n = length(f);
    e = 0;
    for(i = 1; i <= n; i++) {
        if(0 >= index(T, substr(f, i, 1))) {
            e = 1;
            break;
        }
    }
    if(0 < e) {
        gsub(/"/, "\"\"", f);
        f = "\""(f)"\"";
    }
    return f;
}

function event_field(f,    i, n) {
    f = escape_field(f);
    printf "%s,", f;
}

function event_record(f) {
    f = escape_field(f);
    printf "%s\r\n", f;
}

BEGIN {
    FS = "";

    s = 1;
    T = "";
    T = T" !#$%&'()*+-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abc";
    T = T"defghijklmnopqrstuvwxyz{|}~";
}

{
    n = length;
    for(i = 1; i <= n + 1; i++) {
        c = substr($0, i, 1);
        c = (c == "") ? "\n" : c;

        if(1 == s) {
            if("\"" == c) {
                s = 2;
                c = "";
            } else
            if(0 < index(T, c)) {
                # Change to c ~ re & test.
                s = 4;
            } else {
            if("," == c) {
            } else
            if("\r" == c) {
                s = 5;
                c = "";
            } else
            if("\n" == c) {
                s = 6;
            } else
                die(i, s, c, "Expecting DQUOTE, TEXTDATA, COMMA, CR, or LF");
            }
        } else
        if(2 == s) {
            if("\"" == c) {
                s = 3;
                c = "";
            } else
            if(!(0 < index(T, c) || c ~ /[,\r\n]/)) {
                die(i, s, c, "Unexpected character");
            }
        } else
        if(3 == s) {
            if("\"" == c) {
                s = 2;
            } else
            if("," == c) {
                s = 1;
            } else
            if("\r" == c) {
                s = 5;
                c = "";
            } else
            if("\n" == c) {
                s = 6;
            } else {
                die(i, s, c, "Expecting DQUOTE, COMMA, CR, or LF");
            }
        } else
        if(4 == s) {
            if(0 < index(T, c)) {
            } else
            if("," == c) {
                s = 1;
            } else
            if("\r" == c) {
                s = 5;
                c = "";
            } else
            if("\n" == c) {
                s = 6;
            } else {
                die(i, s, c, "Expecting TEXTDATA");
            }
        } else
        if(5 == s) {
            if("\n" == c) {
                s = 6;
            } else {
                die(i, s, c, "Expecting LF");
            }
        }

        if(1 == s) {
            event_field(f);
            f = "";
        } else
        if(6 == s) {
            event_record(f);
            f = "";
            s = 1;
        } else {
            f = f c;
        }
    }
}

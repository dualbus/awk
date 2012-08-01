#!/usr/bin/awk -f

# Awk implementation of (almost) RFC4180 <http://www.ietf.org/rfc/rfc4180.txt>.

function die(i, s, c, msg) {
    error_fmt = "E [R=%d,C=%d,s=%d,\"i=%s\"]: %s.\n";
    gsub(/"/, "\"\"", c);
    printf error_fmt, NR, i, s, c, msg > "/dev/stderr";
    exit 1;
}

function csv_escape_field(f,    i, e, n) {
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

BEGIN {
    FS = "";

    s = 1;
#    RFC = "^[";
#    RFC = RFC"] !#$%&'()*+./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\\\\_`";
#    RFC = RFC"abcdefghijklmnopqrstuvwxyz{|}~^[-";
#    RFC = RFC"]$";
#    XRFC = "^[\f\t\v]$";
}

{
    n = length;
    for(i = 1; i <= n + 1; i++) {
        c = substr($0, i, 1);

        if(4 == s) {
            if("," == c) {
                s = 1;
                event_field(f);
                f = "";
                continue;
            } else
            if("\r" == c) {
                if(i == n) {
                    s = 1;
                    event_record(f);
                    f = "";
                    continue;
                } else {
                    die(i, s, c, "Expecting LF");
                }
            } else
            if("" == c) {
                s = 1;
                event_record(f);
                f = "";
            }
        } else
        if(2 == s) {
            if("\"" == c) {
                s = 3;
                c = "";
            } else
            if("" == c) {
                c = "\n";
            }
        } else
        if(1 == s) {
            if("\"" == c) {
                s = 2;
                c = "";
            } else
            if("," == c) {
                event_field(f);
                f = "";
                continue;
            } else
            if("\r" == c) {
                if(i == n) {
                    event_record(f);
                    f = "";
                    continue;
                } else {
                    die(i, s, c, "Expecting LF");
                }
            } else
            if("" == c) {
                s = 1;
                event_record(f);
                f = "";
            } else {
                s = 4;
            }
        } else
        if(3 == s) {
            if("\"" == c) {
                s = 2;
            } else
            if("," == c) {
                s = 1;
                event_field(f);
                f = "";
                continue;
            } else
            if("\r" == c) {
                if(i == n) {
                    s = 1;
                    event_record(f);
                    f = "";
                    continue;
                } else {
                    die(i, s, c, "Expecting LF");
                }
            } else
            if("" == c) {
                s = 1;
                event_record(f);
                f = "";
            } else {
                die(i, s, c, "Expecting DQUOTE, COMMA, CR, or LF");
            }
        }
        f = f c;
    }
}

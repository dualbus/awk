#!/usr/bin/awk -f

function escape_string(s) {
    gsub(/\\/,  "\\\\", s);
    gsub(/"/,   "\\\"", s);
    gsub(/\n/,  "\\n",  s);
    gsub(/\r/,  "\\r",  s);
    gsub(/\f/,  "\\f",  s);
    gsub(/\t/,  "\\t",  s);
    gsub(/\v/,  "\\v",  s);
    return s;
}

BEGIN {
    FS = "";
}

# Pattern file.
NR == FNR {
    if(0 >= (i=index($0, ":"))) {
        print "XXX";
        exit 1;
    }
    p++;
    Pk[p] = substr($0, 1, i-1);
    Pv[p] = substr($0, i+1);
    Ps[p] = 0;
    gsub(/^[[:space:]]+|[[:space:]]$/, "", Pv[p]);
    next;
}

# Input stream.
{
    f = f $0 "\n";
}

END {
    while(length(f)) {
        delete M;

        m = 0;
        for(i = 1; i <= p; i++) {
            if(1 != match(f, Pv[i]) || 0 >= RLENGTH) {
                continue;
            }
            m++;
            Mt[m] = Pk[i];
            Ml[m] = RLENGTH;
        }

        ml = 0;
        mt = "";
        for(i = 1; i <= m; i++) {
            if(Ml[i] > ml) {
                ml = Ml[i];
                mt = Mt[i];
            }
        }

        if(1 > m) {
            # BAD!
            printf "BAD! \"%s\"\n", escape_string(f);
            exit;
        }

        tok = escape_string(substr(f, 1, ml));
            printf "%s: \"%s\"\n", mt, tok;

        f = substr(f, ml+1);
    }
}

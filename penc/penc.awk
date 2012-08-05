#!/usr/bin/awk -f

function _ord(      i) {
    for(i=0; i<=255; i++) {
        _ord_t[sprintf("%c", i)] = i
    }
    _ord_i = 1
}

function ord(c) {
    if(!_ord_i) { 
        _ord()
    }
    return _ord_t[substr(c,1,1)]
}

function chr(n) {
    return sprintf("%c", n+0)
}

function _penc(     c, i) {
    for(i=0; i<=255; i++) {
        c = sprintf("%c", i)
        _penc_t[c] = c !~ /^[[:alnum:].~-]$/
    }
    _penc_i = 1
}

function penc(s,     a, b, i, n) {
    # RFC 3986
    if(!_penc_i) {
        _penc()
    }
    n = split(s, a, "")
    for(i=1; i<=n; i++) {
        if(_penc_t[a[i]])
            b = b sprintf("%%%X", ord(a[i]))
        else
            b = b a[i]
    }
    return b
}

function fuenc(s,     a, b, i, n) {
    # application/x-www-form-urlencoded
    n = split(s, a, "")
    for(i=1; i<=n; i++) {
        if(" " == a[i])
            b = b "+"
        else
            b = b penc(a[i])
    }
    return b
}

{
    print "penc:", penc($0)
    print "fuenc:", fuenc($0)
}

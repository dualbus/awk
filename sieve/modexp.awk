function abn_cmp(bna, bnb,    bna_n, bnb_n, i) {
  sub(/^0+/, "", bna);
  sub(/^0+/, "", bnb);
  bna_n = length(bna)
  bnb_n = length(bnb)
  if(bna_n > bnb_n) {
    return 1;
  } else
  if(bnb_n > bna_n) {
    return -1
  } else {
    for(i = 1; i <= bna_n; i++) {
      if(substr(bna, i, 1) > substr(bnb, i, 1)) {
        return 1;
      } else
      if(substr(bnb, i, 1) > substr(bna, i, 1)) {
        return -1;
      }
    }
  }

  return 0;
}

function abn_divmod(bn_n, bn_d,     bs_n,bs_d,QR) {
  if(bn_d == 0) return;

  bs_n = abn_d2b(bn_n)
  bs_d = abn_d2b(bn_d)
  split(abn_bdivmod(bs_n, bs_d), QR, /,/)
  return abn_b2d(QR[1])","abn_b2d(QR[2])
}

function abn_sum(a, b) {
  return a+b;
}

function abn_exp(a, c) {
  return a ** c;
}

function abn_divmod_o(bn, d,     bn_n,i,x,r,q,z,Q) {
  if(d == 0) return;

  r = 0
  q = "";
  bn_n = length(bn);
  for(i = 1; i <= bn_n; i++) {
    r = r substr(bn, 1, 1)
    bn = substr(bn, 2)
    if(r+0 >= d+0) {
      z = r % d
      q = q (r - z)/d
      r = z
    } else {
      q = q "0"
    }
  }
  
  Q = q;
  bn = r;

  sub(/^0+/, "", Q);
  if(Q == "") {
    Q = 0;
  }
  sub(/^0+/, "", bn);
  if(bn == "") {
    bn = 0;
  }

  return Q","bn
}

function abn_div(bn, d,   q) {
  q = abn_divmod(bn, d);
  sub(/,.*/, "", q);
  return q
}

function abn_mod(bn, d,   r) {
  r = abn_divmod(bn, d);
  sub(/.*,/, "", r);
  return r
}


function abn_b2d(bs,     bs_n,s,i) {
  bs_n = length(bs)

  s = "0"
  for(i = 1; i <= bs_n; i++) {
    x = abn_exp("2", bs_n-i)
    if(0+substr(bs, i, 1)) {
      s = abn_sum(s, x);
    }
  }

  return s
}

function abn_d2b(bn,    bs,qr,QR,r) {
  bs = "";

  while(bn != "0") {
    qr = abn_divmod_o(bn, 2);
    split(qr, QR, /,/)
    bn = QR[1]
    r = QR[2]
    bs = r bs
  }
  
  return bs
}

function abn_bsl(bs, n) {
  for(; n > 0; n--) {
    bs = bs "0" 
  }
  return bs;
}

function abn_bsr(bs, n,     bs_n) {
  bs_n = length(bs)
  for(; n > 0; n--) {
    bs_n--;
    bs = substr(bs, 1, bs_n)
  }
  return bs
}

function abn_badd(bs_a, bs_b,   c,bs_p,n,bs_r,a,i) {
  bs_p = abn_bpad(bs_a, bs_b)
  split(bs_p, BS, /,/)
  bs_a = BS[1]
  bs_b = BS[2]
  n = length(bs_a)
  c = 0
  bs_r = ""
  for(i = n; i > 0; i--) {
    a = substr(bs_a, i, 1) + substr(bs_b, i, 1) + c
    pc = c;
    c = 0;
    if(a == 2) {
      c = 1
      a = 0
    } else if(a == 3) {
      c = 1
      a = 1
    }

    bs_r = a bs_r;
  }

  return c bs_r;
}

function abn_bsub(bs_a, bs_b,   bs_r,bs_p,BS) {
  bs_p = abn_bpad("0"bs_a, "0"bs_b)
  split(bs_p, BS, /,/)
  bs_a = BS[1]
  bs_b = abn_badd(abn_bnot(BS[2]), "1")
  bs_r = substr(abn_badd(bs_a, bs_b), 3)
  sub(/^0+/, "", bs_r);
  return bs_r;
}

function abn_bmul(bs_a, bs_b,   bs_a_n,bs_b_n,bs_x,bs_y,bs_x_n,s,i) {
  bs_a_n = length(bs_a)
  bs_b_n = length(bs_b)
  if(bs_a_n>bs_b_n) {
    bs_x_n = bs_b_n;
    bs_x = bs_b;
    bs_y = bs_a;
  } else {
    bs_x_n = bs_a_n;
    bs_x = bs_a;
    bs_y = bs_b;
  }

  s = "0"
  for(i = 1; i <= bs_x_n; i++) {
    if(0+substr(bs_x,i,1)) {
      s = abn_badd(abn_bsl(bs_y, bs_x_n-i), s);
    }
  }

  return s;
}

function abn_bdivmod(bs_n, bs_d,     q,r,bs_n_n,bn_n_n,i,x) {
  if(bs_d == 0) return;

  bs_n_n = length(bs_n)
  q = "0"
  r = "0"
  for(i = 1; i <= bs_n_n; i++) {
    r = r substr(bs_n, i, 1)
    if(abn_cmp(r, bs_d) >= 0) {
      r = abn_bsub(r, bs_d);
      q = q "1"
    } else {
      q = q "0"
    }
  }

  if(r == "") {
    r = 0
  }

  return q","r
}

function abn_bmod(bs, d,   r) {
  r = abn_bdivmod(bs, d);
  sub(/.*,/, "", r);
  return r
}

function abn_bpad(bs_a, bs_b,   i,delta,bs_a_n,bs_b_n) {
  bs_a_n = length(bs_a)
  bs_b_n = length(bs_b)

  delta = bs_a_n - bs_b_n

  if(delta != 0) {
    if(delta > 0) {
      first = 0
      bs_b_n += delta;
    } else {
      first = 1
      delta = -1*delta
      bs_a_n += delta;
    }

    for(i = 0; i < delta; i++) {
      if(first) {
        bs_a = "0" bs_a
      } else {
        bs_b = "0" bs_b
      }
    }
  }

  return bs_a","bs_b
}

function abn_bnot(bs,     bsn,i) {
  bs_n = length(bs)
  bsn = "";
  for(i = 1; i <= bs_n; i++) {
    bsn = bsn ((substr(bs,i,1)+0)?"0":"1")
  }
  return bsn
}

function abn_bor(bs, bsb) {
}

function abn_dec(bn,    i,bn_n,x,y) {

  bn_n = length(bn)

  for(i = bn_n; i > 0; i--) {
    x = 0+substr(bn, i, 1)
    if(x == 0) {
      y = abn_dec(substr(bn, 1, i-1)) "9"
      sub(/^0+/, "", y);
      return y
    } else {
      y =  substr(bn, 1, i-1) (x-1);
      sub(/^0+/, "", y);
      return y
    }
  }
}

function abn_bmodexp(b, e, m,  i,r,bs,B,n) {
  r = 1

  n = split(e, B, //)

  for(i = n; i > 0; i--) {
    if(B[i]+0 == 1) {
        r = abn_bmod(abn_bmul(r, b), m)
    }
    b = abn_bmod(abn_bmul(b, b), m)
  }

  sub(/^0+/, "", r);
  return r
}

function abn_modexp(b, e, m) {
  return abn_b2d(abn_bmodexp(abn_d2b(b), abn_d2b(e), abn_d2b(m)))
}

#BEGIN{
{
  #print abn_divmod_o(404, 50)
  #print abn_d2b(21)
  #print abn_b2d(abn_bmul(abn_d2b(21), abn_d2b(21)))
  #print abn_divmod_o(11, 2)
  #print abn_divmod_o(404, 50)
  #print abn_divmod_o(2, 2)
  #print abn_d2b(1002)

#  Nx = 10000
#  Nx = 0
#  for(i = 0; i < Nx; i++) {
#    x  = abn_b2d(abn_bmul(abn_d2b(i), abn_d2b(i)))
#    if(i*i == x) {
#    } else {
#      print i, x, i*i, "BAD"; break;
#    }
#  }

  #srand()
  ## b^(p-1) = 1 (mod p)
  #p = $1
  #pd = abn_dec(p)
  #R = 1
  #for(i = 0; i < 4; i++) {
  #  b = int(1+ rand() * 10)
  #  R *= abn_modexp(b, pd, p)==1?1:0
  #}
  #print R
  print abn_modexp($1,$2, $3)
}

#!/usr/bin/awk -f
BEGIN {
    t = "0123456789abcdefghijklmnopqrstuvwxyz";
}

{
    n=split($0, A, //);
    s=0;
    for(i=1;i<=n;i++){
        x =  (length(t)**(n-i)) * (index(t, A[i])-1)
        s+=x;
    };
    print s
}  

{
    s="";
    v=$0;
    while(v>0){
        m=v%36;
        s=m" "s;
        v=int(v/36)

    };
    n=split(s,A,/ /);
    r="";
    for(i=1;i<n;i++){
        r=r substr(t,A[i]+1,1)
    };
    print r
}

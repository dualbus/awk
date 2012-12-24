BEGIN {

    n = int(sqrt(N));

    print 2;

    for(i = 3; i <= n; i += 2) {
        if(i in A) continue;

        for(j = i*i; j <= N; j += 2*i) {
            A[j] = 1
        }

        print i
    }

    for(; i <= N; i += 2){
      if(i in A) continue

      print i;
    }
}

BEGIN {
    n = sqrt(N);
    for(i = 2; i <= n; i++){
        k = i**2
        x = k
        for(j = 0; x <= N; j++){
            x = k+i*j
            A[x]
        }
    }

    for(i = 2; i <= N; i++) {
      if(i in A) continue

      print i;
    }
}

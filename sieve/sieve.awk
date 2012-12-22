BEGIN {
    n = sqrt(N);
    print 2 # `2' is the only even prime.
    for(i = 3; i <= N; i += 2){
        if(i in A)
            continue;

        x = i*2
        for(j = 2; x <= N; j++){
            x = i*j
            A[x] = 1
        }
        print i
    }
}

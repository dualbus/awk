BEGIN {
    pi = 3.14159265358979323846;
		if(N<1) {
			N = 2048;
		}
}

{x[(NR-1)%N]=$0}
!(NR%N){
    #R = 44000;
    #R = 44000;
    for (bin = 0; bin <= N/2; bin++) {
        s[bin] = c[bin] = 0;
        for (k = 0; k < N; k++) {
            arg = (2 * bin * pi * k)/N;
            s[bin] += x[k] * -1 * sin(arg);
            c[bin] += x[k] * cos(arg);
        }

        #f[bin] = (bin * R)/ N;
        #f[bin] = bin;
        m[bin] = 20 * log(2 * sqrt(s[bin]**2 + c[bin]**2)/N);
        p[bin] = 180 * atan2(s[bin], c[bin])/pi - 90.;

        print bin,m[bin],p[bin];
    }
		exit;
}

addpath("/home/adam/Software/libsvm-3.20/matlab")

dl=[]; 
di=[]; 
for i=1:10000; 
	if(rand>0.5)
		dl=[dl;1337]; 
		di=[di;normrnd(1,5),normrnd(-1,5)] ;
	else 
		dl=[dl;435] ;
		di=[di;normrnd(-1,5),normrnd(1,5)] ; 
	endif ; 
endfor

model = svmtrain(dl,di)

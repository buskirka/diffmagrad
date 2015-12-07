# Average Vector Difference
# Calculates an averaged difference matrix across multiples of a given vector

# (x,y) is the vector, M is a 2xN vector containing the lengths and weights 
# assigned.

function ret = avd (x,y,M,A)
	if (nargin != 4)
		usage ("avd(x,y,M,A)");
	endif
	summation=0*A;
	denom=0*A;
	for i=M;
		if( round(x*i(1)) != 0 || round(y*i(1)) != 0 )
			summation += i(2) * vd(x*i(1),y*i(1),A) ;
			denom += abs(i(2)) * tr( x*i(1), y*i(1), ones(size(A)) );
		endif
	endfor
	ret = single(summation) ./ single(denom);
endfunction

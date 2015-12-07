#rsci = @(a,b) @(x) (a<x)*(x<=b)
function retval = rsci (a,b,x)
	retval = (a < x) .* (x <= b) ;
endfunction

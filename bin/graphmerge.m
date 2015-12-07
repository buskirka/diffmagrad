function retval = graphmerge ( G1 , G2 )
	retval = unique( sort( [G1,G2] )', "rows")';
endfunction

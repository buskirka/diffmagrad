function retval = eigdist ( G1 , G2 )
	retval=0;
	for i=eig(adjmat(G1))'
		retval += min( abs(i*ones(size(eig(adjmat(G2)))) - eig(adjmat(G2))) ) ;
	endfor
endfunction

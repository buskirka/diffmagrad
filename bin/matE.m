function x = matE ( M )
	x(1)= 1/sum(sum(M)) * sum(sum(diag(1:size(M,1))*M));
	x(2)= 1/sum(sum(M)) * sum(sum(M*diag(1:size(M,2))));
endfunction

function retval = adjmat (graph)
	retval=zeros(max(max(graph)));
	for i=graph
		retval(i(1),i(2)) += 1;
		retval(i(2),i(1)) += 1;
	endfor
	retval = (retval>0) .* (ones(size(retval))-eye(size(retval)));
endfunction

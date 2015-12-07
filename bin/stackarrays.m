function retval = stackarrays ( cellarray )
	index=0;
	for j=1:length(cellarray)
		for i=1:size(cellarray{j},3) 
			index = index+1;
			retval(:,:,index)=cellarray{j}(:,:,i);
		endfor
	endfor
endfunction

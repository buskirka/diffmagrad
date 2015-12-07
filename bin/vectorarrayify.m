function retval = vectorarrayify (h)
	for j=1:size(h,4)
		for i=1:size(h,3)
			retval(:,:,i+size(h,3)*(j-1)) = h(:,:,i,j);
		end
	end
endfunction
		

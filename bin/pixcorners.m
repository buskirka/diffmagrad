function retval = pixcorners (imagearray)
	retval = struct();
	% Extract the upper left corner
	for i=1:size(imagearray,1)
		if(any(imagearray')(i) == 1)
			retval.UL=[i,round(mean(find(imagearray(i,:))))];
			break;
		endif
	endfor
	% Extract the lower left corner
	for i=1:size(imagearray,2)
		if(any(imagearray)(i) == 1)
			retval.LL=[round(mean(find(imagearray(:,i)))),i];
			break;
		endif
	endfor
	% Extract the lower right corner
	for i=size(imagearray,1):-1:1
		if(any(imagearray')(i) == 1)
			retval.LR=[i,round(mean(find(imagearray(i,:))))];
			break;
		endif
	endfor
	% Extract the upper right corner
	for i=size(imagearray,2):-1:1
		if(any(imagearray)(i) == 1)
			retval.UR=[round(mean(find(imagearray(:,i)))),i];
			break;
		endif
	endfor
endfunction

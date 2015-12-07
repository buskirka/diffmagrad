function retval = extractLocalDMR ( mbins, rbins, imRawData, radius, point )
	radiusExt=max(max(rbins));
	h1=cellfun(@(x) vectorarrayify( histomatpDMR(mbins, rbins, neighborhood(x,point,radius+radiusExt)) ), imRawData , 'UniformOutput', false);
	for i=1:length(h1)
		h2{i}=h1{i}((radiusExt):(2*radius+radiusExt),(radiusExt):(2*radius+radiusExt),:);
	endfor
	retval=stackarrays(h2);
endfunction

function retval = extractLocalDMR ( mbins, rbins, imRawData, radius, point )
% extractLocalDMR
% Takes as input a bin configuration, some data to process, and a 
% neighborhood in the data to process.
%	mbins     : The magnitudinal bins on which to compute the DMR.
%	rbins     : The radial bins on which to compute the DMR.
%	imRawData : The raw data to be processed. It should be a one-
%		  : dimensional cell array where each element is a two-
%		  : dimensional matrix image.
%	radius    : The radius around `point` in which to gather the data.
%	point     : The point around which to gather data.
 
	radiusExt=min(ceil(cellfun(@(x) max(max(x)), rbins)),1);
	for i=1:length(imRawData); 
		index{i}=i; 
	endfor
	h1=cellfun(@(x) vectorarrayify( histomatpDMR(mbins{x}, rbins{x}, neighborhood(imRawData{x},point,radius+radiusExt)) ), index , 'UniformOutput', false);
	for i=1:length(h1)
		h2{i}=h1{i}((radiusExt):(2*radius+radiusExt),(radiusExt):(2*radius+radiusExt),:);
	endfor
	retval=stackarrays(h2);
endfunction

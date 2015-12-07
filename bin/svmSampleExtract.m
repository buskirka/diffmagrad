function [retsvmlabel, retsvmdata] = svmSampleExtract( mbins, rbins, imTraining , imRawData , radius , point)
% A function which extracts SVM training data using DMR.
% 	mbins : The magnitudinal bins to use for the training.
%	rbins : The radial bins to use for the training.
%	imTraining : The training image. Should be:
%		White (255) where data centers are,
%		Grey (1-254, consistently) where data centers are *not*, and
%		Black (0) where it should be ignored.
%	imRawData : The raw data. Should be a 2-dimensional array.
%	radius : The radius around `point' for which the neighborhood is valid.
%	point : The point around which the neighborhood is chosen.
% And outputs 
%	retsvmlabel and
%	retsvmdata
% which can be entered into a learning machine.
	
	h=extractLocalDMR ( mbins, rbins, imRawData, radius, point ) ;
	
	retsvmlabel=[]; 
	retsvmdata=[];
	nbhd=neighborhood(imTraining,point,radius);
	for i=1:(1+2*radius); 
		for j=1:(1+2*radius); 
			if(nbhd(i,j) != 0); 
				retsvmlabel=[retsvmlabel;nbhd(i,j)]; 
				retsvmdata=[retsvmdata; h(i,j,:)(:)']; 
			endif; 
		endfor; 
	endfor
endfunction

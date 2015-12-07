function [retsvmlabel, retsvmdata] = svmRFDExtract( imTraining , imRawData , radius , point , rbins , sinusoidsCell)
	h=[];
	for layer=1:length(rbins)
		mmrl=ceil(max(max(rbins{layer})));
		for rbin=rbins{layer};
			newbatch=RadialFourierDescriptor(rbin',neighborhood(imRawData{layer},point,radius+mmrl),sinusoidsCell(layer));
			newbatch=newbatch((1+mmrl):(end-mmrl),(1+mmrl):(end-mmrl),:);
			h=cat(3,h,newbatch);
		endfor
	endfor
	
	nbhd=neighborhood(imTraining,point,radius);
	
	pile=cat(3,nbhd,h);
	pile=permute(pile,[3,1,2])(:,:)';
	
	index=find(pile(:,1) ~= 0);
	
	retsvmlabel=pile(index,1);
	retsvmdata=pile(index,2:end);
	%for i=1:(1+2*radius); 
	%	for j=1:(1+2*radius); 
	%		if(nbhd(i,j) != 0); 
	%			retsvmlabel=[retsvmlabel;nbhd(i,j)];
	%			retsvmdata=[retsvmdata; h(i,j,:)(:)'];
	%		endif; 
	%	endfor; 
	%endfor
endfunction

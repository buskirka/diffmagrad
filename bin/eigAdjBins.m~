function vecbin = eigAdjBins(img,watermark,bounds,partition)
	if( ~exist('img','var') )
		error('`img` is not defined!');
	elseif( isa(img,"numeric") )
		im=img;
	elseif( exist(img,'file') )
		im=imread(img);
	else
		error('Inexplicable `img` entry!');
	endif
	
	if( ~exist('watermark','var') )
		watermark=0.05;
		warning("watermark defaulted to 0.05");
	endif
	
	if( ~exist('bounds','var') || size(bounds) ~= [1,2] || bounds(1) >= bounds(2) )
		bounds=[500,30000];
		warning("bounds defaulted to [500,30000]");
	endif
endfunction

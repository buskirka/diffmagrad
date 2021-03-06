function reteig = gmapsDelaunayEig( location , watermark , bounds )
	if( ~exist('location','var') )
		location=[33.063939,-80.043255];
		warning("location defaulted to Moncks Corner [33.063939,-80.043255]");
	endif
	
	if( ~exist('watermark','var') )
		watermark=0.05;
		warning("watermark defaulted to 0.05");
	endif
	
	if( ~exist('bounds','var') || size(bounds) ~= [1,2] || bounds(1) >= bounds(2) )
		bounds=[500,30000];
		warning("bounds defaulted to [500,30000]");
	endif
	
	stringmaker = @(loc) ["https://maps.googleapis.com/maps/api/staticmap?center=",num2str(loc(1),20),",",num2str(loc(2),20),"&zoom=15&size=1024x1024&maptype=satellite&scale=2&format=jpg"];

	system(['wget "',stringmaker(location),'" -O junk.jpg']);
	im=imread('junk.jpg');
	reteig=eig(delaunaymat(im,watermark,bounds));
endfunction

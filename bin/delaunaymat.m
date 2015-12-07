function dmat = delaunaymat ( image , watermark , bounds)
	if( ~exist('image','var') )
		error('`image` is not defined!');
	elseif( isa(image,"numeric") )
		im=image;
	elseif( exist(image,'file') )
		im=imread(image);
	else
		error('Inexplicable `image` entry!');
	endif
	
	if( ~exist('watermark','var') )
		watermark=0.05;
		warning("watermark defaulted to 0.05");
	endif
	
	if( ~exist('bounds','var') || size(bounds) ~= [1,2] || bounds(1) >= bounds(2) )
		bounds=[500,30000];
		warning("bounds defaulted to [500,30000]");
	endif

	w=[-3:-1,1:3]; w(2,:)=1;

	Dim=max(avd(1,0,w,im(:,:,1)),max(avd(0,1,w,im(:,:,1)),max(avd(1,1,w,im(:,:,1)),avd(-1,1,w,im(:,:,1)))));
	for i=2:size(im,3)
		Dim=max(Dim,max(avd(1,0,w,im(:,:,i)),max(avd(0,1,w,im(:,:,i)),max(avd(1,1,w,im(:,:,i)),avd(-1,1,w,im(:,:,i))))));
	endfor

	N = neighborhood( mat2gray(Dim) , ceil(size(Dim)/2) , 500 ) ;

	C=componentsmat(N,watermark);

	windex=intersect( find( arrayfun(@(l) sum(sum(C==l)),unique(C)) > bounds(1)), find( arrayfun(@(l) sum(sum(C==l)),unique(C)) < bounds(2)) );

	X=cell2mat(arrayfun(@(l) matE( C == l ) , unique(C)(windex) , "UniformOutput",false));

	T=delaunay(X(:,1),X(:,2));
	dmat=adjmat(graphmerge(graphmerge(T(:,[1,2])',T(:,[1,3])'),T(:,[2,3])'));
endfunction

function dmat = delaunayplot ( image , watermark , bounds , w )
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

	if( ~exist('w','var') )
		w=[-3:-1,1:3]; w(2,:)=1;
		warning("weight defaulted to equally weighted +/-1:3");
	endif

	Dim=max(abs(avd(1,0,w,im(:,:,1))),max(abs(avd(0,1,w,im(:,:,1))),max(abs(avd(1,1,w,im(:,:,1))),abs(avd(-1,1,w,im(:,:,1))))));
	Q = mat2gray(neighborhood( abs(im(:,:,1)) , ceil(size(im)/2) , 500 )) ;
	for i=2:size(im,3)
		Dim=max(Dim,max(abs(avd(1,0,w,im(:,:,i))),max(abs(avd(0,1,w,im(:,:,i))),max(abs(avd(1,1,w,im(:,:,i))),abs(avd(-1,1,w,im(:,:,i)))))));
		Q=cat(3,Q,mat2gray(neighborhood( abs(im(:,:,i)) , ceil(size(im)/2) , 500 )));
	endfor

	N = neighborhood( Dim , ceil(size(Dim)/2) , 500 ) ;
	
	C=componentsmat(N,watermark);
	
	sizemat=arrayfun(@(l) sum(sum(C==l)), (unique(C))) ;
	windex=find( (sizemat > bounds(1)) .* (sizemat < bounds(2)) );

	X=cell2mat(arrayfun(@(l) matE( C == l ) , unique(C)(windex) , "UniformOutput",false));

	hold on;
	axis([0,size(image,1),0,size(image,2)]); 
	subplot(1,1,1); 
	imshow( Q ) ; 
	subplot(1,1,1); 
	delaunay(X(:,2),X(:,1));
endfunction

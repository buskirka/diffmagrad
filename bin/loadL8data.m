function [ LandsatRawData , training , point ] = loadL8data ()
	if( exist('./corners.mat','file') != 0 )
		load './corners.mat'
	end
	
	if( exist('./dcpos.mat','file') != 0 )
		load './dcpos.mat'
	end
	
	if( exist('./training.TIF','file') != 0 )
		training=imread('./training.TIF')(:,:,1);
	end

	% If `corners' exists, let that provide our sceneID.
	if( exist('corners','var') != 0 && exist('sceneID','var') == 0)
		sceneID=corners.sceneID ;
	end
	
	if( exist('sceneID','var') == 0 )
		error('sceneID not defined');
		break
	end

	LandsatRawData=cell(11,1) ;

	parfor i=[1:7,9:11];
		str=[sceneID,"_B",mat2str(i),".TIF"];
		LandsatRawData{i}=imread(str)(:,:,1) ; 
	endparfor

	C=imread([sceneID,"_B8.TIF"]);
	LandsatRawData{8}=C(1:2:rows(C),1:2:columns(C),1);
	clear C

	pc.UL=[1,1];
	pc.LR=size(LandsatRawData{4});
	pc.UR=[1,size(LandsatRawData{4},2)];
	pc.LL=[size(LandsatRawData{4},1),1];

	point=round(cornermap(corners,pc,dcpos)) ;
endfunction

% histomatDMR.m

function retval = histomatDMR (mbins, rbins, data, coord)
	% Determine what the maximum radius necessary to be binned is.
	mr = max(max(rbins));
	% Instantiate the return value matrix (necessary here for use of `+=')
	retval=zeros(size(data)(1),size(data)(2),size(mbins,2),size(rbins,2));
	% For each coordinate (x,y) within `mr' of a point (in L_\infty)...
	if( nargin==3 )
		coord=cell(2*mr+1,2*mr+1);
		for x=[-mr:mr] 
		for y=[-mr:mr]
			coord{x+mr+1,y+mr+1} = [x,y] ;
			% p{x+2*mr+1,y+2*mr+1}=DMR_Splicer(x,y,mbins,rbins,data);
		endfor
		endfor
		% warning("coord defaulted to standard rectangle");
	endif
	
	for subx=1:ceil(size(coord,1)/50);
	for suby=1:ceil(size(coord,2)/50); 
		subcoord=coord( (50*subx-49):min(50*subx,size(coord,1)),(50*suby-49):min(50*suby,size(coord,2)) );
		summe=cell(size(subcoord));
		summe=cellfun(
			@(loc) DMR_Splicer(loc(1),loc(2),mbins,rbins,data), 
			subcoord,
			'UniformOutput', false );
		for x=1:size(summe,1)
		for y=1:size(summe,2)
			retval += summe{x,y} ;
		endfor
		endfor
	endfor; 
	endfor
endfunction

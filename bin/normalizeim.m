function retval = normalizeim (mr, weightf, data)
	# Instantiate the return value matrix (necessary here for use of `+=')
	avg=zeros(size(data));
	weight=zeros(size(data));
	# For each coordinate (x,y) within `mr' of a point (in L_\infty)...
	coord=cell(2*mr+1,2*mr+1);
	weightarray=cell(2*mr+1,2*mr+1);
	for x=[-mr:mr] 
	for y=[-mr:mr]
		coord{x+mr+1,y+mr+1} = [x,y] ;
	endfor
	endfor
	weightarray=cellfun( @(loc) weightf(loc),
		coord,
		"UniformOutput", false);
	for x=[-mr:mr] 
	for y=[-mr:mr]
		avg += tr(x,y,data) .* weightarray{x+mr+1,y+mr+1} ;
		weight += tr(x,y,ones(size(data))) .* weightarray{x+mr+1,y+mr+1} ;
		%printf('.');
	endfor ; printf([num2str(x),' ']);
	endfor
	retval = data ./ ( avg ./ weight);
endfunction

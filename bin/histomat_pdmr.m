# histomat_diff_mag.m
# Sorts a data set into a histogram strictly by the magnitude of `avd' applied
# to the tangent unit vector to each integer vector within the radius
# Input: 
#   mbins : a 2xN_m array describing the magnitudinal bins to sort by.
#   rbins : a 2xN_r array describing the radial bins to sort by
#   data : the data to sort
pkg load parallel

function retval = histomatpDMR (mbins, rbins, data)
	# Determine what the maximum radius necessary to be binned is.
	mr = max(max(rbins));
	# Instantiate the return value matrix (necessary here for use of `+=')
	retval=zeros(size(data)(1),size(data)(2),length(mbins),length(rbins));
	# For each coordinate (x,y) within `mr' of a point (in L_\infty)...
	p=cell(2*mr+1,2*mr+1);
	for x=[-mr:mr] 
	for y=[-mr:mr]
		p{x+2*mr+1,y+2*mr+1}=DMR_Splicer(x,y,mbins,rbins,data);
	endfor
	endfor
	retval=p;
endfunction

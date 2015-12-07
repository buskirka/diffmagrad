# histomat_diff_mag.m
# Sorts a data set into a histogram strictly by the magnitude of `avd' applied
# to the tangent unit vector to each integer vector within the radius
# Input: 
#   mbins : a 2xN_m array describing the magnitudinal bins to sort by.
#   rbins : a 2xN_r array describing the radial bins to sort by
#   data : the data to sort
pkg load parallel

function retval = histomat_diff_mag_rad (mbins, rbins, data)
	# A matrix to rotate a vector by pi/2.
	M = [0,-1;1,0] ;
	# A weighted average gradient vector for use by `avd.m'
	w = [-3,1;-2,1;-1,1;1,1;2,1;3,1]' ;
	# Determine what the maximum radius necessary to be binned is.
	mr = max(max(rbins));
	# Instantiate the return value matrix (necessary here for use of `+=')
	retval=zeros(size(data)(1),size(data)(2),length(mbins),length(rbins));
	# For each coordinate (x,y) within `mr' of a point (in L_\infty)...
	for x=[-mr:mr] 
	for y=[-mr:mr]
		printf(["(",num2str(x),",",num2str(y),") "]); fflush(stdout);
		# Instantiate a variable to prevent unnecessary recalculation of
		# the prismatic array of magnitude.
		calculated=false;
		# Calculate the L_2 magnitude of (x,y)
		dist=sqrt(x^2+y^2);
		# The unit vector which tangent at (x,y) to the circle of radius
		# `dist'.
		tuv=(M*[x,y]')'/sqrt(x^2+y^2) ;
		# For each of the possible radial bins...
		for i=1:length(rbins)
			# ...if the point is actually *in* said bin, ...
			if( rsci(rbins(1,i),rbins(2,i),dist) )
				# ... calculate the prismatic array (if you haven't already) ...
				if(calculated == false)
					p=prismat(mbins,tr(-x,-y,avd(tuv(1),tuv(2),w,data))) ;
					calculated == true;
				endif
			# ... then add said prismatic array to our return.
			retval(:,:,:,i) += p ;
			endif
		endfor
	endfor
	endfor
endfunction

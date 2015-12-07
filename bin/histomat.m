# histomat.m
# Input: 
#   mbins : a 2xN array describing the bins to sort by.
#   data : the data to sort

function retval = histomat (mbins, data)
	# A matrix to rotate a vector by pi/2.
	M = [0,-1;1,0] ;
	# A weighted average gradient vector for use by `avd.m'
	w = [-3,1;-2,1;-1,1;1,1;2,1;3,1]'
	# Determine what the maximum radius necessary to be binned is.
	mr = ceil(max(max(mbins))) ;
	retval=zeros(size(data)(1),size(data)(2),length(mbins))
	for x=[-mr:mr] 
	for y=[-mr:mr]
		# Check whether the coordinate is even in any of the bins in the first 
		# place. For now we'll assume that the bins cover that circle, so no
		# check is necessary for whether a value is actually used or not.
		if( x^2+y^2 <= mr^2 && (x != 0 || y != 0) )
			#[[x,y];[x,y].+(M*[x,y]')'/sqrt(x^2+y^2)], 
			tuv=(M*[x,y]')'/sqrt(x^2+y^2)
			retval += prismat(mbins,avd(tuv(1),tuv(2),w,tr(-x,-y,data))) ;
		endif
	endfor
	endfor
endfunction

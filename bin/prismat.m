# prismat.m
# Sorts a matrix `data' into the bins defined by `bins', where
#   bins : a 2xN matrix where the i-th 2-tuple column defines a right 
#          semi-closed interval is counted in the i-th coordinate.
#   data : the M_1 x M_2 matrix to be sorted into N different bins.
# The return value is a 3-dimensional M_1 x M_2 x N array wherein
# the (i,j,k)-th entry is `1' if the (i,j)-th entry of `data' lies
# in the k-th RSCI in `bins' and `0' otherwise.

function retval = prismat (bins, data)
	for i=1:size(bins,2) 
		hs{i}=rsci(bins(1,i),bins(2,i),data) ;
	endfor
	for i=1:length(hs) 
		retval(:,:,i)=hs{i} ;
	endfor
endfunction

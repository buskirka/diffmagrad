# Vector difference 
# Calculates the ``slope'' of a matrix across a given vector

# (x,y) is the integer vector along which the slope is calculated.

function ret = vd (x,y,A);
	if (x == 0 && y == 0)
		error(["vd.m: slope across zero vector (",x,",",y,",)"]);
		ret = 0;
	else
		ret = (tr(x,y,A) - A)/sqrt(x^2+y^2);
	endif
endfunction

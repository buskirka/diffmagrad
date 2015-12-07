# Vector translation
# Translates a function along a vector

# (x,y) is the integer function along which the matrix A is translated.

function ret = tr (x,y,A); 
	x=round(x);
	y=round(y);
	if (y > 0); 
		ret=[A((1+y):end,:);zeros(y,size(A)(2))];
	else ; 
		ret=[zeros(-y,size(A)(2));A(1:size(A)(1)+y,:)] ; 
	endif ; 
	if (-x > 0); 
		ret=[ret(:,(1-x):end),zeros(size(ret)(1),-x)];
	else ; 
		ret=[zeros(size(ret)(1),x),ret(:,1:size(A)(2)-x)] ; 
	endif ; 
endfunction


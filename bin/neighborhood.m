% Neighborhood
function retval = neighborhood (array, point, radius)
	if( radius < 0 )
		error('Radius must be nonnegative!')
	end
	radius=round(radius);
	xMin=max( point(1)-radius , 1 );
	xMax=min( point(1)+radius , size(array,1) );
	yMin=max( point(2)-radius , 1 );
	yMax=min( point(2)+radius , size(array,2) );
	retval=double(array(xMin:xMax, yMin:yMax));
end

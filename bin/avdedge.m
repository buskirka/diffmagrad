function dim = avdedge ( im , weight )
	if( exist('weight','var') )
		w=weight;
	else
		w=[-3,-2,-1,1,2,3;1,1,1,1,1,1];
	end
	dim=zeros(size(im));
	for theta=0:0.3:(2*pi)
		dim=max(dim,abs(avd(cos(theta),sin(theta),w,im)));
	end
end

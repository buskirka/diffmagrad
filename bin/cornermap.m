function retval = cornermap ( domain , range , point )
	% Takes a `point' in the space defined by the struct `domain' 
	% and maps it to the corresponding point in `range'
	
	% Calculate the average point associated to the linear transformation:
	% UL:
	G=[range.LL-range.UL;range.UR-range.UL]' ;
	F=[domain.LL-domain.UL;domain.UR-domain.UL]';
	pointUL=G*F^-1*(point-domain.UL)'+range.UL';
	wUL=max(sqrt(sum((domain.UL-point).^2)),.01)^-1;
	
	% UR:
	G=[range.UL-range.UR;range.LR-range.UR]' ;
	F=[domain.UL-domain.UR;domain.LR-domain.UR]';
	pointUR=G*F^-1*(point-domain.UR)'+range.UR';
	wUR=max(sqrt(sum((domain.UR-point).^2)),.01)^-1;
	
	% LR:
	G=[range.UR-range.LR;range.LL-range.LR]' ;
	F=[domain.UR-domain.LR;domain.LL-domain.LR]';
	pointLR=G*F^-1*(point-domain.LR)'+range.LR';
	wLR=max(sqrt(sum((domain.LR-point).^2)),.01)^-1;
	
	% LL:
	G=[range.UL-range.LL;range.LR-range.LL]' ;
	F=[domain.UL-domain.LL;domain.LR-domain.LL]';
	pointLL=G*F^-1*(point-domain.LL)'+range.LL';
	wLL=max(sqrt(sum((domain.LL-point).^2)),.01)^-1;
	
	retval=((wUL*pointUL+wUR*pointUR+wLL*pointLL+wLR*pointLR)/(wUL+wUR+wLL+wLR))';
endfunction

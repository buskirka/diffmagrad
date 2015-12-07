datalabel=[]; 
datainst=[]; 
for i=1:1000; 
	if(rand>0.5)
		datalabel=[datalabel;1]; 
	else 
		datalabel=[datalabel;0] ; 
	endif ; 
endfor

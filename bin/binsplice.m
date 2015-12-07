function retcellbins = binsplice (cellbin1, cellbin2)
	for i=1:length(cellbin1.mbins)
		if(rand < .5)
			retcellbins.mbins{i} = cellbin1.mbins{i};
			retcellbins.rbins{i} = cellbin1.rbins{i};
		else 			
			retcellbins.mbins{i} = cellbin2.mbins{i};
			retcellbins.rbins{i} = cellbin2.rbins{i};
		endif
	endfor
endfunction


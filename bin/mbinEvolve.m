function retmbins = mbinEvolve (mbins, rate)
	for i=1:length(mbins)
		if(rand < .3)
			retmbins{i} = sort(mbins{i} + rate*randn(size(mbins{i})));
		elseif(size(mbins{i},2) == 1)
			retmbins{i} = [mbins{i},partition(sort(rand(1,2)))];
		else
			if(rand < .3)
				%insert bin
				insertloc=randi(size(mbins{i},2)-1);
				retmbins{i} = [mbins{i}(:,1:insertloc),mbins{i}(:,insertloc)+rand()*mbins{i}(:,insertloc+1),mbins{i}(:,insertloc+1:size(mbins{i},2))];
			elseif(rand < .3 && length(mbins{i})>1 )
				%delete a bin
				deleteloc=randi(size(mbins{i},2));
				retmbins{i} = [mbins{i}(:,1:deleteloc-1),mbins{i}(:,deleteloc+1:size(mbins{i},2))];
			else
				retmbins{i} = mbins{i} ;
			endif
		endif
	endfor
endfunction


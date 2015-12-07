function retrbins = rbinEvolve (rbins, rate)
	for i=1:length(rbins)
		if(rand < .8)
			retrbins{i} = sort(rbins{i} + rate*randn(size(rbins{i})));
		elseif(size(rbins{i},2) == 1)
			retrbins{i} = [rbins{i},partition(sort(rand(1,2)))];
		else
			if(rand < .3)
				%insert bin
				insertloc=randi(size(rbins{i},2)-1);
				retrbins{i} = [rbins{i}(:,1:insertloc),rbins{i}(:,insertloc)+rand()*rbins{i}(:,insertloc+1),rbins{i}(:,insertloc+1:size(rbins{i},2))];
			elseif(rand < .3 && length(rbins{i})>1 )
				%delete a bin
				deleteloc=randi(size(rbins{i},2));
				retrbins{i} = [rbins{i}(:,1:deleteloc-1),rbins{i}(:,deleteloc+1:size(rbins{i},2))];
			else
				retrbins{i} = rbins{i};
			endif
		endif
		
		retrbins{i} = sort(abs(retrbins{i})) ;
	endfor
endfunction


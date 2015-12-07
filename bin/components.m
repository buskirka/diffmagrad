function regions = components ( data , watermark )
	if( max(max(data)) > 1 || min(min(data)) < 0 )
		error("data out of bounds");
	endif
	
	points{1} = [0,0];
	regions{1} = (data > watermark) ;
	index{1} = 1;
	iindex=1;
	filled=(data > watermark);
	for i=1:size(data,1);
		for j=1:size(data,2);
			if( filled(i,j) == 0 )
				printf(["Found new component at ",num2str(i),",",num2str(j),"\n"]);
				iindex += 1;
				index{iindex} = iindex;
				points{iindex} = [i,j]; 
				regions{iindex}=zeros(size(data));
				regions{iindex}(i,j)=1;
				original = regions{iindex} ;
				expand = zeros(size(data));
				changes=true;
				while( changes )
					printf(".");
					expand = min( ones(size(filled))-filled ,
								original
								+ tr(1,0,original)
								+ tr(0,1,original)
								+ tr(-1,0,original)
								+ tr(0,-1,original)
								);
					changes = max(max( expand != original )) ;
					original = expand ;
				endwhile
				regions{iindex}=expand;
				filled = max(filled,regions{iindex});
			endif
		endfor
	endfor
endfunction

function retsvm = svmRFDFullExtract(DataTraining,DataCells,rbins,sinusoidsCell)
	svl=[]; 
	svd=[]; 
	printf(['\nsvmRFDFullExtract:']); 
	for i=100:100:(size(DataCells{1},1)-100); 
		for j=100:100:(size(DataCells{1},2)-100); 
			if(max(max(neighborhood(DataTraining,[i,j],50))) > 0); 
				printf(['(',num2str(i),',',num2str(j),') ']); 
				fflush(stdout); 
				[l,d]=svmRFDExtract(DataTraining,DataCells,50,[i,j],rbins,sinusoidsCell); 
				svl=[svl;l]; 
				svd=[svd;d];
			endif
		endfor
	endfor

	classcount=[unique(svl),arrayfun(@(x) sum(svl==x),unique(svl))];
	if( max( classcount(:,2) ) > 2* min( classcount(:,2) ) )
		warning('Data set highly imbalanced! Automatically undersampling!');
		%For heavily imbalanced datasets, undersample the larger set.
		minimum_class=min(classcount(:,2));
		svd2=[];
		svl2=[];
		for i=unique(svl)'
			list=find( svl == i );
			[~,shufind]=sort(rand(1,length(list)));
			svd2=[svd2;svd(list(shufind(1:minimum_class)))];
			svl2=[svl2;svl(list(shufind(1:minimum_class)))];
		end
		svd=svd2;
		svl=svl2;
	end
	retsvm=svmtrain(double(svl),double(svd),'-h 0');
endfunction

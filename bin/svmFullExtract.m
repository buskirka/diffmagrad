% svmFullExtract
function retsvm = svmFullExtract(mbins,rbins,DataTraining,DataCells)
	svl=[]; 
	svd=[]; 
	printf(['\nsvmFullExtract:']); 
	for i=100:100:(size(DataCells{1},1)-100); 
		for j=100:100:(size(DataCells{1},2)-100); 
			if(max(max(neighborhood(DataTraining,[i,j],50))) > 0); 
				printf(['(',num2str(i),',',num2str(j),') ']); 
				fflush(stdout); 
				[l,d]=svmSampleExtract(mbins,rbins,DataTraining,DataCells,50,[i,j]); 
				svl=[svl;l]; 
				svd=[svd;d];
			endif
		endfor
	endfor
	retsvm=svmtrain(double(svl),double(svd));
endfunction

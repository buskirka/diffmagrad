function retaccuracy = svmFullFitnessTest ( mbins, rbins, DataKey, DataCells, svm )
% Compute SVM values labels+datapoints 
	svl=[]; 
	svd=[]; 
	printf(['\nsvmFullFitnessTest:\n']); 
	for i=100:100:(size(DataCells{1},1)-100); 
		for j=100:100:(size(DataCells{1},2)-100); 
			if(max(max(neighborhood(DataKey,[i,j],50))) > 0); 
				printf(['(',num2str(i),',',num2str(j),')  ']); 
				fflush(stdout); 
				[l,d]=svmSampleExtract(mbins,rbins,DataKey,DataCells,50,[i,j]); 
				svl=[svl;l]; 
				svd=[svd;d];
			endif
		endfor
	endfor
	
	[a,b,c]=svmpredict(double(svl),double(svd),svm);
	retaccuracy=b(1);
endfunction

mbins=partition(-1:0.5:3)
rbins=[0,4;4,8;8,12]'

training=imread('training.TIF');

% Create the histogram array
h=histomatpDMR(mbins, rbins, neighborhood(LandsatRawData{7},point,50+12));

% SVM data extraction test
svmlabel=[]; 
svmdata=[]; 
for i=1:125; 
	for j=1:125; 
		if(neighborhood(training,point,50+12)(i,j) != 0); 
			svmlabel=[svmlabel;neighborhood(training,point,50+12)(i,j)]; 
			svmdata=[svmdata; h(i,j,:,:)(:)']; 
		endif; 
	endfor; 
endfor

% Train the SVM:
svm=svmtrain(double(svmlabel),double(svmdata))

% Calculate an SVM prediction array for the region:
for i=1:125; 
	for j=1:125; 
		prediction(i,j)=svmpredict(150*ones(size((h(i,j,:,:))(1))),h(i,j,:,:)(:)',svm);
	end;
end

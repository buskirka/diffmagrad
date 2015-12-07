h=extractLocalDMR( mbins, rbins, LandsatRawData(1:7), 100, point) ;

for i=1:size(h,1); 
	for j=1:size(h,2); 
		pred(i,j)=svmpredict(150, h(i,j,:)(:)', svm, '-q') ;
	endfor 
	printf('.');
endfor

l1=[];
l1(:,:) = neighborhood (LandsatRawData{4},point,100);

	pic=[];
	pic(:,:,1)=double(l1)/double(max(max(l1)));
	pic(:,:,2)=double(l1)/double(max(max(l1)));
	pic(:,:,3) = double(pred==255);
	imshow(pic);

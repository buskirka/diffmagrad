% An evolutionary algorithm designed to train SVM binconfigs on Google data.
more off;

dir=pwd;
cd([dir,'/scale17/']);
list={"CouncilBluffs","DouglasCounty","Lenoir","MoncksCorner"};
im=cell();
tr=cell();
for i=1:size(list,2)
	filename=list{i};
	if( exist(filename,'var') == 0)
		printf(['Loading ',filename,'\n']);
		[im1,im2]=imread([filename,'.png']); 
		im{i}{1}=ind2rgb(im1,im2)(:,:,1);
		im{i}{2}=ind2rgb(im1,im2)(:,:,2);
		im{i}{3}=ind2rgb(im1,im2)(:,:,3);
		tr{i}=imread([filename,'-training.tif']);
	endif
endfor

cd(dir);

if( exist('binEcosystem','var') == 0)
	printf('Creating a binEcosystem (load one first to use it instead)\n');
	for i=1:4;
	for j=1:4;
		for layer=1:7
			binEcosystem{i,j}.mbins{layer}=double([0,100*i]');
			binEcosystem{i,j}.rbins{layer}=double([0,2*j]');
		endfor
	endfor
	endfor
end

testdata=randi([1,length(list)]);

clear fitness;
%Compute fitness of bins
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
		tic;
		svl=[]; svd=[];
		printf(['Computing fitness for (',num2str(i),',',num2str(j),')...\n']);
		for tc=1:length(list)
			if( testdata ~= tc )	
				printf(['\n',list{tc},' ']);
				[svlp,svdp]=labelFullExtract(
	        	   	binEcosystem{i,j}.mbins ,
					binEcosystem{i,j}.rbins ,
					tr{tc} ,
					im{tc} ) ;
				svl=[svl;svlp];
				svd=[svd;svdp];
			endif
		endfor
		toc;
		
		l=size(svl,1);
		svmfilt=[];
		for class=unique(svl)';
			svmfilt=union( find(rand(l,1) < (svl==class) .* 2000/sum(svl==class) ) , svmfilt );
		endfor
		svl=svl(svmfilt,:);
		svd=svd(svmfilt,:);
		
		tic;
		printf(['\n',num2str(length(svl)),' samples\n']);
		svm = svmtrain(double(svl),double(svd),'-h 0');
		toc;
		
		tic;
		fitness{i,j}=1;
		unique(tr{testdata})'
		correct=[];
		for class=unique(tr{testdata})';
			if( class ~= 0 )
			cor=svmFullFitnessTest ( 
				binEcosystem{i,j}.mbins , 
				binEcosystem{i,j}.rbins, 
				class*(tr{testdata}==class) , 
				im{testdata} , 
				svm )/100; 
			correct=[correct,cor];
			printf(['class ',num2str(class),': ',num2str(correct(end)),'\n']);
			endif
		endfor
		fitness{i,j}=mean(correct,'g');
		printf(['total fitness: ',num2str(fitness{i,j}),'\n']);
		toc;
	endfor
endfor

tic;
binEcosystem2=binEcosystem;
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
		printf(['Evolving (',num2str(i),',',num2str(j),')...\n']);
		maxfitness=fitness{i,j};
		evolvebase=[i,j];
		%find fitter neighbors
		if(i>1 && fitness{i-1,j} > maxfitness)
			maxfitness=fitness{i-1,j};
			evolvebase=[i-1,j];
		endif
		if(i<size(binEcosystem,1) && fitness{i+1,j} > maxfitness)
			maxfitness=fitness{i+1,j};
			evolvebase=[i+1,j];
		endif
		if(j>1 && fitness{i,j-1} > maxfitness)
			maxfitness=fitness{i,j-1};
			evolvebase=[i,j-1];
		endif
		if(j<size(binEcosystem,2) && fitness{i,j+1} > maxfitness)
			maxfitness=fitness{i,j+1};
			evolvebase=[i,j+1];
		endif
		
		if( evolvebase(1) != i || evolvebase(2) != j )
			binEcosystem2{i,j}.mbins=mbinEvolve(binEcosystem{evolvebase(1),evolvebase(2)}.mbins, 1-fitness{i,j} ) ;
			binEcosystem2{i,j}.rbins=rbinEvolve(binEcosystem{evolvebase(1),evolvebase(2)}.rbins, 1-fitness{i,j} ) ;
		endif
	endfor
endfor
toc;
binEcosystem=binEcosystem2;
clear binEcosystem2;


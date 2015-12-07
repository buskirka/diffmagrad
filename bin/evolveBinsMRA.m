more off;

dir=pwd;
if( exist('im','var') == 0)
	printf('Loading Hamina\n');
	cd([dir,'/Hamina-LC81860182013237LGN00/']);
	[ im{1} , tr{1} ] = loadL8data ;
	printf('Loading MoncksCorner\n');
	cd([dir,'/MoncksCorner-LC80160372015204LGN00/']);
	[ im{2} , tr{2} ] = loadL8data ;
	printf('Loading MayesCounty\n');
	cd([dir,'/MayesCounty-LC80270352015281LGN00/']);
	[ im{3} , tr{3} ] = loadL8data ;
	printf('Loading TheDalles\n');
	cd([dir,'/TheDalles-LC80450282015295LGN00/']);
	[ im{4} , tr{4} ] = loadL8data ;
end
cd(dir);

bands=[1:7,10,11];

if( exist('binEcosystem','var') == 0)
	printf('Creating a binEcosystem (load one first to use it instead)\n');
	for i=1:4;
	for j=1:4;
		for layer=1:length(bands)
			binEcosystem{i,j}.rbins{layer}=double([0,2*j]');
			binEcosystem{i,j}.sines(layer)=i;
		endfor
	endfor
	endfor
end

testdata=randi([1,length(im)]);

clear fitness;
%Compute fitness of bins
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
		tic;
		svl=[]; svd=[];
		printf(['Computing fitness for (',num2str(i),',',num2str(j),')...\n']);
		for imscan=1:length(im)
			if( testdata ~= imscan )	
				[svlp,svdp]=labelRFDFullExtract(
					tr{imscan} ,
					im{imscan}(bands) ,
					binEcosystem{i,j}.rbins ,
					binEcosystem{i,j}.sines ) ;
				svl=[svl;svlp];
				svd=[svd;svdp];
			endif
		end
		toc;
		
		classcount=[unique(svl),arrayfun(@(x) sum(svl==x),unique(svl))];
		if( max( classcount(:,2) ) > 2* min( classcount(:,2) ) )
			warning('Data set highly imbalanced! Automatically undersampling!');
			%For heavily imbalanced datasets, undersample the larger set.
			minimum_class=min(classcount(:,2));
			svd2=[];
			svl2=[];
			for class_label=unique(svl)'
				list=find( svl == class_label );
				[~,shufind]=sort(rand(1,length(list)));
				svd2=[svd2;svd(list(shufind))];
				svl2=[svl2;svl(list(shufind))];
			end
			svd=svd2;
			svl=svl2;
		end

		tic;
		printf(['\n',num2str(length(svl)),' samples']);
		svm = svmtrain(double(svl),double(svd),'-h 0');
		toc;
		
		tic;
		truePos{i,j}=svmRFDFullFitnessTest ( 
			255*(tr{testdata}==255) , 
			im{testdata}(bands) , 
			svm ,
			binEcosystem{i,j}.rbins ,
			binEcosystem{i,j}.sines )/100; 
    	    	trueNeg{i,j}=svmRFDFullFitnessTest (
			128*(tr{testdata}==128) ,
			im{testdata}(bands) ,
			svm ,
			binEcosystem{i,j}.rbins ,
			binEcosystem{i,j}.sines ) /100;
		fitness{i,j} = truePos{i,j} * trueNeg{i,j}; 
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
			binEcosystem2{i,j}.rbins=rbinEvolve(binEcosystem{evolvebase(1),evolvebase(2)}.rbins, 1-fitness{i,j} ) ;
			binEcosystem2{i,j}.sines=min(binEcosystem{i,j}.sines+fix(randn(size(binEcosystem{i,j}.sines))),ones(size(binEcosystem{i,j}.sines)));
		endif
	endfor
endfor
toc;
binEcosystem=binEcosystem2;
clear binEcosystem2;


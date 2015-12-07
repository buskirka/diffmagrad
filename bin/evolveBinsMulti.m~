more off;

dir=pwd;
if( exist('Hamina','var') == 0)
	printf('Loading Hamina\n');
	cd([dir,'/Hamina-LC81860182013237LGN00/']);
	[ Hamina , trainingHamina ] = loadL8data ;
end
if( exist('MoncksCorner','var') == 0)
	printf('Loading MoncksCorner\n');
	cd([dir,'/MoncksCorner-LC80160372015204LGN00/']);
	[ MoncksCorner , trainingMoncksCorner ] = loadL8data ;
end
if( exist('MayesCounty','var') == 0)
	printf('Loading MayesCounty\n');
	cd([dir,'/MayesCounty-LC80270352015281LGN00/']);
	[ MayesCounty , trainingMayesCounty ] = loadL8data ;
end
if( exist('TheDalles','var') == 0)
	printf('Loading TheDalles\n');
	cd([dir,'/TheDalles-LC80450282015295LGN00/']);
	[ TheDalles , trainingTheDalles ] = loadL8data ;
end
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

testdata=randi([1,4]);

clear fitness;
%Compute fitness of bins
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
		tic;
		svl=[]; svd=[];
		printf(['Computing fitness for (',num2str(i),',',num2str(j),')...\n']);
		if( testdata ~= 1 )	
			printf('\nHamina ');
			[svlp,svdp]=labelFullExtract(
        	   	binEcosystem{i,j}.mbins ,
				binEcosystem{i,j}.rbins ,
				trainingHamina ,
				Hamina(1:7) ) ;
			svl=[svl;svlp];
			svd=[svd;svdp];
		endif
		if( testdata ~= 2 )	
			printf('\nMoncksCorner ');
			[svlp,svdp]=labelFullExtract(
        	   	binEcosystem{i,j}.mbins ,
				binEcosystem{i,j}.rbins ,
				trainingMoncksCorner ,
				MoncksCorner(1:7) ) ;
			svl=[svl;svlp];
			svd=[svd;svdp];
		endif
		if( testdata ~= 3 )	
			printf('\nMayesCounty ');
			[svlp,svdp]=labelFullExtract(
        	   	binEcosystem{i,j}.mbins ,
				binEcosystem{i,j}.rbins ,
				trainingMayesCounty ,
				MayesCounty(1:7) ) ;
			svl=[svl;svlp];
			svd=[svd;svdp];
		endif
		if( testdata ~= 4 )	
			printf('\nTheDalles ');
			[svlp,svdp]=labelFullExtract(
        	   	binEcosystem{i,j}.mbins ,
				binEcosystem{i,j}.rbins ,
				trainingTheDalles ,
				TheDalles(1:7) ) ;
			svl=[svl;svlp];
			svd=[svd;svdp];
		endif
		toc;
		
		l=size(svl,1);
		svmfilt=union( find(rand(l,1) < sum(svl==255)/sum(svl==128) ) , find(svl == 255) );
		svl=svl(svmfilt,:);
		svd=svd(svmfilt,:);
		
		tic;
		printf(['\n',num2str(length(svl)),' samples']);
		svm = svmtrain(double(svl),double(svd),'-h 0');
		toc;
		
		tic;
		if( testdata == 1) % Test against Hamina
			truePos{i,j}=svmFullFitnessTest ( 
				binEcosystem{i,j}.mbins , 
				binEcosystem{i,j}.rbins, 
				255*(trainingHamina==255) , 
				Hamina(1:7) , 
				svm )/100; 
    	    trueNeg{i,j}=svmFullFitnessTest (
    	        binEcosystem{i,j}.mbins ,
    	        binEcosystem{i,j}.rbins,
    	        128*(trainingHamina==128) ,
    	        Hamina(1:7) ,
    	        svm ) /100;
			fitness{i,j} = truePos{i,j} * trueNeg{i,j}; 
		endif
		if( testdata == 2) % Test against MoncksCorner
			truePos{i,j}=svmFullFitnessTest ( 
				binEcosystem{i,j}.mbins , 
				binEcosystem{i,j}.rbins, 
				255*(trainingMoncksCorner==255) , 
				MoncksCorner(1:7) , 
				svm )/100; 
    	    trueNeg{i,j}=svmFullFitnessTest (
    	        binEcosystem{i,j}.mbins ,
    	        binEcosystem{i,j}.rbins,
    	        128*(trainingMoncksCorner==128) ,
    	        MoncksCorner(1:7) ,
    	        svm ) /100;
			fitness{i,j} = truePos{i,j} * trueNeg{i,j}; 
		endif
		if( testdata == 3) % Test against MayesCounty
			truePos{i,j}=svmFullFitnessTest ( 
				binEcosystem{i,j}.mbins , 
				binEcosystem{i,j}.rbins, 
				255*(trainingMayesCounty==255) , 
				MayesCounty(1:7) , 
				svm )/100; 
    	    trueNeg{i,j}=svmFullFitnessTest (
    	        binEcosystem{i,j}.mbins ,
    	        binEcosystem{i,j}.rbins,
    	        128*(trainingMayesCounty==128) ,
    	        MayesCounty(1:7) ,
    	        svm ) /100;
			fitness{i,j} = truePos{i,j} * trueNeg{i,j}; 
		endif
		if( testdata == 4) % Test against TheDalles
			truePos{i,j}=svmFullFitnessTest ( 
				binEcosystem{i,j}.mbins , 
				binEcosystem{i,j}.rbins, 
				255*(trainingTheDalles==255) , 
				TheDalles(1:7) , 
				svm )/100; 
    	    trueNeg{i,j}=svmFullFitnessTest (
    	        binEcosystem{i,j}.mbins ,
    	        binEcosystem{i,j}.rbins,
    	        128*(trainingTheDalles==128) ,
    	        TheDalles(1:7) ,
    	        svm ) /100;
			fitness{i,j} = truePos{i,j} * trueNeg{i,j}; 
		endif
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



dir=pwd;
if( exist('Charlotte','var') == 0)
	printf('Loading Charlotte\n');
	cd '/home/adam/Documents/Education/SDSU/gra-u2015/data/Charlotte-LC80170362015019LGN00/';
	[ Charlotte, trainingCharlotte ] = loadL8data ;
end
if( exist('trainingCharlotte','var') == 0)
	printf('Loading trainingCharlotte\n');
	cd '/home/adam/Documents/Education/SDSU/gra-u2015/data/Charlotte-LC80170362015019LGN00/';
	[ Charlotte, trainingCharlotte ] = loadL8data ;
end
if( exist('trainingHamina','var') == 0)
	printf('Loading trainingHamina\n');
	cd '/home/adam/Documents/Education/SDSU/gra-u2015/data/Hamina-LC81860182013237LGN00/';
	[ Hamina, trainingHamina ] = loadL8data ;
end
if( exist('Hamina','var') == 0)
	printf('Loading Hamina\n');
	cd '/home/adam/Documents/Education/SDSU/gra-u2015/data/Hamina-LC81860182013237LGN00/';
	[ Hamina, trainingHamina ] = loadL8data ;
end
cd(dir);

if( exist('binEcosystem','var') == 0)
	printf('Creating a binEcosystem (load one first to use it instead)\n');
	for i=1:5;
	for j=1:5;
		for layer=1:7
			binEcosystem{i,j}.mbins{layer}=double([0,100*i]');
			binEcosystem{i,j}.rbins{layer}=double([0,2*j]');
		endfor
	endfor
	endfor
end

clear fitness;
%Compute fitness of bins
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
		printf(['Computing fitness for (',num2str(i),',',num2str(j),')...\n']);
		svm=svmFullExtract(
                	binEcosystem{i,j}.mbins ,
			binEcosystem{i,j}.rbins ,
			trainingHamina ,
			Hamina(1:7) ,
			"-h 0") ;
		truePos{i,j}=svmFullFitnessTest ( 
			binEcosystem{i,j}.mbins , 
			binEcosystem{i,j}.rbins, 
			255*(trainingCharlotte==255) , 
			Charlotte(1:7) , 
			svm )/100; 
                trueNeg{i,j}=svmFullFitnessTest (
                        binEcosystem{i,j}.mbins ,
                        binEcosystem{i,j}.rbins,
                        128*(trainingCharlotte==128) ,
                        Charlotte(1:7) ,
                        svm ) /100;
		fitness{i,j} = truePos{i,j} * trueNeg{i,j}; 
	endfor
endfor

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
			binEcosystem2{i,j}.mbins=mbinEvolve(binEcosystem{evolvebase(1),evolvebase(2)}.mbins, 0.05.^(1.5-i/2) ) ;
			binEcosystem2{i,j}.rbins=rbinEvolve(binEcosystem{evolvebase(1),evolvebase(2)}.rbins, 0.05.^(1.5-j/2) ) ;
		endif
	endfor
endfor
binEcosystem=binEcosystem2;
clear binEcosystem2;


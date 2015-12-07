
dir=pwd;
if( exist('Charlotte','var') == 0)
	printf('Loading Charlotte\n');
	cd '/home/buskirka/gra-u2015/data/Charlotte-LC80170362015019LGN00/';
	[ Charlotte, trainingCharlotte ] = loadL8data ;
end
if( exist('trainingCharlotte','var') == 0)
	printf('Loading trainingCharlotte\n');
	cd '/home/buskirka/gra-u2015/data/Charlotte-LC80170362015019LGN00/';
	[ Charlotte, trainingCharlotte ] = loadL8data ;
end
if( exist('trainingMoncksCorner','var') == 0)
	printf('Loading trainingMoncksCorner\n');
	cd '/home/buskirka/gra-u2015/data/MoncksCorner-LC80160372015028LGN00/';
	[ MoncksCorner, trainingMoncksCorner ] = loadL8data ;
end
if( exist('MoncksCorner','var') == 0)
	printf('Loading MoncksCorner\n');
	cd '/home/buskirka/gra-u2015/data/MoncksCorner-LC80160372015028LGN00/';
	[ MoncksCorner, trainingMoncksCorner ] = loadL8data ;
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

clear fitness;
%Compute fitness of bins
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
		printf(['Computing fitness for (',num2str(i),',',num2str(j),')...\n']);
		svm=svmFullExtract(
                	binEcosystem{i,j}.mbins ,
			binEcosystem{i,j}.rbins ,
			trainingMoncksCorner ,
			MoncksCorner(1:7) ) ;
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
		best=true;

		%find fitter neighbors
		if(i>1 && fitness{i-1,j} > fitness{i,j})
			best=false;
			binEcosystem2{i,j} = binsplice(binEcosystem2{i,j}, binEcosystem{i-1,j});
		endif
		if(i<size(binEcosystem,1) && fitness{i+1,j} > fitness{i,j})
			best=false;
			binEcosystem2{i,j} = binsplice(binEcosystem2{i,j}, binEcosystem{i+1,j});
		endif
		if(j>1 && fitness{i,j-1} > fitness{i,j})
			best=false;
			binEcosystem2{i,j} = binsplice(binEcosystem2{i,j}, binEcosystem{i,j-1});
		endif
		if(j<size(binEcosystem,2) && fitness{i,j+1} > fitness{i,j})
			best=false;
			binEcosystem2{i,j} = binsplice(binEcosystem2{i,j}, binEcosystem{i,j+1});
		endif
		if(best==false)
			binEcosystem2{i,j}.mbins=mbinEvolve(binEcosystem{i,j}.mbins, 1-fitness{i,j} ) ;
			binEcosystem2{i,j}.rbins=rbinEvolve(binEcosystem{i,j}.rbins, 1-fitness{i,j} ) ;
		endif
	endfor
endfor
binEcosystem=binEcosystem2;
clear binEcosystem2;


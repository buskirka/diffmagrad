more off;

dir=pwd;
if( exist('im','var') == 0)
	printf('Loading Hamina\n');
	cd([dir,'/Hamina-LC81860182013237LGN00/']); fflush(stdout);
	[ im{1} , tr{1} ] = loadL8data ;
	printf('Loading MoncksCorner\n'); fflush(stdout);
	cd([dir,'/MoncksCorner-LC80160372015204LGN00/']);
	[ im{2} , tr{2} ] = loadL8data ;
	printf('Loading MayesCounty\n'); fflush(stdout);
	cd([dir,'/MayesCounty-LC80270352015281LGN00/']);
	[ im{3} , tr{3} ] = loadL8data ;
	printf('Loading TheDalles\n'); fflush(stdout);
	cd([dir,'/TheDalles-LC80450282015295LGN00/']);
	[ im{4} , tr{4} ] = loadL8data ;
end
cd(dir);

bands=[1:7,10,11];

if( exist('binEcosystem','var') == 0)
	printf('Creating a binEcosystem (load one first to use it instead)\n');
	for i=1:8;
	for j=1:8;
		for layer=1:length(bands)
			binEcosystem{i,j}.rbins{layer}=double([0,2+j]');
			binEcosystem{i,j}.sines(layer)=min(32,4+i);
		endfor
		binEcosystem{i,j}.costs=[1,1];
		binEcosystem{i,j}.bands=ones(size(bands));
		binEcosystem{i,j}.live=1;
	endfor
	endfor
end

testdata=randi([1,length(im)]);

%Compute fitness of bins
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
		tic;
		if(binEcosystem{i,j}.live==1)
			filt=find(binEcosystem{i,j}.bands);
			localbands=bands(filt);
			printf(['Computing fitness for (',num2str(i),',',num2str(j),')...']);
			normmat=0;
			for imscan=1:length(im)
				printf(['sample ',num2str(imscan)]);
				[svlp{imscan},svdp{imscan}]=labelRFDFullExtract(
					tr{imscan} ,
					im{imscan}(localbands) ,
					binEcosystem{i,j}.rbins(filt) ,
					binEcosystem{i,j}.sines(filt) ) ;
				normmat=max(normmat,max(svdp{imscan}));
			end
			normmat=diag(1./normmat);
			for imscan=1:length(im)
				svdp{imscan}=svdp{imscan}*normmat;
			end
			toc;

			fitness{i,j}=0;
			for imscan=1:length(im)
				svl=[]; svd=[];
				for imscan2=1:length(im)
					if( imscan ~= imscan2 )
						svl=[svl;svlp{imscan2}];
						svd=[svd;svdp{imscan2}];
					else
						% For optimization's sake, we want to see whether or not we can even detect the originally trained data.
						% This should be removed later.
						%svl=[svl;svlp{imscan2}];
						%svd=[svd;svdp{imscan2}];
					endif
				endfor
				
				classcount=[unique(svl),arrayfun(@(x) sum(svl==x),unique(svl))];
				if( max( classcount(:,2) ) > 3 * min( classcount(:,2) ) )
					warning('Data set highly imbalanced! Automatically undersampling!');
					%For heavily imbalanced datasets, undersample the larger set.
					minimum_class=min(classcount(:,2));
					svd2=[];
					svl2=[];
					for class_label=unique(svl)'
						list=find( svl == class_label );
						[~,shufind]=sort(rand(1,length(list)));
						svd2=[svd2;svd(list(shufind(1:min(end,minimum_class))),:)];
						svl2=[svl2;svl(list(shufind(1:min(end,minimum_class))))];
					endfor
					svd=svd2;
					svl=svl2;
				endif
				
				printf([mat2str(size(svd)),'\n']);
				opt=['-h 0 -q -w128 ',num2str(binEcosystem{i,j}.costs(1)),' -w255 ',num2str(binEcosystem{i,j}.costs(2))];
				svm = svmtrain(double(svl),double(svd),opt);
			
				predlab=svmpredict( double(svlp{imscan}), double(svdp{imscan}), svm , '-q');
				pos=find(svlp{imscan}==255);
				truePos{i,j,imscan}=mean( svlp{imscan}(pos) == predlab(pos) ); 
				neg=find(svlp{imscan}==128);
				trueNeg{i,j,imscan}=mean( svlp{imscan}(neg) == predlab(neg) );
				printf([num2str(sqrt(truePos{i,j,imscan}*trueNeg{i,j,imscan})),'\n']);
				fitness{i,j} += sqrt(truePos{i,j,imscan} * trueNeg{i,j,imscan}) / length(im); 
			endfor
			printf(['Fitness determined to be: ',num2str(fitness{i,j}),'\n']); fflush(stdout);
		elseif(binEcosystem{i,j}.live>1)
			printf(['Skipped maximal cell ',mat2str([i,j]),'\n']); fflush(stdout);
			binEcosystem{i,j}.live = binEcosystem{i,j}.live - 1;
		else
			printf(['Skipped dead cell ',mat2str([i,j]),'\n']); fflush(stdout);
			fitness{i,j}=0;
		endif
	endfor
endfor

selection_fitness=min(sort(cell2mat(fitness)(:),'descend')(1:32))
tic;
binEcosystem2=binEcosystem;
existsLiveCell=false;
for i=1:size(binEcosystem,1)
	for j=1:size(binEcosystem,2)
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
			printf(['Evolving (',num2str(i),',',num2str(j),')...']);
			binEcosystem2{i,j}.rbins=rbinEvolve(binEcosystem{evolvebase(1),evolvebase(2)}.rbins, 1-fitness{i,j} ) ;
			binEcosystem2{i,j}.sines=max(binEcosystem{evolvebase(1),evolvebase(2)}.sines+fix(randn(size(binEcosystem{evolvebase(1),evolvebase(2)}.sines))),2*ones(size(binEcosystem{evolvebase(1),evolvebase(2)}.sines)));
			binEcosystem2{i,j}.costs=binEcosystem{evolvebase(1),evolvebase(2)}.costs .* (0.9+0.2*rand(size(binEcosystem{evolvebase(1),evolvebase(2)}.costs)));
			bandtoggle=round(rand(size(bands)).^20);
			binEcosystem2{i,j}.bands=mod(binEcosystem{evolvebase(1),evolvebase(2)}.bands+bandtoggle,2);
			if(max(binEcosystem2{1,1}.bands)==0)
				binEcosystem2{1,1}.bands(3)=1;
			endif
			binEcosystem2{i,j}.live=1;
			existsLiveCell=true;
		elseif( maxfitness==0 && binEcosystem{i,j}.live==1)
			printf(['Cell ',mat2str([i,j]),' is dead.\n']);fflush(stdout);
			binEcosystem2{i,j}.live=0;
		elseif( maxfitness>0 && binEcosystem{i,j}.live > 1 )
			% In this case, this cell is a nonzero maximum, and thus lives and is given a number of 
			% iterations of immunity.
			binEcosystem2{i,j}.live=5;
			existsLiveCell=true;
		endif

		if( fitness{i,j} < selection_fitness )
			binEcosystem2{i,j}.live=0;
		endif
	endfor
endfor
if( existsLiveCell == false )
	% If no living cell exists, seed the first square with some random amino acids.
	for layer=1:length(bands)
		binEcosystem2{1,1}.rbins{layer}=double([0,2+randi([1,10]')]+randi([1,10]))';
		binEcosystem2{1,1}.sines(layer)=min(32,4+randi([0,18]));
	endfor
	binEcosystem2{1,1}.costs=rande(1,2);
	binEcosystem2{1,1}.bands=randi([0,1],size(bands));
	if(max(binEcosystem2{1,1}.bands)==0)
		binEcosystem2{1,1}.bands(3)=1;
	endif
	binEcosystem2{1,1}.live=1;
	binEcosystem2{1,1}
endif
toc;
binEcosystem=binEcosystem2;
clear binEcosystem2;


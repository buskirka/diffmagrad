bands=[1:7,10,11];

if( exist('binEcosystem','var') == 0 )
    printf('Creating binEcosystem.\n'); fflush(stdout);
    binsize=input('Size? > ');
	printf('Creating a binEcosystem (load one first to use it instead)\n');
	for i=1:binsize;
	for j=1:binsize;
		for layer=1:length(bands)
			binEcosystem{i,j}.rbins{layer}=double([0,2+j]');
			binEcosystem{i,j}.mbins{layer}=double([0,100*j]');
		endfor
		binEcosystem{i,j}.costs=[1,1];
		binEcosystem{i,j}.bands=ones(size(bands));
		binEcosystem{i,j}.live=1;
	endfor
	endfor
end

%Construct sample selections for this iteration
clear samplesel;
samplesel=cell(10,1);
testingsel=cell(size(samplesel));
for i=1:length(samplesel) ;
    samplesel{i}=(rand(size(tr))<0.4);
    testingsel{i}=(rand(size(tr))<0.4) .* (1-samplesel{i});
    while( (sum(samplesel{i}) < 30) || (sum(testingsel{i}) < 5) )
        samplesel{i}=(rand(size(tr))<0.4);
        testingsel{i}=(rand(size(tr))<0.4) .* (1-samplesel{i});
    endwhile
    samplesel{i}
    testingsel{i}
endfor

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
				[svlp{imscan},svdp{imscan}]=labelFullExtract(
					binEcosystem{i,j}.mbins(filt),
					binEcosystem{i,j}.rbins(filt),
					tr{imscan} ,
					im{imscan}(filt) ) ;
				normmat=max(normmat,max(svdp{imscan}));
			end
			normmat=diag(1./normmat);
			for imscan=1:length(im)
				svdp{imscan}=svdp{imscan}*normmat;
			end
			toc;

			fitness{i,j}=0;
			for selscan=1:length(samplesel)
				svl=[]; svd=[];
                svltest=[]; svdtest=[];
				for imscan2=1:length(im)
					if( samplesel{selscan}(imscan2) == 1 )
						svl=[svl;svlp{imscan2}];
						svd=[svd;svdp{imscan2}];
					elseif( testingsel{selscan}(imscan2) == 1 )
						% This gives us data to test against.
						svltest=[svltest;svlp{imscan2}];
						svdtest=[svdtest;svdp{imscan2}];
					endif
				endfor
				
				classcount=[unique(svl),arrayfun(@(x) sum(svl==x),unique(svl))];
				if( max( classcount(:,2) ) > 3 * min( classcount(:,2) ) )
					warning('Training data set highly imbalanced! Automatically undersampling!');
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
				
                classcount=[unique(svltest),arrayfun(@(x) sum(svltest==x),unique(svltest))];
				if( max( classcount(:,2) ) > 3 * min( classcount(:,2) ) )
					warning('Testing set highly imbalanced! Automatically undersampling!');
					%For heavily imbalanced datasets, undersample the larger set.
					minimum_class=min(classcount(:,2));
					svd2=[];
					svl2=[];
					for class_label=unique(svl)'
						list=find( svltest == class_label );
						[~,shufind]=sort(rand(1,length(list)));
						svd2=[svd2;svdtest(list(shufind(1:min(end,minimum_class))),:)];
						svl2=[svl2;svltest(list(shufind(1:min(end,minimum_class))))];
					endfor
					svdtest=svd2;
					svltest=svl2;
				endif
				
				printf([mat2str(size(svd)),'\n']);
				opt=['-h 0 -q -w128 ',num2str(binEcosystem{i,j}.costs(1)),' -w255 ',num2str(binEcosystem{i,j}.costs(2))];
				svm = svmtrain(double(svl),double(svd),opt);
			    

				printf([mat2str(size(svdtest)),'\n']);
				predlab=svmpredict( double(svltest), double(svdtest), svm , '-q');
				pos=find(svltest==255);
    		    truePos{i,j,selscan}=min(1,mean( svltest(pos) == predlab(pos) )); 
				neg=find(svltest==128);
		        trueNeg{i,j,selscan}=min(1,mean( svltest(neg) == predlab(neg) )); 
				printf([num2str(sqrt(truePos{i,j,selscan}*trueNeg{i,j,selscan})),' (',num2str(truePos{i,j,selscan}),',',num2str(trueNeg{i,j,selscan}),')\n']);
				fitness{i,j} += sqrt(truePos{i,j,selscan} * trueNeg{i,j,selscan}) / length(samplesel); 
			endfor
            % Punish excess of bins:
            fitness{i,j} = fitness{i,j} * min( 1 , 0.999^size(svd,2) );
			printf(['Fitness determined to be: ',num2str(fitness{i,j}),'\n']); fflush(stdout);
		elseif(binEcosystem{i,j}.live>1)
			printf(['Skipped maximal cell ',mat2str([i,j]),'\n']); fflush(stdout);
			binEcosystem{i,j}.live = binEcosystem{i,j}.live - 1;
		else
			printf(['Skipped dead cell ',mat2str([i,j]),'\n']); fflush(stdout);
			fitness{i,j}=0;
		endif
        toc
	endfor
endfor

if( prod(size(fitness)) > 32)
    selection_fitness=min(sort(cell2mat(fitness)(:),'descend')(1:32))
else
    selection_fitness=0;
endif
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
			binEcosystem2{i,j}.mbins=mbinEvolve(binEcosystem{evolvebase(1),evolvebase(2)}.mbins, 1-fitness{i,j} ) ;
			binEcosystem2{i,j}.costs=binEcosystem{evolvebase(1),evolvebase(2)}.costs .* (0.9+0.2*rand(size(binEcosystem{evolvebase(1),evolvebase(2)}.costs)));
			bandtoggle=round(rand(size(bands)).^20);
			binEcosystem2{i,j}.bands=mod(binEcosystem{evolvebase(1),evolvebase(2)}.bands+bandtoggle,2);
			if(max(binEcosystem2{i,j}.bands)==0)
				binEcosystem2{i,j}.bands(3)=1;
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
toc;
binEcosystem=binEcosystem2;
clear binEcosystem2;


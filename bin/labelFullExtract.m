## -*- texinfo -*-
## @deftypefn {Function File} {[@var{svl}, @var{svd}] =} labelFullExtract (@var{mbins}, @var{rbins}, @var{training}, @var{data})
## Extracts the Differential-Magnitude and Radius Descriptor from a cell
## array of images for the purpose of training and testing support-vector
## machines.
## 
## If @var{data} is a @nospell{N}-layer image, then all of @var{mbins}, @var{rbins},
## and @var{data} should be @nospell{1xN}-dimensional cell arrays; the image layer
## in a cell in @var{data} will be described by the bin configuration specified by
## the corresponding cells in @var{mbins} and @var{rbins}.
## 
## The cells in @var{mbins} and @var{rbins} should each be @nospell{2xM} matrices (for
## some @nospell{M}, which may differ between cells), increasing down the 2-length
## dimension, specifying respectively the magnitudinal and radial bins into which the
## radial derivative around a point should be divided according to the DMR method.
##
## The return values @var{svl} and @var{svd} are a vector of labels extracted from the points
## in @var{data} and the DMR descriptors of those points, respectively; @var{svl}(i)  
## corresponds to the vector @var{svd}(i,:) to match the input requirements for the
## standard @code{svmtrain} and @code{svmpredict} functions.
## 
## @end deftypefn

function [svl,svd] = labelFullExtract(mbins,rbins,DataTraining,DataCells)
	if(nargin<4)
		print_usage;
	endif
	svl=[]; 
	svd=[]; 
	printf(['\nlabelFullExtract:']); 
	for i=100:100:(size(DataCells{1},1)-100); 
		for j=100:100:(size(DataCells{1},2)-100); 
			if(max(max(neighborhood(DataTraining,[i,j],50))) > 0); 
				printf(['(',num2str(i),',',num2str(j),') ']); 
				fflush(stdout); 
				[l,d]=svmSampleExtract(mbins,rbins,DataTraining,DataCells,50,[i,j]); 
				svl=[svl;l]; 
				svd=[svd;d];
			endif
		endfor
	endfor
endfunction

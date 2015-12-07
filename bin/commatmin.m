function rmat = commatmin ( data , watermark )
	if( exist('watermark','var') )
		filter=(data <= watermark);
	else
		filter=(data ~= 0);
	endif
	negspace=prod(size(data))+1;

	% Construct a unique value matrix
	rmat = (@(M) diag(1:size(M,1))*ones(size(M)) + ones(size(M))*diag(0:size(M,1):(size(M,1)*size(M,2)-1)) )(data) ;

	%Shuffle the matrix to improve distribution of maxima
	rmat=( (eye(size(rmat,1)))(nthargout(2, @sort, rand(size(rmat,1),1)),:) ) ...
	* rmat ...
	* ( (eye(size(rmat,2)))(nthargout(2, @sort, rand(size(rmat,2),1)),:) );
	
	changes=true;
	rmat = rmat .* filter + negspace .* (ones(size(filter))-filter);
	counter=0;
	while( changes > 0)
		counter += 1 ;
		rmatnew = min( rmat, tr(1,0,rmat) + negspace * (ones(size(rmat))-tr(1,0,ones(size(rmat))) ) );
		rmatnew = min( rmatnew, tr(-1,0,rmat) + negspace * (ones(size(rmat))-tr(-1,0,ones(size(rmat))) ) );
		rmatnew = min( rmatnew, tr(0,1,rmat) + negspace * (ones(size(rmat))-tr(0,1,ones(size(rmat))) ) );
		rmatnew = min( rmatnew, tr(0,-1,rmat) + negspace * (ones(size(rmat))-tr(0,-1,ones(size(rmat))) ) );
		rmatnew = rmatnew .* filter + negspace .* (ones(size(filter))-filter);
		
		[cl1,cl2]=find(rmat ~= rmatnew); 
		cl=[cl1,cl2];
		changes = length(cl);
		if( mod(counter,15) == 0 )
		for i=unique(randi([1,length(cl)],1,7));
		printf([num2str(changes),': ']);
		if( cl(i,1) >1 )
			c1=rmatnew(cl(i,1),cl(i,2));
			c2=rmatnew(cl(i,1)-1,cl(i,2));
			if( c1 ~= negspace && c2 ~= negspace && c1 ~= c2 )
				printf([num2str(min(c1,c2)),'<-',num2str(max(c1,c2)),'(',num2str(sum(sum(rmatnew==c1))+sum(sum(rmatnew==c2))),'), ']);
				if(c1<c2)
					rmatnew+=(c1-c2)*(ones(size(rmat))-(rmatnew==c1)).*(rmatnew==c2);
				else
					rmatnew+=(c2-c1)*(ones(size(rmat))-(rmatnew==c2)).*(rmatnew==c1);
				endif
			endif
		endif
		if( cl(i,1) < size(rmat,1) )
			c1=rmatnew(cl(i,1),cl(i,2));
			c2=rmatnew(cl(i,1)+1,cl(i,2));
			if( c1 ~= negspace && c2 ~= negspace && c1 ~= c2 )
				printf([num2str(min(c1,c2)),'<-',num2str(max(c1,c2)),'(',num2str(sum(sum(rmatnew==c1))+sum(sum(rmatnew==c2))),'), ']);
				if(c1<c2)
					rmatnew+=(c1-c2)*(ones(size(rmat))-(rmatnew==c1)).*(rmatnew==c2);
				else
					rmatnew+=(c2-c1)*(ones(size(rmat))-(rmatnew==c2)).*(rmatnew==c1);
				endif
			endif
		endif
		if( cl(i,2) >1 )
			c1=rmatnew(cl(i,1),cl(i,2));
			c2=rmatnew(cl(i,1),cl(i,2)-1);
			if( c1 ~= negspace && c2 ~= negspace && c1 ~= c2 )
				printf([num2str(min(c1,c2)),'<-',num2str(max(c1,c2)),'(',num2str(sum(sum(rmatnew==c1))+sum(sum(rmatnew==c2))),'), ']);
				if(c1<c2)
					rmatnew+=(c1-c2)*(ones(size(rmat))-(rmatnew==c1)).*(rmatnew==c2);
				else
					rmatnew+=(c2-c1)*(ones(size(rmat))-(rmatnew==c2)).*(rmatnew==c1);
				endif
			endif
		endif
		if( cl(i,2) < size(rmat,2) )
			c1=rmatnew(cl(i,1),cl(i,2));
			c2=rmatnew(cl(i,1),cl(i,2)+1);
			if( c1 ~= negspace && c2 ~= negspace && c1 ~= c2 )
				printf([num2str(min(c1,c2)),'<-',num2str(max(c1,c2)),'(',num2str(sum(sum(rmatnew==c1))+sum(sum(rmatnew==c2))),'), ']);
				if(c1<c2)
					rmatnew+=(c1-c2)*(ones(size(rmat))-(rmatnew==c1)).*(rmatnew==c2);
				else
					rmatnew+=(c2-c1)*(ones(size(rmat))-(rmatnew==c2)).*(rmatnew==c1);
				endif
			endif
		endif
		printf('\n');
		fflush(stdout);
		endfor
		endif
		
		rmat=rmatnew;
		%[unique(rmat)(end-1),mean(unique(rmat)),length(unique(rmat)),changes]
	endwhile
	rmat = rmat .* filter;
endfunction

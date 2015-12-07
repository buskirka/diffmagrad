pkg load parallel

data=imread("LC80270292015073LGN00_B3.TIF")(3291-250:3291+250,4133-250:4133+250) ;

printf("Showing an arbitrarily chosen distinctive building.\nPress keys to continue.\n"); 
fflush(stdout);
imshow(data);
pause;

rbins=[0,2;2,5;5,8]'
mbins=[0,1;1,2;2,3]'

printf("This demonstration brought to you by the RSCIs (radial):\n");
for i=rbins
	printf(["(",num2str(i(1)),",",num2str(i(2)),"]\n"]);
endfor
printf("...and the RSCIs (magnitudinal):\n");
for i=mbins
	printf(["(",num2str(i(1)),",",num2str(i(2)),"]\n"]);
endfor
printf("Press keys to continue.\n"); 
fflush(stdout);
pause;

printf("Computing the Histomat DM-R; this may take some time...\n")
h = histomatpDMR(mbins, rbins, data);
printf("\nThank you for your patience!\n");
printf("Press keys to continue.\n"); 
pause;

for rb=1:length(rbins)
for mb=1:length(mbins)
	str=["sillybuilding-rb",num2str(rb),"-mb",num2str(mb),".tif"]
	b=h(:,:,mb,rb) ; imshow(b/max(max(b)));
	#imwrite(b/max(max(b)),str)
	pause;
endfor
endfor

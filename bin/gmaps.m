function im = gmaps( location )
		
	stringmaker = @(loc) ["https://maps.googleapis.com/maps/api/staticmap?center=",num2str(loc(1),20),",",num2str(loc(2),20),"&zoom=17&size=1024x1024&maptype=satellite&scale=2&format=jpg"];

	system(['wget "',stringmaker(location),'" -O junk.jpg']);
	im=imread('junk.jpg');
endfunction

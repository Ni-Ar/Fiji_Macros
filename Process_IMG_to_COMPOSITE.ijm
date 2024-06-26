// Author: Niccolò Arecco
// Date: 26 Jun 2024
// Title: Create a composite of the green and red channels and create a montage of 4 images (PNG output)
// Version: 1.0

// Code:
// Select GFP image
selectImage(1); 
image_path=getDir("image"); // get output paths
out_path = image_path + "composite/";
File.makeDirectory(out_path);
original_name = getTitle();
// get image name and number
ttl_handle = replace( original_name , "_GFP_00" , "_" ); 
ttl_handle = replace( ttl_handle , ".tif" , "" ); 

rename(ttl_handle + "_GFP");
GFP_title = getTitle();

// Select RFP image
selectImage(2); 
rename(ttl_handle + "_RFP");
RFP_title = getTitle();

// Select TRANS image
selectImage(3); 
rename(ttl_handle + "_TRANS");
TRANS_title = getTitle();

// Scale bar 50um
run("Scale Bar...", "width=100 height=25 thickness=10 font=14 color=White background=None location=[Lower Right] horizontal bold hide overlay");

// SAVE TRANS
out_TRANS = out_path + TRANS_title ;
saveAs("png", out_TRANS);
close();

print('Creating a composite of RFP & GFP');
run("Merge Channels...", "c1=" + RFP_title + " c2=" + GFP_title + " create keep");
rename(ttl_handle + "_GFP_RFP");
GFP_RFP_title = getTitle();
out_GFP_RFP = out_path + GFP_RFP_title + "_composite";
saveAs("png", out_GFP_RFP);
close();

// SAVE GFP
selectImage(1);
out_GFP = out_path + GFP_title ;
saveAs("png", out_GFP);
close();

// SAVE RFP
selectImage(1);
out_RFP = out_path + RFP_title ;
saveAs("png", out_RFP);
close();

print('Importing the images to create a montage...');
open(out_TRANS + ".png" );
open(out_GFP + ".png" );
open(out_RFP + ".png" );
open(out_GFP_RFP + ".png" );

run("Images to Stack", "use keep");
run("Make Montage...", "columns=4 rows=1 scale=0.25 last=6 border=5");
rename(ttl_handle + "_Montage");
Montage_title = getTitle();
out_montage_image = out_path + Montage_title ;
saveAs("png", out_montage_image);

// Exit
run("Close All");
print("Done!")
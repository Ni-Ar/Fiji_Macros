// Author: Niccolò Arecco
// Date: 30 Jun 2023
// Title: Z-Projection of 4 channels and create 2 composite and create a montage of 6 images (PNG output)
// Version: 1.0

// Code:
// Select DAPI image
selectImage(4); 
image_path=getDir("image"); // get output paths


run("Z Project...", "projection=[Max Intensity]");
original_name = getTitle();
ttl_handle = replace( original_name , ".czi #1 - C=[1-9]" , "" ); 
sample_name_image = replace( ttl_handle , ".czi - *.*$" , "" ); 
sample_name_image = replace( sample_name_image , "^MAX_" , "" ); 
rename(sample_name_image + "_DAPI");
DAPI_title = getTitle();
print('Image: ' + sample_name_image)
print('Output: ' + image_path)
print("Adding scale bar to DAPI image...")
// Scale bar 50um
run("Scale Bar...", "width=50 height=50 thickness=20 font=14 color=White background=None location=[Lower Right] horizontal bold hide overlay");
selectImage(4); close();

// Select H3K27me3
selectImage(3); run("Z Project...", "projection=[Max Intensity]");
rename(sample_name_image + "_H3K27me3");
run("Subtract...", "value=10");
run("Gaussian Blur...", "sigma=1");
run("Sharpen");
H3K27me3_title = getTitle();
selectImage(3); close();

// MAP2
selectImage(2); run("Z Project...", "projection=[Max Intensity]");
rename(sample_name_image + "_MAP2");
MAP2_title = getTitle();
selectImage(2); close();

// Tubb3
selectImage(1); run("Z Project...", "projection=[Max Intensity]");
rename(sample_name_image + "_TUBB3");
TUBB3_title = getTitle();
selectImage(1); close();

// Create composite
print('Creating a composite of TUBB3 & DAPI...')
run("Merge Channels...", "c1=" + TUBB3_title + " c4=" + DAPI_title + " create keep");
rename(sample_name_image + "_TUBB3_DAPI");
TUBB3_DAPI_title = getTitle();
out_TUBB3_DAPI_image = image_path + TUBB3_DAPI_title + "_composite";
// Maybe add stack to RGB before saving
// run("Stack to RGB");
saveAs("png", out_TUBB3_DAPI_image);
close();

print('Creating a composite of MAP2 & H3K27me3...');
run("Merge Channels...", "c2=" + H3K27me3_title + " c6=" + MAP2_title + " create keep");
rename(sample_name_image + "_MAP2_H3K27me3");
MAP2_H3K27me3_title = getTitle();
out_MAP2_H3K27me3_image = image_path + MAP2_H3K27me3_title + "_composite";
saveAs("png", out_MAP2_H3K27me3_image);
close();

// // Export individual images
print('Exporting individual channel as png...')
selectImage(1);
run("Grays");
out_DAPI_image = image_path + DAPI_title ;
saveAs("png", out_DAPI_image);
close();

selectImage(3);
run("Red");
out_TUBB3_image = image_path + TUBB3_title ;
saveAs("png", out_TUBB3_image);
close();

selectImage(2);
run("Magenta");
out_MAP2_image = image_path + MAP2_title ;
saveAs("png", out_MAP2_image);
close();

selectImage(1);
run("Green");
out_H3K27me3_image = image_path + H3K27me3_title ;
saveAs("png", out_H3K27me3_image);
close();

print('Importing the images to create a montage...')
open(out_DAPI_image + ".png" )
open(out_H3K27me3_image + ".png" )
open(out_TUBB3_image + ".png" )
open(out_MAP2_image + ".png" )
open(out_TUBB3_DAPI_image + ".png" )
open(out_MAP2_H3K27me3_image + ".png" )

run("Images to Stack", "use keep");
run("Make Montage...", "columns=6 rows=1 scale=0.25 last=6 border=5");
selectImage(8);
rename(sample_name_image + "_Montage");
Montage_title = getTitle();
out_montage_image = image_path + sample_name_image + "_montage";
saveAs("png", out_montage_image);

// Exit
run("Close All");
print("Done!")


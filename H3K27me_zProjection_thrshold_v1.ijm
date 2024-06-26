// Author: Niccolò Arecco
// Date: 03 July 2023
// Title: Z-Projection of DAPI stained nuclei and area quantification on thresholded binary images.
// Version: 1.0

// Code:
// close Tubb3 and Map2
selectImage(1); close();
selectImage(1); close();

// Select H3K27me3 image
selectImage(1);
// Extract sample image name and location
original_name = getTitle();
original_name_without_crap = replace( original_name , ".czi #1 - C=2" , "" ); 
sample_name_image = replace( original_name_without_crap , ".czi - *.*$" , "" ); 
image_path=getDir("image");
// Project the z-stack
run("Z Project...", "projection=[Max Intensity]");


//run("Subtract Background...", "rolling=20");
run("Enhance Contrast", "saturated=5");
// setMinAndMax(90, 100);
// resetMinAndMax();
// setMinAndMax(0, 255);

selectImage(2);
run("Z Project...", "projection=[Max Intensity]");
run("Enhance Contrast", "saturated=5");

// close previous 2 images
selectImage(1); close();
selectImage(1); close();

run("Images to Stack", "use keep");
run("Stack to RGB");
run("16-bit");
run("Enhance Contrast", "saturated=5");

selectImage("Stack");
close();

selectImage("Stack (RGB)");

setAutoThreshold("Huang dark no-reset");
setOption("BlackBackground", true);
setThreshold(20, 255);
run("Convert to Mask");

// weka segmentation
call("trainableSegmentation.Weka_Segmentation.getResult");

run("8-bit");

setAutoThreshold("Huang dark no-reset");
//run("Threshold...");
//setThreshold(84, 118);
run("Convert to Mask");
run("Watershed");
run("Erode");
run("Analyze Particles...", "size=10-Infinity show=[Overlay Masks] display exclude clear summarize overlay");
run("Close");


// Binarise the image and tidy the nuclei for threshold
run("Fill Holes");
run("Watershed");
//run("Make Binary");
//run("Gaussian Blur...", "sigma=2");
//run("Make Binary");
run("Erode");
// run("Smooth");
run("Remove Outliers...", "radius=2 threshold=10 which=Bright");
//run("Make Binary");
// run("Smooth");
run("Despeckle")

//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");

// Calculate area of the particles
run("Analyze Particles...", "size=10-Infinity show=[Overlay Masks] display exclude clear summarize overlay");

// Export results
selectWindow("Summary");
run("Close");
selectWindow("Results");
out_name = sample_name_image + "_DAPI_area_v1.1.csv";
out_path =  image_path + out_name
saveAs("Results", out_path);
selectWindow("Results");
run("Close");

// Save thresholded image
selectImage(5);
out_threshold_image = image_path + sample_name_image + "_thresholded_v1.1.png";
saveAs("png", out_threshold_image);

// Exit
run("Close All");

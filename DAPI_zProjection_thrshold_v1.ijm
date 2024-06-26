// Author: Niccolò Arecco
// Date: 30 Jun 2023
// Title: Z-Projection of DAPI stained nuclei and area quantification on thresholded binary images.
// Version: 1.1

// Code:
// Select DAPI image
selectImage(4);
// Extract sample image name and location
original_name = getTitle();
original_name_without_crap = replace( original_name , ".czi #1 - C=3" , "" ); 
sample_name_image = replace( original_name_without_crap , ".czi - *.*$" , "" ); 
image_path=getDir("image");
// Project the z-stack
run("Z Project...", "projection=[Max Intensity]");
run("Subtract...", "value=1");

run("Subtract Background...", "rolling=20");
run("Enhance Contrast", "saturated=5");
//run("Remove Outliers...", "radius=10 threshold=100 which=Bright");
run("Despeckle");
//run("Smooth");
//run("Enhance Contrast", "saturated=10");

// Export DAPI image
selectImage(5);
out_DAPI = sample_name_image + "_DAPI_ehnancedContrast_v1.1.png";
out_path_DAPI =  image_path + out_DAPI
saveAs("png", out_path_DAPI);

// Process image
// Gray Scale Attribute Filtering: Opening: Area Min value 50 connectivity 4.
// run("Morphological Filters", "operation=Erosion element=Disk radius=5");
// run("Morphological Filters", "operation=closing element=Disk radius=3");

setMinAndMax(0, 32);

// Thresholding
setAutoThreshold("Huang dark no-reset");
setOption("BlackBackground", true);
setThreshold(10, 255);
run("Convert to Mask");

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
setThreshold(5, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=50-Infinity pixel show=[Overlay Masks] display exclude clear summarize");

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

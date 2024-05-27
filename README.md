# Image-Processing
Automatic colour detection

Lego’s Life of George is a game where an image is displayed on the screen for a number of
seconds before being blanked. The player of the game then has to construct the shape from
Lego blocks from memory. The player photographs the finished blocks and their computer
automatically compares the brick pattern to the original image. Similar problems are found
in many image processing applications, for example the colour segmentation of real world
objects; colour data matrix reading. A colour data matrix has the advantage over conventional
blank and white versions in that more information can be stored for a given pattern.

Write a function called findColours(filename) that given the string filename,
loads an image and returns an array representing the colours found in the matrix. Please
break this down in to the following steps:
– findColours will call the following functions:
– A function image=loadImage(filename) that given the string filename,
loads an image and returns the image as type double.
– A function, circleCoordinates = findCircles(image) the locates
and returns the coordinates of the four black circles. 1
– Afunction the correctly un-distorts the images: correctImage(circleCoordinates
, image). Note, images maybe flipped since there is no correct orientation.
– A function colours=getColours(image) the takes the double image array,
image, and returns an array with the result of the colours. For now this will only
use the undistorted images (org_X.png and noise_X.png) The colours used
are red, green, yellow, blue and white.

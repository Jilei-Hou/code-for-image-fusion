DESCRIPTION
===========

Implementation of the method
AMEF - Artificial Multiple Exposure Fusion for Image Dehazing, 

described in:

"Image Dehazing by Artificial Multi-Exposure Image Fusion"
Adrian Galdran
Elsevier's Signal Processing Journal, 2018
DOI: updated soon
PDF: updated soon

The fusion part of the code borrows from the following work:
"Exposure Fusion",
Tom Mertens, Jan Kautz and Frank Van Reeth
In proceedings of Pacific Graphics 2007

Please consider citing each work appropriately if this code is useful for you. Thanks :)

INSTRUCTIONS
============
Open the amef_demo.m m-file and modify the image name to process your own images.
The most relevant parameter to play with is clip_range, which in the paper is fixed 
to c=0.010 for most of the experiments, although it can be varied: A larger clip_range 
will attemplt to remove more haze - at the risk of overenhancement.

All the examples shown in the paper can be reproduced with this code. Additional 
examples are also included for completeness.



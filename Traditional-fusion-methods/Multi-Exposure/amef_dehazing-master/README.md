# AMEF - Artificial Multiple Exposure Fusion for Image Dehazing

![](https://raw.githubusercontent.com/agaldran/website/master/static/img/overall_amef.png?style=centerme)
<p align="center">AMEF is a fast fog removal technique that fuses differently (artificially) underexposed versions of a hazy image into a single haze-free result<p align="center">

## DESCRIPTION
Matlab implementation of the AMEF method for image dehazing, described in:

```
Image Dehazing by Artificial Multi-Exposure Image Fusion
Adrian Galdran
Signal Processing, 149: 135-147, Aug. 2018.
```

* **PDF**: Follow this [link](https://agaldran.github.io/pdf/amef_dehazing.pdf)

* **DOI**: Follow this [link](https://doi.org/10.1016/j.sigpro.2018.03.008)


The fusion part of the code borrows from [the following work](https://github.com/Mericam/exposure-fusion):

"Exposure Fusion",  
Tom Mertens, Jan Kautz and Frank Van Reeth  
In proceedings of Pacific Graphics 2007

Please consider citing each work appropriately if this code is useful for you. Thanks :)

## INSTRUCTIONS
Open the `amef_demo.m` m-file and modify the image name to process your own images.

The most relevant parameter to play with is `clip_range`, which in the paper is fixed 
to `c=0.010` for most of the experiments, but it can be varied. A larger `clip_range` 
will attempt to remove more haze - at the risk of overenhancement:

![](https://raw.githubusercontent.com/agaldran/website/master/static/img/c_influence.png?style=centerme)
<p align="center">Influence of the clip-range parameter c on the behavior of AMEF: a) Hazy landscape b)-f) Result of dehazing with b) c=0.003 c) c=0.005 d) c=0.010 e) c=0.015 f) c=0.020<p align="center">


Running AMEF should be quite fast. As explained in the paper, I found that the average runtime tested on images of **720 x 480** resolution<a href="#note1" id="note1ref"><sup>1</sup></a> was **0.7 seconds**. 
If you need further speed, the computationally heaviest part of the method is the fusion scheme; there is an OpenCV implementation of it [here](https://docs.opencv.org/3.3.0/d7/dd6/classcv_1_1MergeMertens.html) that you may want to adapt. Have fun!

*All the examples shown in the paper can be reproduced with this code. Additional 
examples are also included for completeness.*

-------
<a id="note1" href="#note1ref"><sup>1</sup></a> In a computer with an Intel® Xeon® E5 CPU at 3.5 GHz. 


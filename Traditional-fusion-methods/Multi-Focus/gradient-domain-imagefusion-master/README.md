# Multi-Exposure and Multi-Focus Image Fusion

### Overview
This package is an implementation of the of the paper [Multi-exposure and Multi-focus Image Fusion in Gradient Domain](http://www.worldscientific.com/doi/pdf/10.1142/S0218126616501231), by [Sujoy Paul](http://www.ee.ucr.edu/~supaul/),  [Ioana S. Sevcenco](http://www.ece.uvic.ca/~iss/) and [Panajotis Agathoklis](http://www.ece.uvic.ca/~panagath/) and published at [Journal of Circuits, Systems, and Computers
](http://www.worldscientific.com/worldscinet/jcsc)

### Dependencies
The package depends on the [Wavelet Based Image Reconstruction](http://www.mathworks.com/matlabcentral/fileexchange/48066-wavelet-based-image-reconstruction-from-gradient-data), which is compiled into the file ReconstructGradient.m

### Data
The package uses a multi-exposure image sequence available with Matlab namely the 'office' sequence for demo purpose. Any other image sequence can be used with the package after making necessary changes for loading them in Demo.m

### Running
The package can be executed by running the Demo.m script which loads the example 'office' image sequence, applies the algorithm implemented in the package and displays the fused image along with the image sequence.

### Citation
Please cite the following work if you use this package.
```javascript
@article{paul2016multi,
  title={Multi-exposure and multi-focus image fusion in gradient domain},
  author={Paul, Sujoy and Sevcenco, Ioana S and Agathoklis, Panajotis},
  journal={Journal of Circuits, Systems and Computers},
  volume={25},
  number={10},
  pages={1650123},
  year={2016},
  publisher={World Scientific}

}
```

### Contact
Please contact Sujoy Paul (supaul@ece.ucr.edu) for any further queries regarding this package.





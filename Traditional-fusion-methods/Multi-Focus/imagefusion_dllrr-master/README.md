# Multi-focus Image Fusion using dictionary learning and Low-Rank Representation

SpringerLink: https://link.springer.com/chapter/10.1007/978-3-319-71607-7_59

arXiv: https://arxiv.org/abs/1804.08355

ICIG2017(oral)

## The framework for fusion method
<b>Framework</b>
![](https://github.com/hli1221/imagefusion_dllrr/blob/master/framework/framework_dllrr.png)

<b>Dictionary learning</b>
![](https://github.com/hli1221/imagefusion_dllrr/blob/master/framework/dictionary_learning.png)

<b>Reconstructure</b>
![](https://github.com/hli1221/imagefusion_dllrr/blob/master/framework/reconstructure.png)

## Figures and data
1 made_images and made_images_new are the source images which contain different focus region.

2 image_vector and image_vector_new are the image patches matrices and each column is an imape patch which divided by sliding window technique.

3 dictionary and dictionary_new are the su-dictionaries from image_vector and image_vector_new.


## Source code
1 Hog.m---extract the HOG features of image patch.

2 The code of LRR

	solve_lrr.m

	solve_l1l2.m

	inexact_alm_lrr_l1l2.m, inexact_alm_lrr_l1.m

	exact_alm_lrr_l1l2.m, exact_alm_lrr_l1.m
	

3 getClassLabel.m ---- set class label for each patch.

4 fusion_dllrr.m ---- main file.

5 The tool boxes of [KSVD and OMP](https://github.com/hli1221/imagefusion_dllrr/tree/master/KSVD_OMP)

## LRR parts
The LRR method is proposed by Guangcan Liu in 2010.

"Liu G, Lin Z, Yu Y. Robust Subspace Segmentation by Low-Rank Representation[C]// International Conference on Machine Learning. DBLP, 2010:663-670."

And we just use this method in our paper without change.


# Citation
```
@misc{li2017imagefusion_dllrr,
    author = {Hui Li},
    title = {CODE: Multi-focus Image Fusion using dictionary learning and Low-Rank Representation},
    year = {2017},
    publisher = {GitHub},
    journal = {GitHub repository},
    howpublished = {\url{https://github.com/hli1221/imagefusion_dllrr}}
  }
```
Li H, Wu X J. Multi-focus Image Fusion Using Dictionary Learning and Low-Rank Representation[C]//International Conference on Image and Graphics. Springer, Cham, 2017: 675-686.

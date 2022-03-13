# Focus-Stacking
This program was realized for a universitary project at Sorbonnes Université. It mainly is inspired from : A Multi-focus Image Fusion Method Based on Laplacian Pyramid, Chang and Wang. 
# Method
Using the focal stack, we generate maps representing globally the focused pixels by computing the gaussian gradient and the wieght-map, doing a threshold on the weight-map (to have a binary map) and dilating this threshold. Then we compute the laplacian pyramid of each image and the gaussian pyramid of the maps which are multiply to the corresponding laplacian pyramid. In this way, we do a pre-selection of the focused pixels. Finally, we apply the Wang and Chang fusion criteria for the pyramid and we get a focused image.

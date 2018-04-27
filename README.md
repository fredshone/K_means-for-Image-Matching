# K_means-for-Image-Matching
Implementation of Image Matching in Processing 3 using K-Means. There are two outputs:
1. Input test images are ranked by similarity to a given target image
2. Input test images are grouped into matches and non matches
## Versions
1. **satelite_images** first implementation used for distinguishing between urban and non-urban satelite images
Solarized dark             |  Solarized Ocean
:-------------------------:|:-------------------------:
![](https://github.com/fredshone/K_means-for-Image-Matching/blob/master/satellite_images/data/LDN.jpg "Target Image")  |  ![](https://github.com/fredshone/K_means-for-Image-Matching/blob/master/satellite_images/data/LDN.jpg "Target Image")

I also tried it out (without retuning) on:

2. **picasso_images**
3. **google_images**
## So What?
A number of methods are implemented from scratch:
1. **Pixel Matching** - looks for matching pixel attributes - easy
2. **Histogram Matching** - looks for matching distribution of pixel attributes - useful
3. **Object Counting** - identifies and counts image objects - dodgy
4. **K-Means Clustering** - groups images into matches and non matches

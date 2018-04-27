# K_means-for-Image-Matching
Implementation of Image Matching in Processing 3 using K-Means. There are two outputs:
1. Input test images are ranked by similarity to a given target image
2. Input test images are grouped into matches and non matches
### So What?
A number of methods are implemented from scratch:
1. **Pixel Matching** - looks for matching pixel attributes - easy
2. **Histogram Matching** - looks for matching distribution of pixel attributes - useful
3. **Object Counting** - identifies and counts image objects - dodgy
4. **K-Means Clustering** - groups images into matches and non matches
### satelite_images
First implementation used for distinguishing between urban and non-urban satelite images

Target Image             |  Best Match  | Worst Match
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/fredshone/K_means-for-Image-Matching/blob/master/satellite_images/data/LDN.jpg "Target Image")  |  ![](https://github.com/fredshone/K_means-for-Image-Matching/blob/master/satellite_images/data/Image_3.jpg "Test Image") | ![](https://github.com/fredshone/K_means-for-Image-Matching/blob/master/satellite_images/data/Image_5.jpg "Test Image")

Works pretty well, although the effectiveness of the `object_methods` are questionable.
### van_gogh_images
Just for fun (without retuning any parametres) I implemented the above on some Vincent Van Goghs. Note that the images are loaded from URLs grabbed from [Kaggle](https://www.kaggle.com/gfolego/vangogh).
**Warning** - the images are huge so either limit the test or allow Processing to use more bytes in `Preferences`.

Target Image             |  Best Match  | Worst Match
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/fredshone/K_means-for-Image-Matching/blob/master/picasso_images/data/target.jpg" height="300" width="400">  |  <img src="http://upload.wikimedia.org/wikipedia/commons/7/75/Vincent_Willem_van_Gogh_044.jpg" height="300" width="400"> | <img src="http://upload.wikimedia.org/wikipedia/commons/8/8e/William_Ewart_Gladstone_by_Prince_Pierre_Troubetskoy.jpg" height="300" width="400">

### google_images
Also just for fun (again without retuning any parametres) I implemented on some smaller images grabbed from google:

Target Image             |  Best Match  | Worst Match
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/fredshone/K_means-for-Image-Matching/blob/master/google_images/data/target.jpg" height="1000" width="1000">  |  <img src="https://github.com/fredshone/K_means-for-Image-Matching/blob/master/google_images/data/Image_19.jpg" height="1000" width="1000"> | <img src="https://github.com/fredshone/K_means-for-Image-Matching/blob/master/google_images/data/Image_42.jpg" height="1000" width="1000">

//Histogram comparison methods

////////////////////////////////////////////////////////

// function to return individual image score

float[] calc_HSB_scores (int[][][] _test_histograms, int[][] _target_histogram) {

  // create array of histogram differences
  int[][][] hist_diff = new int[_test_histograms.length][_target_histogram.length][_target_histogram[0].length];
  float[][][] HSB_bin_scores = new float[_test_histograms.length][_target_histogram.length][_target_histogram[0].length];
  float[][] HSB_hist_scores = new float[_test_histograms.length][_target_histogram.length];

  // create array of total hist diff
  float[] image_scores = new float[_test_histograms.length];

  //loop through test images comparing to target
  for (int i = 0; i < _test_histograms.length; i++) {

    //loop through HSB
    for (int j = 0; j < _target_histogram.length; j ++) {   

      //loop through bins
      for (int k = 0; k < _target_histogram[0].length; k ++) {

        //find image bin differences
        hist_diff[i][j][k] = abs(_target_histogram[j][k] - _test_histograms[i][j][k]);
      }
    }
  }

  //loop through differences summing for each image channel
  for (int i = 0; i < _test_histograms.length; i++) {
    //loop through HSB
    for (int j = 0; j < _target_histogram.length; j ++) {
      //loop through bins
      for (int k = 0; k < _target_histogram[0].length; k ++) {
        //cartesian
        HSB_bin_scores[i][0][k] = (abs(hist_diff[i][0][k]) + abs(hist_diff[i][1][k]) + abs(hist_diff[i][2][k]));
        //euclidean
        //HSB_bin_scores[i][1][k] = sqrt(sq(hist_diff[i][0][k]) + sq(hist_diff[i][1][k]) + sq(hist_diff[i][2][k]));
        //cosine
       //HSB_bin_scores[i][2][k] = abs(((_test_histograms[i][0][k]*_target_histogram[0][k]) + 
       //(_test_histograms[i][1][k]*_target_histogram[1][k]) + 
       //(_test_histograms[i][2][k]*_target_histogram[2][k])) / 
       //(sqrt(sq(_test_histograms[i][0][k]) + 
       //sq(_test_histograms[i][1][k]) + 
       //sq(_test_histograms[i][2][k])) * 
       //sqrt(sq(_target_histogram[0][k]) + 
       //sq(_target_histogram[1][k]) + 
       //sq(_target_histogram[2][k]))));  
       
       HSB_hist_scores[i][j] = HSB_hist_scores[i][j] + HSB_bin_scores[i][j][k];
      }
    }

    image_scores[i] = HSB_hist_scores[i][0];
  }

  return image_scores;
}

//////////////////////////////////////////////////////

// function to return individual image score

PVector[] compare_histograms (int[][][] _test_histograms, int[][] _target_histogram) {

  // create array of histogram differences
  int[][][] hist_diff = new int[_test_histograms.length][_target_histogram.length][_target_histogram[0].length];
  int[][] sum_hist_diff = new int[_test_histograms.length][_target_histogram.length];

  // create array of total hist diff
  PVector[] image_score = new PVector[_test_histograms.length];

  //loop through test images comparing to target
  for (int i = 0; i < _test_histograms.length; i++) {

    //loop through HSB
    for (int j = 0; j < _target_histogram.length; j ++) {   
      
      //loop through bins
      for (int k = 0; k < _target_histogram[0].length; k ++) {

        //find image bin differences
        hist_diff[i][j][k] = abs(_target_histogram[j][k] - _test_histograms[i][j][k]);
      }
    }
  }

  //loop through differences summing for each image channel
  for (int i = 0; i < _test_histograms.length; i++) {
    //loop through HSB
    for (int j = 0; j < _target_histogram.length; j ++) {
      //loop through bins
      for (int k = 0; k < _target_histogram[0].length; k ++) {
      sum_hist_diff[i][j] = sum_hist_diff[i][j] + hist_diff[i][j][k];
      }
    }
    image_score[i] = new PVector(sum_hist_diff[i][0], sum_hist_diff[i][1], sum_hist_diff[i][2]);
  }

  return image_score;
}

//////////////////////////////////////////////////////

//function to return IMAGE Histogram for all images

int[][][] extract_all_hist (PImage[] _input, int _bins) {

  int[][][] all_hist = new int[_input.length][3][_bins];

  for (int i = 0; i < _input.length; i++) { 
        print(">");
        
    all_hist[i] = extract_image_hist(_input[i], _bins);
  }

  return all_hist;
}

//////////////////////////////////////////////////////

//function to return IMAGE Histogram for HSB

int[][] extract_image_hist (PImage _input, int _bins) {

  PVector[] pixel_attributes = new PVector[_input.pixels.length];
  int[][] hist_output = new int[3][_bins];

  //extract all image pixel HSB as PVector
  for (int i = 0; i < _input.pixels.length; i++) {
    pixel_attributes[i] = extract_pixel_HSB (_input, i);
  }

  //find maximums and minimums to allow binning
  //initialise min max vectors with first input values
  PVector min = new PVector(pixel_attributes[0].x, pixel_attributes[0].y, pixel_attributes[0].z);
  PVector max = new PVector(pixel_attributes[0].x, pixel_attributes[0].y, pixel_attributes[0].z);

  //loop through finding individual max mins
  //omitt first PVector
  for (int i = 1; i < pixel_attributes.length; i ++) {

    if (pixel_attributes[i].x < min.x) min.x = pixel_attributes[i].x;
    if (pixel_attributes[i].y < min.y) min.y = pixel_attributes[i].y;
    if (pixel_attributes[i].z < min.z) min.z = pixel_attributes[i].z;

    if (pixel_attributes[i].x > max.x) max.x = pixel_attributes[i].x;
    if (pixel_attributes[i].y > max.y) max.y = pixel_attributes[i].y;
    if (pixel_attributes[i].z > max.z) max.z = pixel_attributes[i].z;
  }

  //println("hist min maxes:");
  //println(min);
  //println(max);

  //calc bin size
  PVector bin_size = new PVector();
  bin_size = max.sub(min).div(_bins);

  //println("hist bin sizes:");
  //println(bin_size);

  //create bin limits
  PVector[] limits = new PVector[_bins + 1];
  for (int i = 0; i < _bins; i++) {
    limits[i] = new PVector(min.x + (i*bin_size.x), min.y + (i*bin_size.y), min.z + (i*bin_size.z));
  }

  //loop through all pixel values, binning 

  for (int i = 0; i < pixel_attributes.length; i ++) {

    // H values
    float H = pixel_attributes[i].x; 
    for (int bin = 0; bin < _bins - 1; bin ++) {
      if ((H >= limits[bin].x) & (H < limits[bin+1].x)) hist_output[0][bin] ++;
    }

    // S values
    float S = pixel_attributes[i].y; 
    for (int bin = 0; bin < _bins - 1; bin ++) {
      if ((S >= limits[bin].y) & (S < limits[bin+1].y)) hist_output[1][bin] ++;
    }

    // B values
    float B = pixel_attributes[i].z; 
    for (int bin = 0; bin < _bins - 1; bin ++) {
      if ((B >= limits[bin].z) & (B < limits[bin+1].z)) hist_output[2][bin] ++;
    }
  }

  //loop through hist outputs summing for check
  PVector check = new PVector(0, 0, 0);
  for (int i = 0; i < _bins - 1; i ++) {
    PVector out = new PVector(hist_output[0][i], hist_output[1][i], hist_output[2][i]);
    check.add(out);
  }

  //println("pixel count:");
  //println(_input.pixels.length);
  //println("pixels accounted for:");
  //println(check);
  //println("H value hist:");
  //println(hist_output[0]);
  //println("S value hist:");
  //println(hist_output[1]);
  //println("B value hist:");
  //println(hist_output[2]);

  return hist_output;
}

//////////////////////////////////////////////////////

//function to return PIXEL PVector for HSB

PVector extract_pixel_HSB (PImage _input, int _i) {

  PVector output = new PVector();

  output.x = hue(_input.pixels[_i]);
  output.y = saturation(_input.pixels[_i]);
  output.z = brightness(_input.pixels[_i]);

  return output;
}

//////////////////////////////////////////////////////

// function to normalise arrays of PVectors

// norm for array of histograms

int[][][] normalize_scores (int[][][] _input) {
  int[][][] output = _input;
  for (int i = 0; i < _input.length; i++) {
    output[i] = normalize_scores (_input[i]);
  }
  return output;
}

// norm for histogram

int[][] normalize_scores (int[][] _input) {

  //initialise min max vectors with first input values
  PVector min = new PVector(_input[0][0], _input[1][0], _input[2][0]);
  PVector max = new PVector(_input[0][0], _input[1][0], _input[2][0]);

  //loop through finding individual max mins
  for (int i = 1; i < _input[0].length; i ++) {

    if (_input[0][i] < min.x) min.x = _input[0][i];
    if (_input[1][i] < min.y) min.y = _input[1][i];
    if (_input[2][i] < min.z) min.z = _input[2][i];

    if (_input[0][i] > max.x) max.x = _input[0][i];
    if (_input[1][i] > max.y) max.y = _input[1][i];
    if (_input[2][i] > max.z) max.z = _input[2][i];
  }

  //println("norm histogram min maxes:");
  //println(min);
  //println(max);

  //calc range vector
  PVector minmax_range = new PVector();
  minmax_range = max.sub(min);
  
  if (minmax_range.x == 0) minmax_range.x = 1;
  if (minmax_range.y == 0) minmax_range.y = 1;
  if (minmax_range.z == 0) minmax_range.z = 1;

  //loop through normalising with max min
  for (int i = 0; i < _input[0].length; i++) {

    _input[0][i] = (_input[0][i] - int(min.x)) * 100 / int(minmax_range.x);
    _input[1][i] = (_input[1][i] - int(min.y)) * 100 / int(minmax_range.y);
    _input[2][i] = (_input[2][i] - int(min.z)) * 100 / int(minmax_range.z);
  }


  return _input;
}

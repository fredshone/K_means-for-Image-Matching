//////////////////////////////////////////////////////

//function to return IMAGE PVectors for HSB

PVector[] extract_image_HSB (PImage _input) {

  PVector[] output = new PVector[_input.pixels.length];

  //_input.loadPixels();

  for (int i = 0; i < _input.pixels.length; i++) {

    output[i] = extract_pixel_HSB (_input, i);
  }

  return output;
}

//////////////////////////////////////////////////////

// function to loop through all test images, returning array of scores

float[] get_image_HSB_scores (PImage[] pin, PVector[] _targetHSB) {

  float[] image_scores = new float[pin.length];

  for (int i = 0; i < test_images; i ++) {  
        print(">");
    //calc scores
    image_scores[i] = compare_image_HSB(pin[i], _targetHSB);
  }

  return image_scores;
}

//////////////////////////////////////////////////////

// function to return individual image score

float compare_image_HSB (PImage pin, PVector[] _targetHSB) {

  //vector array of pixel differences
  PVector[] pixel_diff = new PVector[pin.pixels.length];
  PVector[] pixel_diff_scores = new PVector[pin.pixels.length];

  //vector of sum differences bt attribute
  float image_score = 0;

  // find test image HSB array
  PVector[] testHSB = extract_image_HSB(pin);

  //loop through test image HSB array comparing to target
  for (int i = 0; i < testHSB.length; i++) {

    pixel_diff[i] = PVector.sub(testHSB[i], _targetHSB[i]);
    pixel_diff_scores[i] = new PVector(0,0,0);

    //force vector of differences to absolutes
    //manhattan 
    pixel_diff_scores[i].x = (abs(pixel_diff[i].x) + abs(pixel_diff[i].y) + abs(pixel_diff[i].z));
    ////euclidean
    //pixel_diff_scores[i].y = sqrt(sq(pixel_diff[i].x) + sq(pixel_diff[i].y) + sq(pixel_diff[i].z));
    ////cosine
    //pixel_diff_scores[i].z = testHSB[i].dot(_targetHSB[i]) / (testHSB[i].mag() + _targetHSB[i].mag());
    
  }

  //sum absolute differences
  for (int i = 0; i < pixel_diff.length; i++) {
    image_score = image_score + (pixel_diff_scores[i].x);
  }
  
  image_score = image_score / testHSB.length;

  return image_score;
}

//////////////////////////////////////////////////////

// function to return individual image score

PVector[] compare_images_multi (PVector[] pixel_diff) {

  PVector[] pixel_diff_scores = new PVector[pixel_diff.length];

  for (int i = 0; i < pixel_diff.length; i++) {

    //force vector of differences to absolutes
    pixel_diff_scores[i] = new PVector(abs(pixel_diff[i].x) + abs(pixel_diff[i].y) + abs(pixel_diff[i].z), //manhattan 
      sqrt(sq(pixel_diff[i].x) + sq(pixel_diff[i].y) + sq(pixel_diff[i].z)), //euclidean
      1);
  }

  return pixel_diff_scores;
}
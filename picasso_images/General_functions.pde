//resize function for single image

PImage resize_to_target (PImage pin, PImage _target) {

  int test_width = _target.width;
  int test_height = _target.height;

  PImage output = pin;
  output.resize(test_width, test_height);

  return output;
}

//resize function for array of images

PImage[] resize_to_target (PImage[] pin, PImage _target) {

  int test_width = _target.width;
  int test_height = _target.height;

  int array_size = pin.length;

  PImage[] output = new PImage[array_size];

  for (int i = 0; i < test_images; i ++) {
    output[i] = pin[i];
    output[i].resize(test_width, test_height);
  }

  return output;
}

//////////////////////////////////////////////////////


// function to draw Bar chart

void draw_bar_chart (float[] _input) {
  
  for (int i = 0; i < _input.length; i++) {
    stroke(255);
    line(5, i, (_input[i]*40) + 5, i);
  }
  
}

//////////////////////////////////////////////////////

// function to draw Histogram

void draw_histogram (int[] _input) {
  stroke(255);
  line(0,0,100,0);
  fill(255,100);
  for (int i = 0; i < _input.length; i++) {
    rect(i*5, 0, 5, -_input[i]/2);
  }
  fill(255,255);
}

//////////////////////////////////////////////////////

// function to print arrays of PVectors

void print_results (PVector[] _input) {
  for (int i = 0; i < _input.length; i ++) {
    println(_input[i]);
  }
}

// function to print arrays

void print_results (int[] _input) {
  for (int i = 0; i < _input.length; i ++) {
    println(_input[i]);
  }
}

//////////////////////////////////////////////////////
//function to return ranked array of ids

//x

int[] rank_indexes_x (PVector[] _input) {

  int[] ranks = new int[_input.length];

  for (int i = 0; i < _input.length; i++) {
    ranks[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (_input[j].x < _input[i].x) ranks[i] ++;
    }
    //deal with duplicates
    for (int j = 0; j < i; j++) {
      if (_input[j].x == _input[i].x) ranks[i] ++;
    }
  }
  
  //println("ranks:");
  //print_results(ranks);
  
  int[] index = new int[_input.length];
  
  for (int i = 0; i < _input.length; i++) {
    index[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (ranks[j] == i) index[i] = j;
    }
  }
  
  //println("ranked indexes:");
  //print_results(index);
  
  return index;
}

//y

int[] rank_indexes_y (PVector[] _input) {

  int[] ranks = new int[_input.length];

  for (int i = 0; i < _input.length; i++) {
    ranks[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (_input[j].y < _input[i].y) ranks[i] ++;
    }
    //deal with duplicates
    for (int j = 0; j < i; j++) {
      if (_input[j].y == _input[i].y) ranks[i] ++;
    }
  }
  
  int[] index = new int[_input.length];
  
  for (int i = 0; i < _input.length; i++) {
    index[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (ranks[j] == i) index[i] = j;
    }
  }
  
  return index;
}

//z

int[] rank_indexes_z (PVector[] _input) {

  int[] ranks = new int[_input.length];

  for (int i = 0; i < _input.length; i++) {
    ranks[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (_input[j].z < _input[i].z) ranks[i] ++;
    }
        //deal with duplicates
    for (int j = 0; j < i; j++) {
      if (_input[j].z == _input[i].z) ranks[i] ++;
    }
  }
  
  int[] index = new int[_input.length];
  
  for (int i = 0; i < _input.length; i++) {
    index[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (ranks[j] == i) {
        index[i] = j;
      }
    }
  }
  
  return index;
}

int[] rank_indexes (float[] _input) {

  int[] ranks = new int[_input.length];

  for (int i = 0; i < _input.length; i++) {
    ranks[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (_input[j] < _input[i]) ranks[i] ++;
    }
        //deal with duplicates
    for (int j = 0; j < i; j++) {
      if (_input[j] == _input[i]) ranks[i] ++;
    }
  }
  
  int[] index = new int[_input.length];
  
  for (int i = 0; i < _input.length; i++) {
    index[i] = 0;
    for (int j = 0; j < _input.length; j++) {
      if (ranks[j] == i) {
        index[i] = j;
      }
    }
  }
  
  return index;
}
//method to assign object ids

int[] get_object_ids(PImage pin) {

  //create boolean array of edges
  boolean[] out = new boolean[pin.pixels.length];

  //create empty id array
  int[] ids = new int[out.length];

  for (int i = 0; i < out.length; i++) {
    out[i] = false;
    ids[i] = 0;
  }

  //loop through interior settig uop edge boolean
  for (int i = 1; i < pin.width - 1; i++) { //x
    for (int j = 1; j < pin.height - 1; j++) { //y

      int pix = i + (j * pin.width);
      if (brightness(pin.pixels[pix]) > 200) out[pix] = true;
    }
  }

  int id_counter = 1;

  // ignore pixel border
  for (int i = 1; i < pin.width - 1; i++) { //x
    for (int j = 1; j < pin.height - 1; j++) { //y

      int pix = i + (j * pin.width);

      boolean self = out[pix];

      if (self) {

        boolean Bleft = out[pix - 1];
        boolean Babove_left = out[pix - pin.width - 1];
        boolean Babove = out[pix - pin.width];
        boolean Babove_right = out[pix - pin.width + 1];
        boolean Bright = out[pix + 1];
        boolean Bbelow_right = out[pix + pin.width + 1];
        boolean Bbelow = out[pix + pin.width];
        boolean Bbelow_left = out[pix + pin.width - 1];

        int left = ids[pix - 1];
        int above_left = ids[pix - pin.width - 1];
        int above = ids[pix - pin.width];
        int above_right = ids[pix - pin.width + 1];
        int right = ids[pix + 1];
        int below_right = ids[pix + pin.width + 1];
        int below = ids[pix + pin.width];
        int below_left = ids[pix + pin.width - 1];

        //array of neighbour ids
        int[] neighbours = {above_left, above, above_right, right, below_right, below, below_left, left};

        //array of neighbour booleans
        boolean[] Bneighbours = {Babove_left, Babove, Babove_right, Bright, Bbelow_right, Bbelow, Bbelow_left, Bleft};

        // extract a neighbour id
        boolean id_available = false;
        int neighbour_id = 0;

        for (int k = 0; k < 8; k++) {
          if (neighbours[k] > 0) {
            neighbour_id = neighbours[k];
            id_available = true;
          }
        }

        //if any neighbours are true
        if (Bneighbours[0]|Bneighbours[1]|Bneighbours[2]|Bneighbours[3]|Bneighbours[4]|Bneighbours[5]|Bneighbours[6]|Bneighbours[7]) {

          //and if any id available use this
          if (id_available) {
            ids[pix] = neighbour_id;
            //set id of adjacent pixels
            if (Bleft) ids[pix - 1] = ids[pix];
            if (Babove_left) ids[pix - pin.width - 1] = ids[pix];
            if (Babove) ids[pix - pin.width] = ids[pix];
            if (Babove_right) ids[pix - pin.width + 1] = ids[pix];
            if (Bright) ids[pix + 1] = ids[pix];
            if (Bbelow_right) ids[pix + pin.width + 1] = ids[pix];
            if (Bbelow) ids[pix + pin.width] = ids[pix];
            if (Bbelow_left) ids[pix + pin.width - 1] = ids[pix];
          } else {
            //set new ID
            ids[pix] = id_counter;

            //set id of adjacent pixels
            if (Bleft) ids[pix - 1] = ids[pix];
            if (Babove_left) ids[pix - pin.width - 1] = ids[pix];
            if (Babove) ids[pix - pin.width] = ids[pix];
            if (Babove_right) ids[pix - pin.width + 1] = ids[pix];
            if (Bright) ids[pix + 1] = ids[pix];
            if (Bbelow_right) ids[pix + pin.width + 1] = ids[pix];
            if (Bbelow) ids[pix + pin.width] = ids[pix];
            if (Bbelow_left) ids[pix + pin.width - 1] = ids[pix];

            id_counter++;
          }
        } else {

          //if no true neighbours then set to false (ignore single pixels)
          out[pix] = false;
        }
      }
    }
  }

  return ids;
}

int count_objects (int[] array) {

  int max = 0;
  //loop through array, finding max
  for (int i = 0; i < array.length; i++) {
    if (array[i] > max) max = array[i];
  }
  return max;
}

int[] get_object_sizes (int number, int[] object_ids) {

  int[] sizes = new int[number];

  //set to 0
  for (int i = 0; i < sizes.length; i++) sizes[i] = 0;

  //loop through object_ids counting
  for (int i = 0; i < sizes.length; i++) {
    for (int j = 0; j < object_ids.length; j++) {
      if (object_ids[j] == i+1) {
        sizes[i] ++;
      }
    }
  }
  return sizes;
}

int find_max (int[] _sizes) {
  int max = 0;
  for (int i = 0; i < _sizes.length; i++) {
    if (_sizes[i] > max) max = _sizes[i];
  }
  return max;
}

int find_max_id (int[] _sizes) {
  int max = 0;
  int id = 0;
  for (int i = 0; i < _sizes.length; i++) {
    if (_sizes[i] > max) {
      max = _sizes[i];
      id = i+1;
    }
  }
  return id;
}

PImage create_object_image (PImage _in, int[] _ids, int[] _sizes) {

  PImage _out = createImage(_in.width, _in.height, HSB);

  for (int i = 0; i < _sizes.length; i++) {

    _out = get_object_image (_out, _ids, i+1);
  }

  return _out;
}

PImage get_object_image (PImage __in, int[] _ids, int _id) {

  color col = color(int(random(1)*255), 100, 100);

  __in.loadPixels();

  for (int j = 0; j < __in.pixels.length; j++) {
    if (_ids[j] == _id) __in.pixels[j] = col;
  }

  __in.updatePixels();

  return __in;
}

//find average size
float get_average_size(int[] target_object_sizes) {

  int total = 0;
  for (int i = 0; i < target_object_sizes.length; i++) {
    total = total + target_object_sizes[i];
  }
  return (total/target_object_sizes.length);
}

//find median size
int get_median_size(int[] target_object_sizes) {

  return target_object_sizes[int(target_object_sizes.length/2)];
}

//function to compare image scores

PVector[] compare_scores (PVector[] pin, PVector _target) {

  PVector[] out = new PVector[pin.length];

  for (int i = 0; i < pin.length; i++) {

    out[i] = new PVector (abs(pin[i].x - _target.x), abs(pin[i].y - _target.y), abs(pin[i].z - _target.z));
  }
  return out;
}

// function to normalise arrays of PVectors

PVector[] normalize_scores (PVector[] _input) {

  //initialise min max vectors with first input values
  PVector min = new PVector(_input[0].x, _input[0].y, _input[0].z);
  PVector max = new PVector(_input[0].x, _input[0].y, _input[0].z);

  //loop through finding individual max mins
  //omitt first PVector
  for (int i = 1; i < _input.length; i ++) {

    if (_input[i].x < min.x) min.x = _input[i].x;
    if (_input[i].y < min.y) min.y = _input[i].y;
    if (_input[i].z < min.z) min.z = _input[i].z;

    if (_input[i].x > max.x) max.x = _input[i].x;
    if (_input[i].y > max.y) max.y = _input[i].y;
    if (_input[i].z > max.z) max.z = _input[i].z;
  }

  //calc range vector
  PVector minmax_range = new PVector();
  minmax_range = max.sub(min);

  //loop through normalising with max min
  for (int i = 0; i < _input.length; i ++) {
    _input[i] = _input[i].sub(min);
    _input[i].x = _input[i].x / minmax_range.x;
    _input[i].y = _input[i].y / minmax_range.y;
    _input[i].z = _input[i].z / minmax_range.z;
  }

  return _input;
}
//A50 Image Comparisson
//08/01/18
//BENVGACH
//CN: WRKM8
//SN: 17141684

// COMBINED METHODS - the following code is assembled from 
// the best 3 perforing methodologies:
//   Direct Pixel Comparison (Cartesian Combined HSB Pixel Attributes)
//   Histogram Comparison (Cartesian Combined HSB Bin Attributes)
//   Object count

// For a detailed exporation of the individual methodologies please
// refer to the other submitted code

/////////////////////////////////////////
// SET UP GLOBAL VARIABLES
/////////////////////////////////////////

int test_images = 10; // input number of test images
int var = 10; // number of result images to return

//bins
int bins = 20;

//variable for selecting images
int choose = 0;
int index;

//target image
PImage _target;
PImage target;
PImage target_thumb;

//test images array
Table URLtable;
String[] URLs;
PImage[] _test = new PImage[test_images];
PImage[] test = new PImage[test_images];
PImage[] test_processed = new PImage[test_images];


/////////////////////////////////////////
//HSB VARIABLES

int[] ranked_HSB = new int[test_images];

int[]indexHSB_cart = new int[var];
PImage[] image_rank_HSB_cart = new PImage[var];
float[] score_rank_HSB_cart = new float[var];
float[] norm_score_rank_HSB_cart = new float[var];

/////////////////////////////////////////
//HIST VARIABLES

int[] ranked_hist = new int[test_images];

int[]indexHIST_cart = new int[var];
PImage[] image_rank_HIST_cart = new PImage[var];
float[] score_rank_HIST_cart = new float[var];
float[] norm_score_rank_HIST_cart = new float[var];

int[][][] norm_test_histograms = new int[test_images][3][bins];

/////////////////////////////////////////
//OBJECT VARIABLES

int[][] test_object_ids;
int[] test_objects;
int[][] test_object_sizes;
PVector[] test_summary;
PImage[] test_out;
float[] object_scores;

int[] ranked_object = new int[test_images];

/////////////////////////////////////////
//COMBINED VARIABLES
PVector[] method_scores = new PVector[test_images];
PVector[] norm_method_scores = new PVector[test_images];
float[] combined_scores = new float[test_images];

//ranked images and scores using object count
int[] ranked = new int[test_images];
PVector[] scores_ranked = new PVector[test_images];
float[] combined_score_ranked = new float[var];
PImage[] image_rank = new PImage[var];

/////////////////////////////////////////
//K MEANS VARIABLES

PVector[] centroids = new PVector[2];
boolean[] clusters = new boolean[test_images];
int steps = 50;

//PImage[] cluster_true;
//PImage[] cluster_false;

int[] id_true;
int[] id_false;

/////////////////////////////////////////

//scale for fixing aspect ratio of target image (%)
int scale;
int sizeA;
int sizeB;
int sizeVA;
int sizeVB;

/////////////////////////////////////////

void setup() {
  colorMode(HSB);
  size(1000, 800);

  background(0);

  //set up scale
  sizeA = width/2;
  sizeB = width/12;

  /////////////////////////////////////////
  //load target image

  _target = loadImage("target.jpg");
  _target.resize(300,200);

  target = _target;

  /////////////////////////////////////////
  //load test images
  
  URLtable = loadTable("vgdb_2016-1.csv", "header");

  println(URLtable.getRowCount() + " total URLs in table");
  URLs = new String[URLtable.getRowCount()];

  int index = 0;
  for (TableRow row : URLtable.rows()) {
    URLs[index] = row.getString("ImageURL");
    index ++;  
    println(row.getString("ImageURL"));
  }
  
  for (int i = 0; i < test_images; i ++) {
    println("Loading " + URLs[i]);
    String file = URLs[i];
    PImage temp = loadImage(file);
    temp.resize(300,200);
    _test[i] = temp;
  }
  test = _test;

  ///////////////////////////////////////////////////
  //VECTOR METHOD
  ///////////////////////////////////////////////////
  println();
  println("Vector Method Starting");

  //TARGET

  println();
  println("Processing target image");

  //find HSB array for target
  PVector[] targetHSB = extract_image_HSB (target);

  ///////////////////////////////////////////////////
  //TEST

  println();
  println("Processing test images");

  //resize test images to match target
  PImage[] test_resized = resize_to_target (test, target);

  //loop through test images, comparing to target PVector, output arrays of scores
  float[] HSB_scores = get_image_HSB_scores (test_resized, targetHSB);

  int vec_time = millis()/1000;
  println();
  println("Vector method calculations completed in " + str(vec_time) + " seconds.");

  ///////////////////////////////////////////////////
  //HIST METHOD
  ///////////////////////////////////////////////////

  println();
  println("Histogram Method Starting");

  //TARGET

  println();
  println("Processing target image");


  //find HSB array for target
  int[][] target_histogram = extract_image_hist (target, bins);
  int[][] norm_target_histogram = normalize_scores (target_histogram);

  ///////////////////////////////////////////////////
  //TEST

  println();
  println("Processing test images");

  //loop through test images, output array of histograms
  int[][][] test_histograms = extract_all_hist(test, bins);
  norm_test_histograms = normalize_scores (test_histograms);

  //loop through histogram scores calculating combined channel results
  float[] hist_scores = calc_HSB_scores(norm_test_histograms, norm_target_histogram);

  int hist_time = (millis()/1000) - vec_time;
  println();
  println("Histogram method calculations completed in " + str(hist_time) + " seconds.");

  ///////////////////////////////////////////////////
  //OBJECT METHOD
  ///////////////////////////////////////////////////
  println();
  println("Object Method Starting");

  /////////////////////////////////////////
  //TARGET

  println();
  println("Processing target image");

  //process target image
  target = get_brightness_edges(_target);
  target = get_split(target);
  target = smoother(target);
  target = get_split(target);
  //target = smoother(target);
  //target = get_split(target);

  //find target objects
  int[] target_object_ids = get_object_ids(target);

  //count target objects
  int target_objects = count_objects(target_object_ids);

  //find object sizes
  int[] target_object_sizes = get_object_sizes(target_objects, target_object_ids);

  //create objects image
  PImage target_out = create_object_image (get_brightness(target), target_object_ids, target_object_sizes);

  ///////////////////////////////////////////////////
  //TEST

  println();
  println("Processing test images");

  //object arrays for test images

  test_object_ids = new int[test_images][];
  test_objects = new int[test_images];
  test_object_sizes = new int[test_images][];
  test_summary = new PVector[test_images];
  test_out = new PImage[test_images];
  object_scores = new float[test_images];


  for (int i = 0; i < _test.length; i++) {

    //convert target image
    test_processed[i] = new PImage();
    test_processed[i] = get_brightness_edges(test[i]);
    test_processed[i] = get_split(test_processed[i]);
    test_processed[i] = smoother(test_processed[i]);
    test_processed[i] = get_split(test_processed[i]);
    //test_processed[i] = smoother(test_processed[i]);
    //test_processed[i] = get_split(test_processed[i]);

    //find target objects
    test_object_ids[i] = get_object_ids(test_processed[i]);

    //count target objects
    test_objects[i] = count_objects(test_object_ids[i]);

    //find object sizes
    test_object_sizes[i] = get_object_sizes(test_objects[i], test_object_ids[i]);

    //create objects images
    test_out[i] = new PImage();
    test_out[i] = create_object_image (get_brightness(test[i]), test_object_ids[i], test_object_sizes[i]);

    //calc object scores
    object_scores[i] = abs(test_objects[i] - target_objects);

    print(">");
  }

  int obj_time = (millis()/1000) - vec_time - hist_time;
  println();
  println("Object method calculations completed in " + str(obj_time) + " seconds.");

  ///////////////////////////////////////////////////
  //COMBINE SCORES
  ///////////////////////////////////////////////////

  println();
  println("Combining Methods and ranking images:");

  //combine method scores into PVector
  for (int i = 0; i < test.length; i++) {
    method_scores[i] = new PVector(HSB_scores[i], hist_scores[i], object_scores[i]);
  }

  //Normalise
  norm_method_scores = normalize_scores (method_scores);

  //Combine scores
  for (int i = 0; i < test.length; i++) {
    combined_scores[i] = HSB_scores[i] + hist_scores[i] + object_scores[i];
  }

  ///////////////////////////////////////////////////
  //RANK SCORES
  ///////////////////////////////////////////////////

  //rank scores
  ranked = rank_indexes(combined_scores);
  ranked_HSB = rank_indexes_x(norm_method_scores);
  ranked_hist = rank_indexes_x(norm_method_scores);
  ranked_object = rank_indexes_x(norm_method_scores);

  index = ranked[choose];

  //order all images and scores

  PImage[] test_thumb = new PImage[test_images];
  test_thumb = _test;

  for (int i = 0; i < var; i ++) {

    image_rank[i] = test_thumb[ranked[i]];
    scores_ranked[i] = method_scores[ranked[i]];
    combined_score_ranked[i] = combined_scores[ranked[i]];
  }

  int com_time = (millis()/1000) - vec_time - hist_time - obj_time;

  println();
  println("Method combination and ranking completed in " + str(com_time) + " seconds.");

  ///////////////////////////////////////////////////
  //CLUSTERING
  ///////////////////////////////////////////////////

  println();
  println("Clustering");


  centroids[0] = new PVector(0, 0, 0);
  centroids[1] = new PVector(1, 1, 1);

  step();

  //begin loop, limitted to given number of steps

  for (int i = 0; i < steps; i++) {
    step();
    print(">");
  }

  //calculate objects for clusters
  PImage[] cluster_true = extract_image_cluster(test, clusters, true);
  PImage[] cluster_false  = extract_image_cluster(test, clusters, false);
  id_true = extract_id_cluster(clusters, true);
  id_false = extract_id_cluster(clusters, false);

  int clu_time = (millis()/1000) - vec_time - hist_time - obj_time - com_time;

  println();
  println(str(id_true.length) + " matches identified");
  println("Clustering completed in " + str(clu_time) + " seconds.");


  ///////////////////////////////////////////////////
  //DRAWING RESULTS
  ///////////////////////////////////////////////////

  println();
  println("Drawing results");

  ///////////////////////////////////////////////////
  //Target

  // Draw the target to the screen at coordinate (0,0)
  //resize to so width is half canvas width
  target = _target;
  target.resize(width/2 -4, 0);
  image(target, 2, 2);
  sizeVA = target.height;

  fill(0);
  rect(0, 0, 120, 25);
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Target Image:", 1, 1);

  //draw processed images

  pushMatrix();

  translate(0, sizeVA);
  PImage target_hue = get_hue(_target);
  target_hue.resize(width/8 -4, 0);
  image(target_hue, 2, 4);

  translate(width/8, 0);
  PImage target_sat = get_saturation(_target);
  target_sat.resize(width/8 -4, 0);
  image(target_sat, 2, 4);

  translate(width/8, 0);
  PImage target_bri = get_brightness(_target);
  target_bri.resize(width/8 -4, 0);
  image(target_bri, 2, 4);

  translate(width/8, 0);
  target_out.resize((width/8) - 4, 0);
  image(target_out, 2, 4);

  popMatrix();

  //draw labels

  textSize(12);

  pushMatrix();

  translate(0, sizeVA);
  fill(0);
  noStroke();
  rect(5, 7, 110, 18);
  fill(255);
  text("Target Hue:", 7, 7);

  translate(width/8, 0);
  fill(0);
  noStroke();
  rect(5, 7, 110, 18);
  fill(255);
  text("Target Saturation:", 7, 7);

  translate(width/8, 0);
  fill(0);
  noStroke();
  rect(5, 7, 110, 18);
  fill(255);
  text("Target Brightness:", 7, 7);

  translate(width/8, 0);
  fill(0);
  noStroke();
  rect(5, 7, 110, 18);
  fill(255);
  text("Target Objects:", 7, 7);

  popMatrix();

  //draw graphics

  pushMatrix();

  translate(10, sizeVA + sizeVA/4 - 5);
  //draw Hue histogram
  draw_histogram(norm_target_histogram[0]);

  translate(width/8, 0);
  //draw Saturation histogram
  draw_histogram(norm_target_histogram[1]);

  translate(width/8, 0);
  //draw Brightness histogram
  draw_histogram(norm_target_histogram[2]);

  popMatrix();

  /////////////////////////////////////

  //draw match cluster

  PImage[] image1 = new PImage[id_true.length];

  //title
  pushMatrix();
  translate(0, sizeVA + sizeVA/4 + 10);
  textSize(14);
  text("Matched Images Cluster:", width/8, 5);

  println(id_true.length);

  translate(width/32, 30);
  //counter
  for (int i = 0; i < id_true.length; i++) {

    image1[i] = new PImage();
    image1[i] = cluster_true[i].copy();
    image1[i].resize(width/16 - 4, 0);
    image(image1[i], 2, 2);
    fill(0);
    noStroke();
    rect(2, 2, 40, 12);
    fill(255);
    textSize(8);
    text("Image_" + id_true[i], 2, 2);

    translate(width/16, 0);

    if ((i+1) % 7 == 0) translate(- 7 * (width/16), image1[i].height + 4);
  }

  popMatrix();
  
  /////////////////////////////////////

  //draw non-match cluster

  PImage[] image2 = new PImage[id_false.length];

  //title
  pushMatrix();
  translate(width/2, sizeVA + sizeVA/4 + 10);
  textSize(14);
  text("Non-matched Images Cluster:", width/8, 5);

  translate(width/32, 30);
  //counter
  for (int i = 0; i < id_false.length; i++) {

    image2[i] = new PImage();
    image2[i] = cluster_false[i].copy();
    image2[i].resize(width/16 - 4, 0);
    image(image2[i], 2, 2);

    fill(0);
    noStroke();
    rect(2, 2, 40, 12);
    fill(255);
    textSize(8);
    text("Image_" + id_false[i], 2, 2);

    translate(width/16, 0);

    if ((i+1) % 7 == 0) translate(- 7 * (width/16), image2[i].height + 4);
  }

  popMatrix();

  println("> Use cursor keys to cycle through results <");
}

void draw() {

  //Test
  //draw top match
  pushMatrix();

  PImage top_match = image_rank[choose].copy();
  translate(width/2, 0);
  top_match.resize(width/2 - 4, 0);
  image(top_match, 2, 2);

  fill(0);
  noStroke();
  rect(0, 0, 250, 25);
  fill(255);
  textSize(16);
  text("Test Image Ranked Number: " + str(choose + 1), 1, 1);

  translate(0, 30);

  fill(0);
  noStroke();
  rect(0, 0, 80, 20);
  fill(255);
  textSize(14);
  text("Image_" + str(ranked[choose] + 1), 1, 1);

  popMatrix();

  //draw processed images

  pushMatrix();

  translate(width/2, sizeVA);
  PImage test_hue = image_rank[choose];
  test_hue = get_hue(test_hue);
  test_hue.resize(width/8 -4, 0);
  image(test_hue, 2, 4);

  translate(width/8, 0);
  PImage test_sat = image_rank[choose];
  test_sat = get_saturation(test_sat);
  test_sat.resize(width/8 -4, 0);
  image(test_sat, 2, 4);

  translate(width/8, 0);
  PImage test_bri = image_rank[choose];
  test_bri = get_brightness(test_bri);
  test_bri.resize(width/8 -4, 0);
  image(test_bri, 2, 4);

  translate(width/8, 0);
  PImage _out = new PImage();
  _out = test_out[ranked[choose]].copy();
  _out.resize((width/8) - 4, 0);
  fill(0);
  rect(2,2,width/8,width/8);
  image(_out, 2, 4);

  popMatrix();

  //draw labels

  textSize(12);

  pushMatrix();

  translate(width/2, sizeVA);
  fill(0);
  noStroke();
  rect(5, 7, 100, 18);
  fill(255);
  text("Test Hue:", 7, 7);

  translate(width/8, 0);
  fill(0);
  noStroke();
  rect(5, 7, 100, 18);
  fill(255);
  text("Test Saturation:", 7, 7);

  translate(width/8, 0);
  fill(0);
  noStroke();
  rect(5, 7, 100, 18);
  fill(255);
  text("Test Brightness:", 7, 7);

  translate(width/8, 0);
  fill(0);
  noStroke();
  rect(5, 7, 100, 18);
  fill(255);
  text("Test Objects:", 7, 7);

  popMatrix();

  //draw graphics

  pushMatrix();

  translate(width/2 + 10, sizeVA + sizeVA/4 - 5);
  //draw Hue histogram
  draw_histogram(norm_test_histograms[choose][0]);

  translate(width/8, 0);
  //draw Saturation histogram
  draw_histogram(norm_test_histograms[choose][1]);

  translate(width/8, 0);
  //draw Brightness histogram
  draw_histogram(norm_test_histograms[choose][2]);

  popMatrix();
}

void keyPressed() {

  if (keyCode == DOWN & choose < test_images - 1) choose++;
  if (keyCode == UP & choose > 0) choose--;
  if (keyCode == RIGHT & choose < test_images - 1) choose++;
  if (keyCode == LEFT & choose > 0) choose--;
}

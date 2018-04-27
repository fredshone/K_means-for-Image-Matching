//k means functions

void step() {
  
  //assign cluster id based on closest centroid

  for (int i = 0; i < norm_method_scores.length; i++) {
    
    float dist_true = centroids[0].dist(norm_method_scores[i]);
    float dist_false = centroids[1].dist(norm_method_scores[i]);

    clusters[i] = false;
    if (dist_true < dist_false) {
      clusters[i] = true;
    }
  }  

  // adjust centroid locations

  PVector[] calc = new PVector[2];
  calc[0] = new PVector(0, 0, 0);
  calc[1] = new PVector(0, 0, 0);
  int[] cluster_sizes = new int[2];
  cluster_sizes[0] = 0;
  cluster_sizes[1] = 0;

  for (int i = 0; i < clusters.length; i++) {

    if (clusters[i]) {
      calc[0].add(norm_method_scores[i]); 
      cluster_sizes[0]++;
    } else {
      calc[1].add(norm_method_scores[i]); 
      cluster_sizes[1]++;
    }
  }


  //find averages, ie centroids
  centroids[0] = calc[0].div(cluster_sizes[0]);
  centroids[1] = calc[1].div(cluster_sizes[1]);
}

//function to extract cluster images

PImage[] extract_image_cluster (PImage[] pin, boolean[] _clusters, boolean target_cluster) {
  
  //calc cluster size
  int cluster_size = 0;
  
    for (int i = 0; i < _clusters.length; i++) if (_clusters[i] == target_cluster) cluster_size++;
  
  PImage[] out = new PImage[cluster_size];
  int j = 0;
  
  for (int i = 0; i < _clusters.length; i++) {
    if (_clusters[i] == target_cluster) {
      out[j] = pin[i];
    j++;
    }
  }
    
  return out;
}

//function to extract id images

int[] extract_id_cluster (boolean[] _clusters, boolean target_cluster) {
  
  //calc cluster size
  int cluster_size = 0;
  
    for (int i = 0; i < _clusters.length; i++) if (_clusters[i] == target_cluster) cluster_size++;
  
  int[] out = new int[cluster_size];
  int j = 0;
  
  for (int i = 0; i < _clusters.length; i++) {
    if (_clusters[i] == target_cluster) {
      out[j] = i+1;
    j++;
    }
  }
    
  return out;
}
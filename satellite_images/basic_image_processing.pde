PImage get_hue_edges(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = width; i < pout.pixels.length-width; i++) {
    
    float above = hue(pin.pixels[i-width]);
    float left = hue(pin.pixels[i-1]);
    float self = hue(pin.pixels[i]);
    
    float[] diff = {abs(above - self), abs(left - self)};

    pout.pixels[i] = color(max(diff));
  }

  pout.updatePixels();
  return pout;
}

PImage get_saturation_edges(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = width; i < pout.pixels.length; i++) {
    
    float above = saturation(pin.pixels[i-width]);
    float left = saturation(pin.pixels[i-1]);
    float self = saturation(pin.pixels[i]);
    
    float[] diff = {abs(above - self), abs(left - self)};

    pout.pixels[i] = color(max(diff));
  }

  pout.updatePixels();
  return pout;
}

PImage get_brightness_edges(PImage pin) {

  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = width; i < pout.pixels.length-width; i++) {
    
    float above = brightness(pin.pixels[i-width]);
    float left = brightness(pin.pixels[i-1]);
    float self = brightness(pin.pixels[i]);
    
    float[] diff = {abs(above - self), abs(left - self)};

    pout.pixels[i] = color(max(diff));
  }

  pout.updatePixels();
  return pout;
}

PImage get_split(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();
  
  // calc max and min for range
  float max = 0;
  float min = 255;

  for (int i = width; i < pout.pixels.length-width; i++) {
    
    float self = brightness(pin.pixels[i]);
    
    if (self > max) max = self;
    if (self < min) min = self;

  }
  
  float limit = (max + min) / 4;
  
  //loop through dividing at limit
    for (int i = width; i < pout.pixels.length-width; i++) {
    
    float self = brightness(pin.pixels[i]);
    
    if (self > limit) {
      self = 255;
    } else {
      self = 0;
    }
    pout.pixels[i] = color(self);
  }

  pout.updatePixels();
  return pout;
}

PImage get_blobs2(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = width; i < pout.pixels.length-width; i++) {
    
    float _self = brightness(pin.pixels[i]);
    
    int self = int(_self/20) * 20;

    pout.pixels[i] = color(self);
  }

  pout.updatePixels();
  return pout;
}

PImage smoother(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = width; i < pout.pixels.length-width; i++) {
    float a = brightness(pin.pixels[i-width]);
    float b = brightness(pin.pixels[i+width]);
    float c = brightness(pin.pixels[i]);
    float d = brightness(pin.pixels[i-1]);
    float e = brightness(pin.pixels[i+1]);
    pout.pixels[i] = color((a+b+(1*c)+d+e)/5);
  }

  pout.updatePixels();
  return pout;
}

PImage y_smoother(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = width; i < pout.pixels.length-width; i++) {
    float a = brightness(pin.pixels[i-width]);
    float b = brightness(pin.pixels[i+width]);
    float c = brightness(pin.pixels[i]);
    pout.pixels[i] = color((a+b+c)/3);
  }

  pout.updatePixels();
  return pout;
}

PImage x_smoother(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = 1; i < pout.pixels.length-1; i++) {
    float a = brightness(pin.pixels[i-1]);
    float b = brightness(pin.pixels[i+1]);
    float c = brightness(pin.pixels[i]);
    pout.pixels[i] = color((a+b+c)/3);
  }

  pout.updatePixels();
  return pout;
}

PImage get_hue(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = 0; i < pout.pixels.length; i++) {
    pout.pixels[i] = color(hue(pin.pixels[i]), 150, 150);
  }

  pout.updatePixels();
  return pout;
}

PImage get_saturation(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = 0; i < pout.pixels.length; i++) {
    pout.pixels[i] = color(150, saturation(pin.pixels[i]), 150);
  }

  pout.updatePixels();
  return pout;
}

PImage get_brightness(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = 0; i < pout.pixels.length; i++) {
    pout.pixels[i] = color(0, 0, brightness(pin.pixels[i]));
  }

  pout.updatePixels();
  return pout;
}

PImage get_brightness_inv(PImage pin) {

  pin.loadPixels();
  PImage pout = createImage(pin.width, pin.height, HSB);
  pout.loadPixels();

  for (int i = 0; i < pout.pixels.length; i++) {
    pout.pixels[i] = color(0, 0, 255 - brightness(pin.pixels[i]));
  }

  pout.updatePixels();
  return pout;
}
//A bomb that kills zombies and common in a defined radius
class Bomb {
  PVector pos;
  float radius;
  boolean exploding = false;
  boolean exploded = false;
  int explFrames = 255;

  Bomb(PVector p, float r) {
    pos = p;
    radius = r;
    explFrames = 10;
    exploded = false;
  }
  boolean insideRadius(Actor a) {
    if (PVector.dist(pos, a.pos) < radius) {
      return true;
    } else {
      return false;
    }
  }
  void walked(Actor a) {
    if (PVector.dist(pos, a.pos) < 6 && exploded==false) {
      exploding = true;
    }
  }
  void show() {
    if (!exploded) {
      if (!exploding) {
        stroke(0);
        strokeWeight(1);
        rectMode(CENTER);
        fill(180);
        rect(pos.x, pos.y, 12, 12);
        textAlign(LEFT);
        fill(0);
        textSize(12);
        text("B", pos.x-4, pos.y+3);
      } else {
        int alpha = floor(map(explFrames, 20, 0, 255, 0));
        ellipseMode(CENTER);
        noStroke();
        fill(255, 160, 60, alpha);
        ellipse(pos.x, pos.y, 2*radius, 2*radius);
        explFrames --;
        if (explFrames < 0) {
          exploded = true;
          exploding = false;
        }
      }
    }
  }
}
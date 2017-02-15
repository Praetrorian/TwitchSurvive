class Actor {
  PVector pos;
  PVector dir;
  float speed;
  float distanceZ;
  // 0:Common 1:Hero  2:Zombie
  int actorType;  

  float shootDistance;
  boolean shooting = false;
  int killingSpree = 0;
  int cooldown;
  int shootingCooldown = 20;


  Actor(PVector pos0, PVector dir0, float s, int type) {
    pos = pos0;
    dir = dir0;
    speed=s;
    actorType = type;

    switch(actorType) {
    case 0 :
      distanceZ = defaultZdistance;
      break;
    case 1 :
      distanceZ = defaultZdistance;
      break;
    case 2 :
      distanceZ = defaultDistance;
      break;
    }
  }
  void setType(int i){
   actorType = i; 
  }
  void findClosest(Actor z) {
    switch(actorType) {
    case 0 :  //if the actual actor is common
      if (z.actorType == 2) {   //if the tested actor is a zombie FLEE
        if (PVector.dist(z.pos, pos) < distanceZ) {
          distanceZ = PVector.dist(z.pos, pos);
          dir = z.pos.copy().sub(pos.copy());
          dir.mult(-1);
        }
      }
      break;
    case 1 : // if the actual actor is a hero
      if (z.actorType == 2) {  //if the tested is a zombie flee
        if (PVector.dist(z.pos, pos) < distanceZ) {
          distanceZ = PVector.dist(z.pos, pos);
          dir = z.pos.copy().sub(pos.copy());
          dir.mult(-1);
        }
        if (PVector.dist(z.pos, pos) < shootDistance) {  //if the zombie is close enough shoot
          if (shooting == false) {
            shoot(z);
            z.setType(-1);
            killingSpree ++;
            cooldown = frameCount;
            shootingCooldown --;
            if (shootingCooldown < 8)
              shootingCooldown=8;
            shooting=true;
          } else {
            if (frameCount - cooldown > shootingCooldown) {
              shooting = false;
            }
          }
        }
      }
      break;
    case 2 : //if the tested is a zombie
      if (z.actorType == 0 || z.actorType == 1) {
        if (PVector.dist(z.pos, pos) < distanceZ) {
          distanceZ = PVector.dist(z.pos, pos);
          dir = z.pos.copy().sub(pos.copy());
        }
      }
      break;
    }
  }
  void turnAround() {
    dir.mult(-1);
    pos.add(dir.copy());
  }
  void update() {
    dir.setMag(speed);

    dir.rotate(random(-PI/7, PI/7));  
    pos.add(dir.copy());


    edges();
    switch(actorType) {
    case 0 :
      distanceZ = defaultZdistance;
      break;
    case 1 :
      distanceZ = defaultZdistance;
      break;
    case 2 :
      distanceZ = defaultDistance;
      break;
    }
  }

  void show() {
    noStroke();
    switch(actorType) {
    case 0 :
      fill(0, 255, 0);
      break;
    case 1 :
      int h = floor(map(killingSpree, 0, 20, 0, 255));
      fill(h, h, 255);
      break;
    case 2 :
      fill(255, 0, 0);
      break;
    }

    ellipse(pos.x, pos.y, 8, 8);
  }
  void shoot(Actor z) {
    stroke(220, 220, 0);
    strokeWeight(3);
    line(pos.x, pos.y, z.pos.x, z.pos.y);
  }
  void edges() {
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;
  }

  boolean collision(Actor a) {
    if (PVector.dist(pos, a.pos) < 8) {
      return true;
    }
    return false;
  }
}
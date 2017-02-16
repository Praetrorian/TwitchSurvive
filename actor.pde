class Actor {
  PVector pos;
  PVector prevPos;
  PVector dir;
  float speed;
  float distanceZ;
  // 0:Common 1:Hero  2:Zombie 3:SuperZombie
  int actorType;  


  //Heroes variables
  String name;
  float shootDistance;
  boolean dead = false;
  boolean shooting = false;
  int killingSpree = 0;
  int cooldown;
  int shootingCooldown = 15;
  int maxCooldown = shootingCooldown;
  int minCooldown = 8;


  int radius = 0;
  Actor(PVector pos0, PVector dir0, int type, String n) {
    pos = pos0;
    prevPos = pos0;
    dir = dir0;

    actorType = type;

    switch(actorType) {
    case 0 : //COMMON
      distanceZ = defaultZdistance;
      speed = random(0.9, 1.1);
      break;
    case 1 : //HEROES
      name = n;
      distanceZ = defaultHdistance;
      shootDistance = 25;
      speed = random(1, 1.3);
      break;
    case 2 : //ZOMBIES
      distanceZ = defaultDistance;
      speed = random(1, 1.4);
      break;
    }
  }

  Actor(PVector pos0, PVector dir0, int type) {
    pos = pos0;
    prevPos = pos0;
    dir = dir0;

    actorType = type;

    switch(actorType) {
    case 0 : //COMMON
      distanceZ = defaultZdistance;
      speed = random(0.9, 1.1);
      break;
    case 1 : //HEROES
      distanceZ = defaultHdistance;
      shootDistance = 25;
      speed = random(1, 1.3);
      break;
    case 2 : //ZOMBIES
      distanceZ = defaultDistance;
      speed = random(1, 1.4);
      break;
    }
  }
  
  //method to set the actor's type
  void setType(int i) {
    actorType = i;
  }
  
  //method to increase the actor's radius
  void decreaseRadius() {
    radius--;
  }
  
  //method to decrease it
  void increaseRadius() {
    radius++;
  }
  
  //this method fund the closest actor of this actor, depending on this actor type and the tested actor's type
  void findClosest(Actor z) {
    switch(actorType) {
    case 0 :  //if the actual actor is common
      if (z.actorType == 2 || z.actorType == 3) {   //if the tested actor is a zombie FLEE
        if (PVector.dist(z.pos, pos) < distanceZ) {
          distanceZ = PVector.dist(z.pos, pos);
          dir = z.pos.copy().sub(pos.copy());
          dir.mult(-1);
        }
      }
      break;
    case 1 : // if the actual actor is a hero
      if (z.actorType == 2 || z.actorType == 3) {  //if the tested is a zombie flee
        if (PVector.dist(z.pos, pos) < distanceZ) {
          distanceZ = PVector.dist(z.pos, pos);
          dir = z.pos.copy().sub(pos.copy());
          dir.mult(-1);
        }
        if (PVector.dist(z.pos, pos) < shootDistance) {  //if the zombie is close enough shoot
          if (shooting == false) {
            shoot(z);
            z.decreaseRadius();
            if (z.radius < 0) {
              z.setType(-1);
              killingSpree ++;
            }
            cooldown = frameCount;
            shootingCooldown --;
            if (shootingCooldown < minCooldown)
              shootingCooldown=minCooldown;
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
    case 3 : //if the tested is a super zombie
      if (z.actorType == 0 || z.actorType == 1) {
        if (PVector.dist(z.pos, pos) < distanceZ) {
          distanceZ = PVector.dist(z.pos, pos);
          dir = z.pos.copy().sub(pos.copy());
        }
      }
      break;
    }
  }
  
  //this method set this actor boolean dead to true
  void setDead() {
    dead = true;
  }
  
  //this method make the actor turn at 180°
  void turnAround() {
    dir.mult(-1);
    pos = prevPos;
    //  pos.add(dir.copy());
  }
  
  //this method update the position, radius and direction of the actor
  void update() {
    dir.setMag(speed);

    dir.rotate(random(-PI/7, PI/7));  
    prevPos = pos;
    pos.add(dir.copy());
    if (radius == superZombieAmount) {
      radius = 0;
      speed *= superZombieRatio;
      actorType = 3;
    }

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
    case 3 :
      distanceZ = defaultSZDistance;
      break;
    }
  }

  //this method show the actor depending on his type (color, radius, name)
  void show() {
    noStroke();
    switch(actorType) {
    case 0 :
      fill(0, 255, 0);
      break;
    case 1 :
      int h = floor(map(killingSpree, 0, maxCooldown - minCooldown, 0, 255));
      fill(h, h, 255);
      break;
    case 2 :
      fill(255, 0, 0);
      break;
    case 3 :
      fill(40, 0, 0);
      break;
    }
    textAlign(CENTER);
    ellipse(pos.x, pos.y, normalRadius + radius, normalRadius + radius);
    fill(255);
    textSize(12);
    if (name != null && !dead)
      text(name, pos.x, pos.y -10);
  }
  
  //this method make the actor shoot (if it's a hero)
  void shoot(Actor z) {
    stroke(220, 220, 0);
    strokeWeight(3);
    line(pos.x, pos.y, z.pos.x, z.pos.y);
  }
  
  //method to restrain the pos of the actor
  void edges() {
    if (pos.x <= -width/2)  pos.setMag(pos.mag() * 0.999);
    if (pos.x >= width/2)   pos.setMag(pos.mag()  * 0.999);
    if (pos.y <= -height/2) pos.setMag(pos.mag()  * 0.999);
    if (pos.y >= height/2)  pos.setMag(pos.mag()  * 0.999);
    if (pos.mag() > fightingZone) pos.setMag(fightingZone * 0.999);
  }

  //method to test if this actor collide with the actor a
  boolean collision(Actor a) {
    if (PVector.dist(pos, a.pos) < normalRadius + radius/2 + a.radius/2) {
      return true;
    }
    return false;
  }
}
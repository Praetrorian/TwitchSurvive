void testWinner() {
}

void reset() {
  ArrayList<Actor> actors = new ArrayList<Actor>();
  int startActor = startCommon + startZombie + startHeroe;
  for (int i = 0; i < startActor; i++) {
    actors.add(new Actor(new PVector(random(width), random(height)), new PVector(random(-1, 1), random(-1, 1)), random(0.9, 1.2), 0));
  }
}
void count() {
  commonsCount = 0;
  heroesCount = 0;
  zombiesCount = 0; 
  for (Actor a : actors) {
    switch(a.actorType) {
    case 0 :
      commonsCount ++;
      break;
    case 1 :
      heroesCount ++;
      break;
    case 2 :
      zombiesCount ++;
      break;
    }
  }
}
void drawScore() {
  count();
  float zCount = zombiesCount;
  float cCount = commonsCount;
  float hCount = heroesCount;
  float total = cCount + zCount + hCount;
  float zRatio = zCount/total;
  float cRatio = cCount/total;
  float hRatio = hCount/total;

  float humanRatio = cRatio + hRatio;

  noStroke();
  fill(255, 0, 0);
  rect(0, 0, zRatio*width, 20);
  fill(0, 255, 0);
  rect(zRatio*width, 0, width, 20);
  textSize(18);
  fill(255);
  stroke(0);
  strokeWeight(2);
  textAlign(CENTER);
  text(floor(zRatio*100) + "%", 0.9*zRatio*width/2, 18);
  text(floor(humanRatio*100) + "%", 0.5*(1 +zRatio)*width, 18);

  text("HUMANS  " + scoreH + "  :  " + scoreZ + "  ZOMBIES", width/2, 40);
}


void update() {
  for (int i = 0; i < actors.size(); i++) {
    for (int j = 0; j < actors.size(); j++) {
      if (i!=j) {
        actors.get(i).findClosest(actors.get(j));
      }
    }
  }

  for (int j = 0; j < actors.size(); j++) {
    if (actors.get(j).actorType == -1) actors.remove(j);
  }
  for (Actor a : actors) {
    a.update();
  }
}
void show() {
  for (Actor a : actors) {
    a.show();
  }
}
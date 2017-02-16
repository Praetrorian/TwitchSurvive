//This function creates a new bomb every bombFrames frame unless the previous one has not exploded
void createNewBomb() {
  if (b.exploded || b.pos.mag() > fightingZone) {
    if (frameCount % bombFrames == 0) {
      PVector r = PVector.random2D();
      r.setMag(random(0.8)*fightingZone);
      b = new Bomb(r, bombRadius);
    }
  }
}

//This function test if all zombie or humans are dead
void testWinner() {
  count();
  if (humansCount == 0) {
    scoreZ ++;
    humansWin = false; 
    roundEnd = true;
  }
  if (zombiesCount == 0) {
    scoreH ++;
    humansWin = true;
    roundEnd = true;
  }
}

//This function decrease the fighting zone radius depending on the frameCount
void updateFightingZone() {
  if (frameCount % 12 == 0) {
    fightingZone *= 0.999;
  }
  // println(fightingZone);
}

//This function draw the fighting zone
void drawFightingZone() {
  noStroke();
  fill(40);
  ellipse(0, 0, fightingZone*2, fightingZone*2);
}

//This function find all the heroes among the arraylist actors and put them in the arraylist heroes
void findHeroes() {
  heroes = new ArrayList<Hero>();
  for (Actor a : actors) {
    if (a.actorType ==1) {
      heroes.add(new Hero(a.name, a.killingSpree));
    }
  } 

  findtop10Heroes();
}

//This function sort the array list heroes by number of zombies killed
void findtop10Heroes() {
  for (int i = heroes.size()-1; i>0; i--) {
    for (int j = 0; j < i; j++) {
      if (heroes.get(j).kills < heroes.get(j+1).kills) {
        swapHero(j);
      }
    }
  }
}

//This  function swap 2 heroes in the arraylist heroes (used to sort them : bubble sorting)
void swapHero(int j) {
  Hero temp = heroes.get(j);
  heroes.remove(j);
  heroes.add(j+1, temp);
}

//This function draw the first 10 heroes
void drawTop10() {
  fill(25, 25, 25, 150);
  stroke(20);
  strokeWeight(5);
  rect(-width/2 + 10, -0.33*height, 200, 0.99*height/2);
  for (int i = 0; i<10; i++) {
    textSize(18);
    fill(220);
    textAlign(LEFT);
    if (heroes.size()>i)
      text(i+1 + ": " + heroes.get(i).name + " / " +heroes.get(i).kills + " kills", -width/2 +20, (-0.3 + 0.05 * i) * height );
  }
}

//this function draw the round (i.e it's the game)
void drawRound() {
  background(30);
  createNewBomb();
  
  drawFightingZone();
  updateFightingZone();

  update();
  b.show();
  show();
  drawScore();
  drawTop10();
  testWinner();
}

//this function draw the result of the game (draw the top10 alive heroes, or says zombies won) + a 10seconds timer before the next round
void drawEndRound() {
  background(40);
  if (humansWin) {
    textSize(40);
    textAlign(CENTER);
    text("SURVIVORS WON", 0, -0.8*height/2);
    textSize(20);
    textAlign(LEFT);
    text("1st : " + heroes.get(0).name + "\t killed \t" + heroes.get(0).kills + " zombies", - 0.3*width, -0.5*height/2);
    if (heroes.size()>1)
      text("2nd : " + heroes.get(1).name + "\t killed \t" + heroes.get(1).kills + " zombies", - 0.3*width, -0.4*height/2);
    if (heroes.size()>2)
      text("3rd : " + heroes.get(2).name + "\t killed \t" + heroes.get(2).kills + " zombies", - 0.3*width, -0.3*height/2);
    for (int i = 3; i < 10; i++) {
      if (heroes.size()>i) {
        text(i +"th : " + heroes.get(i).name + "\t killed \t" + heroes.get(i).kills + " zombies", - 0.3*width, (-0.5 +0.1 * i)*height/2);
      }
    }
  } else {
    textSize(40);
    textAlign(CENTER);
    text("ALL HEROES DIED", 0, -50);
    text("ZOMBIES WON", 0, 50);
  }

  if (startTimer) {
    timeStart = getSecond();
    wait = 0;
    startTimer = false;
  }
  if (wait >= waitingTime) {
    roundEnd = false;
    startTimer  = true;
    reset();
  }
  wait = getSecond()-timeStart;
  textAlign(CENTER);
  textSize(30);
  text("Next Round in", width/4, -0.15*height);
  textSize(50);
  text(floor(10 - wait), width/4, 0);
}

//this function start a new round
void reset() {
  fightingZone = floor(0.8*width);
  actors = new ArrayList<Actor>();
  PVector r = PVector.random2D();
  r.setMag(random(0.8)*fightingZone);
  b = new Bomb(r, bombRadius);

  int startActor = startCommon + startZombie + startHeroe;
  for (int i = 0; i < startActor; i++) {
    //SPAWN COMMONS
    if (i < startCommon)
      actors.add(new Actor(new PVector(random(-width/2, width/2), random(-height/2, height/2)), new PVector(random(-1, 1), random(-1, 1)), 0));
    //SPAWN HEROES
    if (i >= startCommon && i < startCommon + startHeroe)
      actors.add(new Actor(new PVector(random(-width/2, width/2), random(-height/2, height/2)), new PVector(random(-1, 1), random(-1, 1)), 1, str(floor(random(50)))));
    //SPANW ZOMBIES
    if (i >= startCommon + startHeroe && i < startCommon + startHeroe + startZombie)
      actors.add(new Actor(new PVector(random(-width/2, width/2), random(-height/2, height/2)), new PVector(random(-1, 1), random(-1, 1)), 2));
  }
}

//this function return the number of second since 0:00:01;
int getSecond() {
  return hour()*24*60 + minute()* 60 + second();
}

//this function count how many humans and zombies are left
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
    case 3 :
      zombiesCount ++;
      break;
    }
  }
  humansCount = commonsCount + heroesCount;
}

//this function draw the ratio humans/zombie and the score for each "team"
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
  rectMode(CORNER);
  fill(255, 0, 0);
  rect(-width/2, -height/2, zRatio*width, 20);
  fill(0, 255, 0);
  rect(-width/2 + zRatio*width, -height/2, width, 20);
  textSize(18);
  fill(255);
  stroke(0);
  strokeWeight(2);
  textAlign(CENTER);
  text(floor(zRatio*100) + "%", -width/2 + 0.9*zRatio*width/2, -height/2 + 18);
  text(floor(humanRatio*100) + "%", -width/2 + 0.5*(1 +zRatio)*width, -height/2 + 18);

  text("HUMANS  " + scoreH + "  :  " + scoreZ + "  ZOMBIES", 0, -height/2 + 40);
}

//this function update all the actors
void update() {
  for (int i = 0; i < actors.size(); i++) {
    for (int j = 0; j < actors.size(); j++) {
      if (i!=j) {
        actors.get(i).findClosest(actors.get(j));
        if (actors.get(i).collision(actors.get(j))) {
          switch(actors.get(i).actorType) {
          case 0 :
            if (actors.get(j).actorType==2 || actors.get(j).actorType == 3) {
              actors.get(i).setType(2);
              actors.get(j).increaseRadius();
            }
            if (actors.get(j).actorType==0 || actors.get(j).actorType == 1) {
              actors.get(i).turnAround();
              actors.get(j).turnAround();
            }
            break;
          case 1 :
            if (actors.get(j).actorType==2 || actors.get(j).actorType == 3) {
              actors.get(i).setType(2);
              actors.get(i).setDead();
            }
            if (actors.get(j).actorType==0 || actors.get(j).actorType==1) {
              actors.get(i).turnAround();
              actors.get(j).turnAround();
            }
            break;
          case 2 :
            if (actors.get(j).actorType==0 || actors.get(j).actorType==1 ) {
              actors.get(j).setType(2);
              actors.get(j).setDead();
              actors.get(i).increaseRadius();
            }
            if (actors.get(j).actorType==2 || actors.get(j).actorType == 3) {
              actors.get(i).turnAround();
              actors.get(j).turnAround();
            }
            break;
          case 3 :
            if (actors.get(j).actorType==0 || actors.get(j).actorType==1 ) {
              actors.get(j).setType(2);
              actors.get(j).setDead();
              actors.get(i).increaseRadius();
            }
            if (actors.get(j).actorType==2 || actors.get(j).actorType == 3) {
              actors.get(i).turnAround();
              actors.get(j).turnAround();
            }
            break;
          }
        }
      }
    }
  }

  for (int j = 0; j < actors.size(); j++) {
    if (actors.get(j).actorType == -1) actors.remove(j);
  }
  for (Actor a : actors) {
    a.update();
    if (b.exploding == true && a.actorType!=1) {
      if (b.insideRadius(a)) {
        a.setType(-1);
      }
    }
  }
  findHeroes();
}

//this function shows all the actors
void show() {
  for (Actor a : actors) {
    a.show();
    b.walked(a);
  }
}
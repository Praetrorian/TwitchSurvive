ArrayList<Actor> actors = new ArrayList<Actor>();

//Starting population
int startCommon = 400;
int startZombie = 10;
int startHeroe  = 20;
//count population
int commonsCount = 0;
int heroesCount = 0;
int zombiesCount = 0;
//Distance to trigger zombies
float defaultDistance = 100;
//Distance to make common flee
float defaultZdistance = 30;
//Distance to trigger heroes
float defaultHdistance = 60;


//Zombies score
int scoreZ = 0;
//Humans score
int scoreH = 0;


void setup() {
  size(600, 600);

  int startActor = startCommon + startZombie + startHeroe;
  for (int i = 0; i < startActor; i++) {
    if (i < startCommon)
      actors.add(new Actor(new PVector(random(width), random(height)), new PVector(random(-1, 1), random(-1, 1)), random(0.9, 1.2), 0));
    if (i >= startCommon && i < startCommon + startHeroe)
      actors.add(new Actor(new PVector(random(width), random(height)), new PVector(random(-1, 1), random(-1, 1)), random(0.9, 1.2), 1));
    if (i >= startCommon + startHeroe && i < startCommon + startHeroe + startZombie)
      actors.add(new Actor(new PVector(random(width), random(height)), new PVector(random(-1, 1), random(-1, 1)), random(0.9, 1.2), 2));
  }
}

void draw() {
  background(51);

  update();
  show();
  drawScore();
  testWinner();
}
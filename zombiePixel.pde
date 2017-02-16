import java.util.Collections;
import java.util.Arrays;


ArrayList<Actor> actors =  new ArrayList<Actor>();
ArrayList<Hero> heroes =  new ArrayList<Hero>();
Bomb b;


//Starting population
int startCommon = 400;
int startZombie = 10;
int startHeroe  = 50;
//count population
int commonsCount = 0;
int heroesCount = 0;
int humansCount = 0;
int zombiesCount = 0;
//Distance to trigger zombies
float defaultDistance = 150;
//Distance to trigger super zombies
float defaultSZDistance = 80;
//Distance to make common flee
float defaultZdistance = 30;
//Distance to trigger heroes
float defaultHdistance = 20;

int superZombieAmount = 8;
float superZombieRatio =1.3;
int normalRadius = 8;
//Zombies score
int scoreZ = 0;
//Humans score
int scoreH = 0;

int bombFrames = 1000;
int bombRadius = 150;

boolean humansWin = false;
int waitingTime = 10;
int timeStart = 0;
int wait = 0;
boolean startTimer = true;
boolean roundEnd = false;

int fightingZone;
void setup() {
  size(1280, 720);
  fightingZone = 2*width;
  reset();
}

void draw() {
  translate(width/2, height/2);
 
println(b.pos);
  if (!roundEnd) {
    drawRound();
  } else {
    drawEndRound();
  }
}
//
//  HelloWorldLayer.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/6/21.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Monster.h"
#import "CollisionAttacker.h"
#import "CollisionManager.h" 
#import "Spaceship.h"
#import "Demon.h"
#import "OptionsScene.h"
#import "Terrain.h"

@class Tutorial;
@class GameObject;


// HelloWorldLayer
@interface HelloWorld : CCLayer
{
    b2World * _world;
    Terrain *_terrain;
	NSMutableArray *_ghost;
	NSMutableArray *_knife;
	NSMutableArray *_monsterKnife;
	int _knifesDestroyed;
	CCSprite *_cannon;
	CCSprite *_nextKnife;
	CCSprite *_curBg;
	NSMutableArray *_movableSprites;
	NSMutableArray *_spaceDebris;
	NSArray *_heroImages;
	CCSprite *_selSprite;
	CCSprite *_frontBg;
	CCSprite *_background;
	CCSpriteBatchNode *_spriteSheet;
	CCSprite *_explode;
    CCAction *_explodeAction;
	int _score;
	int _oldScore;
	int _heroRole;
	int _heroNum;
	CCLabelTTF *_scoreLabel;
	CCSprite *_scoreTitle;
	CCLabelTTF *_curLevel;
	CCSprite *_spacemonkey;
	Monster *_moveGhost;
	CollisionAttacker *_attacker;
	CCLabelTTF *_pausedTitle;
	CCMenu *_pauseButton;
	CCMenu *_soundButton;
	CCMenu *_playButton;
	CCSprite *_minda;
	CCSprite *_spacemanPause;
	CCNode *_pauseLayer;
	CCMenu *_pauseMenu;
	int _mode;
	CCMenuItemImage *_bulletOn;
	CCMenuItemImage *_bulletOff;
	CCSprite *_meteor;
	CCParticleFire *_particleFire;
	CCParticleExplosion *_particleExplosion;
	CCSprite *devil;
	CCParticleFire *fireball; 
	CollisionManager *collisionMngr;
	Demon *demon; 
	CCSpriteBatchNode *spaceSpriteSheet;
	Spaceship *spaceship;
	CCAction *flyingAction;
	CCSprite *life;
	int lives;
	int bombs;
	bool canLaunchBomb;
	bool bombDestroyAll;
	CCLabelBMFont *livesCount;
	CCLabelBMFont *bombsCount;
	CCParticleExplosion *megaexplosion;
	float lastTimeEnemyLaunched;
	float enemyInterval;
	float attackerInterval;
	float meteorInterval;
	Options *gameOption;
	int prevMusicLevel;
	int prevSoundLevel;
	int difficulty;
	//CCSpriteBatchNode *_batchNode;
	CCParallaxNode *_backgroundNode;
	CCSprite *_spacedust1;
	CCSprite *_spacedust2;
	CCSprite *_planetsunrise;
	CCSprite *_galaxy;
	CCSprite *_spacialanomaly;
	CCSprite *_spacialanomaly2;
	CCSprite *_saturn;
	NSMutableArray *_spacelifes;
	int _nextSpacelife;
	double _nextSpacelifeSpawn;
	CCSprite *ssBack;
	CCLabelTTF *musicVolumeTitle;
	CCMenuItemSlider *musicSlider;
	CCMenuItemSlider *soundSlider;
	CCMenuItemToggle *musicBtn;
	CCMenuItemToggle *soundBtn;
	CCMenuItemSprite *gritterClose;
	CCMenu *ssMenu;
	bool ssClicked;
	int spawnFrames;
    int spawnInterval;
	GameObject *player;
}

@property (nonatomic, retain) CCSprite *_background;
@property (nonatomic,readonly) NSMutableArray *_ghost;
@property (nonatomic,readonly) NSMutableArray *_knife;
@property (nonatomic,readonly) NSMutableArray *_monsterKnife;
@property (nonatomic,retain) CCSprite *_curBg;
@property (nonatomic,assign) CCLabelTTF *_scoreLabel;
@property (nonatomic,retain) CCSprite *_nextKnife;
@property (nonatomic,assign) CCLabelTTF *_curLevel;
@property (nonatomic,retain) CCSpriteBatchNode *_spriteSheet;
@property (nonatomic,retain) CCSprite *_explode;
@property (nonatomic,retain) CCAction *_explodeAction;
@property (nonatomic,assign) int _mode;
@property (nonatomic,retain) CCParticleFire *fireball; 
@property (nonatomic,retain) CollisionManager *collisionManager;
@property (nonatomic,retain) Demon *demon; 
@property (nonatomic,retain) Spaceship *spaceship; 
@property (nonatomic, retain) CCAction *flyingAction;
@property (nonatomic,assign) int lives; 
@property (nonatomic,readwrite) int bombs;
@property (nonatomic,readwrite) bool canLaunchBomb;
@property (nonatomic,readwrite) bool bombDestroyAll;
@property (nonatomic,retain) CCLabelBMFont *livesCount;
@property (nonatomic,retain) CCLabelBMFont *bombsCount;
@property (nonatomic,retain) CCParticleExplosion *megaexplosion;
@property (nonatomic,readwrite) float lastTimeEnemyLaunched;
@property (nonatomic,readwrite) float enemyInterval;
@property (nonatomic, readwrite) float attackerInterval;
@property (nonatomic, readwrite) float meteorInterval;
@property int prevMusicLevel;
@property int prevSoundLevel;
@property (assign,readwrite) int difficulty;
@property (nonatomic, retain) CCSprite *ssBack;
@property (nonatomic, retain) CCMenuItemSlider *musicSlider;
@property (nonatomic, retain) CCMenuItemSlider *soundSlider;
@property (nonatomic, retain) CCMenuItemToggle *musicBtn;
@property (nonatomic, retain) CCMenuItemToggle *soundBtn;
@property (nonatomic,readwrite) bool ssClicked;
@property (nonatomic, assign) GameObject *player;

+(id) scene;
-(void) reset;
-(void) gameBegin;
-(void) startGame;
-(void) drawPauseButtons;
-(void) drawSoundButtons;
-(void) drawResumeButtons;
-(BOOL) isGameOver;
-(void) loadGameOver;
-(void) addSpaceshipToGame;
-(void) addDemonToGame;
-(void) drawLives: (int) newLive;
-(void) removeLifeByTag:(int) liveTag;
-(CGRect) myRect:(CCSprite *)sp;
-(void) explodeBomb;

@end

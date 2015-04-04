//
//  HelloWorldLayer.mm
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/6/21.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameOverScene.h"
#import "GameWinScene.h"
#import "MenuScene.h"
#import "Monster.h"
#import "CollisionAttacker.h"
#import "Level.h"
#import "CannonBall.h"
#import "NewLevelScene.h"
#import "Tutorial.h"
#import "MusicHandler.h"
#import "CCParallaxNode-Extras.h"
#import "ActionFactory.h"
#import "ObjectFactory.h"
#import "GameObject.h"
#import "AppDelegate.h"

#define STARTING_LIVES 2
#define STARTING_BOMBS 1
#define kNumMonsterBullet 50
#define kNumSpaceLife 15

//Set object's tag to kTagAttacker will let it attack the hero!!
//If we have 4 hreos, then enum kTagHero from 0 to 3. The first hero tag is 0.
enum {
	kTagHero = 0,
	// Tag 1~5 remain for lives tag. (Assume the spaceship lives is max to 5)
	kTagGhost = 6, 
	kTagAttacker = 7, 
	kTagDemon = 8, 
	kTagDebris = 9, 
	kTagKnife = 10, 
	kTagMonsterBullet = 20
};


// HelloWorldLayer implementation
@implementation HelloWorld

@synthesize _background;
@synthesize _ghost;
@synthesize _knife;
@synthesize _monsterKnife;
@synthesize _curBg;
@synthesize _scoreLabel;
@synthesize _nextKnife;
@synthesize _curLevel;
@synthesize _spriteSheet;
@synthesize _explode;
@synthesize _explodeAction;
@synthesize _mode;
@synthesize fireball;
@synthesize collisionManager;
@synthesize demon;
@synthesize spaceship;
@synthesize flyingAction;
@synthesize lives;
@synthesize bombs;
@synthesize canLaunchBomb;
@synthesize bombDestroyAll;
@synthesize livesCount;
@synthesize bombsCount;
@synthesize megaexplosion;
@synthesize lastTimeEnemyLaunched;
@synthesize enemyInterval;
@synthesize attackerInterval;
@synthesize meteorInterval;
@synthesize prevMusicLevel;
@synthesize prevSoundLevel;
@synthesize difficulty;
@synthesize ssBack, soundSlider, musicSlider, soundBtn, musicBtn, ssClicked;
@synthesize player;

+(id) scene
{
	CCScene *scene = [CCScene node];
	[scene addChild:[HelloWorld node]];
	return scene;
}

-(CCSprite *)spriteWithColor:(ccColor4F)bgColor textureSize:(float)textureSize {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    // 3: Draw into the texture
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    float gradientAlpha = 0.7;    
    CGPoint vertices[4];
    ccColor4F colors[4];
    int nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0 };
    vertices[nVertices] = CGPointMake(textureSize, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(0, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    vertices[nVertices] = CGPointMake(textureSize, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

-(CCSprite *)stripedSpriteWithColor1:(ccColor4F)c1 color2:(ccColor4F)c2 textureSize:(float)textureSize  stripes:(int)nStripes {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:c1.r g:c1.g b:c1.b a:c1.a];
    
    // 3: Draw into the texture    
    
    // Layer 1: Stripes
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    CGPoint vertices[nStripes*6];
    int nVertices = 0;
    float x1 = -textureSize;
    float x2;
    float y1 = textureSize;
    float y2 = 0;
    float dx = textureSize / nStripes * 2;
    float stripeWidth = dx/2;
    for (int i=0; i<nStripes; i++) {
        x2 = x1 + textureSize;
        vertices[nVertices++] = CGPointMake(x1, y1);
        vertices[nVertices++] = CGPointMake(x1+stripeWidth, y1);
        vertices[nVertices++] = CGPointMake(x2, y2);
        vertices[nVertices++] = vertices[nVertices-2];
        vertices[nVertices++] = vertices[nVertices-2];
        vertices[nVertices++] = CGPointMake(x2+stripeWidth, y2);
        x1 += dx;
    }
    
    glColor4f(c2.r, c2.g, c2.b, c2.a);
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glDrawArrays(GL_TRIANGLES, 0, (GLsizei)nVertices);
    
    // layer 2: gradient
    glEnableClientState(GL_COLOR_ARRAY);
    
    float gradientAlpha = 0.7;    
    ccColor4F colors[4];
    nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0 };
    vertices[nVertices] = CGPointMake(textureSize, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(0, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    vertices[nVertices] = CGPointMake(textureSize, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    // layer 3: top highlight    
    float borderWidth = textureSize/16;
    float borderAlpha = 0.3f;
    nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){1, 1, 1, borderAlpha};
    vertices[nVertices] = CGPointMake(textureSize, 0);
    colors[nVertices++] = (ccColor4F){1, 1, 1, borderAlpha};
    
    vertices[nVertices] = CGPointMake(0, borderWidth);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(textureSize, borderWidth);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);        
    
    // Layer 2: Noise    
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];        
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

- (ccColor4F)randomBrightColor {
    
    while (true) {
        float requiredBrightness = 192;
        ccColor4B randomColor = 
        ccc4(arc4random() % 255,
             arc4random() % 255, 
             arc4random() % 255, 
             255);
        if (randomColor.r > requiredBrightness || 
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return ccc4FFromccc4B(randomColor);
        }        
    }
    
}

- (void)genBackground {
    
    [_background removeFromParentAndCleanup:YES];
    
    ccColor4F bgColor = [self randomBrightColor];
    _background = [self spriteWithColor:bgColor textureSize:512];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _background.position = ccp(winSize.width/2, winSize.height/2);        
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [_background.texture setTexParameters:&tp];
    
    [self addChild:_background z:-2];
    
    ccColor4F color3 = [self randomBrightColor];
    ccColor4F color4 = [self randomBrightColor];
    CCSprite *stripes = [self stripedSpriteWithColor1:color3 color2:color4 textureSize:512 stripes:4];
    ccTexParams tp2 = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
    [stripes.texture setTexParameters:&tp2];
    _terrain.stripes = stripes;
    
}

- (void)setupWorld {    
    b2Vec2 gravity = b2Vec2(0.0f, -7.0f);
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);            
}

- (void)createTestBodyAtPostition:(CGPoint)position {
    
    b2BodyDef testBodyDef;
    testBodyDef.type = b2_dynamicBody;
    testBodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
    b2Body * testBody = _world->CreateBody(&testBodyDef);
    
    b2CircleShape testBodyShape;
    b2FixtureDef testFixtureDef;
    testBodyShape.m_radius = 25.0/PTM_RATIO;
    testFixtureDef.shape = &testBodyShape;
    testFixtureDef.density = 1.0;
    testFixtureDef.friction = 0.2;
    testFixtureDef.restitution = 0.5;
    testBody->CreateFixture(&testFixtureDef);
    
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		//Set difficulty level from option menu
		NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
		self.difficulty = [usrDef integerForKey:@"difficulty"];
		NSLog(@"%d", difficulty);
		
		self.isTouchEnabled = NO;
		//Enable accelerometer feature
		self.isAccelerometerEnabled = NO;
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
		
		collisionManager = [[CollisionManager alloc] init];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        
        [self setupWorld];
        self.scale = 1.0;
		
		//Set up the particle emitter for the fire trail
		_particleFire = [[CCParticleFire alloc] initWithTotalParticles:100];
		_particleFire.texture = [[CCTextureCache sharedTextureCache] addImage:@"fire.png"];
		_particleFire.startSpinVar = 50.0f;
		_particleFire.posVar = ccp(15.0f, 15.0f);
		[_particleFire stopSystem];
		[self addChild:_particleFire z:2];
		
		//Set up the particle emitter for the explosion
		_particleExplosion = [[CCParticleExplosion alloc] initWithTotalParticles:60];
		_particleExplosion.texture = [[CCTextureCache sharedTextureCache] addImage:@"explosionParticle.png"];
		_particleExplosion.startSpinVar = 300.0f;
		_particleExplosion.speed = 400.0f;
		_particleExplosion.speedVar = 200.0f;
		[_particleExplosion stopSystem];
		[self addChild:_particleExplosion z:2];
		
		//Explosion effect after mission complete
		megaexplosion = [CCParticleExplosion particleWithFile:@"megaexplosion.plist"];
		megaexplosion.position = ccp(winSize.width/2, winSize.height/2);
		[megaexplosion stopSystem];
		[self addChild:megaexplosion z:2];
		
		self._scoreLabel = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(50, 50) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
		_scoreLabel.position = ccp(winSize.width-_scoreLabel.contentSize.width/2, winSize.height-_scoreLabel.contentSize.height/2);
		_scoreLabel.color = ccWHITE;
        [self addChild:_scoreLabel z:3];
		
		_scoreTitle = [CCSprite spriteWithFile:@"score_title.png"];
		_scoreTitle.position = ccp(winSize.width-(_scoreTitle.contentSize.width*2), winSize.height-_scoreTitle.contentSize.height/2);
		[self addChild:_scoreTitle z:3];
		
		_ghost = [[NSMutableArray alloc]init];
		_knife = [[NSMutableArray alloc]init];
		_monsterKnife = [[NSMutableArray alloc]initWithCapacity:kNumMonsterBullet];
		_movableSprites = [[NSMutableArray alloc] init];
		_spacelifes = [[NSMutableArray alloc] initWithCapacity:kNumSpaceLife];
		
		gameOption = [[Options alloc]init];
		
		//Define Monster bullet
		for(int i=0; i<kNumMonsterBullet; ++i) {
			CannonBall *enemyBullet = [[CannonBall alloc] initWithFile:@"laser-bean.png"];
			[self addChild:enemyBullet z:2 tag:kTagMonsterBullet];
			[enemyBullet setPosition:ccp(-100,-100)];
			[_monsterKnife addObject:enemyBullet];
			[enemyBullet release];
		}
		//Define background spacelife
		for(int i=0; i<kNumSpaceLife; ++i) {
			CCSprite *spacelife = [CCSprite spriteWithFile:@"asteroid_med.png"];
			spacelife.visible = NO;
			[self addChild:spacelife];
			[_spacelifes addObject:spacelife];
		}
		
		[self reset];
        
        //Make a dark layer when game start
        _pauseLayer = [CCColorLayer layerWithColor: ccc4(0, 0, 0, 160) width: 480 height: 320];
		_pauseLayer.anchorPoint = ccp(0, 0);
		[self addChild: _pauseLayer z:5];
        
		[self gameBegin];
		
	}
	return self;
}

-(void) callEveryFrame:(ccTime)dt {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	//Activate the the meteor fire effect
	_particleFire.position = _meteor.position;
	
	for(CannonBall *b in _monsterKnife) {
		if(b.fired) {
			[b takeFire];
		}
	}
	//Monsters' Fire Attack
	for(Monster *m in _ghost) {
		if (self.spaceship.isDead) return;
		
		int canFire = (signed)(arc4random()%5); //Make each time only have 1/5 chance to fire!
		if(m.launched && canFire == 1)
			[m launchFire:self];
	}
	//Collision Attackers' Fire Attack
	for(CollisionAttacker *a in _ghost) {
		if (self.spaceship.isDead) return;
		
		int canFire = (signed)(arc4random()%3); //Make each time only have 1/3 chance to fire!
		if(a.launched && canFire == 1)
			[a launchFire:self];
	}
    
}

-(void) gameBegin {
	self.isTouchEnabled = YES;
	
	Tutorial *tt = [[Tutorial alloc]initWithText:@"Welcome to Galaxy Monkey on Fire! \n To begin playing, touch screen to shoot the enemy, also touch the battleplane and drag it around to avoid being hit by enemy or meteorite. Shoot down more enemies to score points and livel up!" theGame:self]; 
	[tt release];
}

-(void)startGame
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	self.isAccelerometerEnabled = YES;
	
    [self removeChild:_pauseLayer cleanup:YES];
	[self addSpaceshipToGame];
	
	//Add new background music
	[MusicHandler playBackgroundMusic];
	
	//Make Level start animation when new level load.
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	CCLabelBMFont *levelNum = [CCLabelBMFont labelWithString:delegate.curLevel._levelName fntFile:@"uifont2.fnt"];
	levelNum.position = ccp(winSize.width/2, winSize.height/2);
	[levelNum setOpacity:0];
	[self addChild:levelNum z:3];
	
	id doFade = [CCSequence actions:
				 [CCDelayTime actionWithDuration:0.2],[CCSpawn actions:[CCFadeIn actionWithDuration:0.4],[CCScaleTo actionWithDuration:0.4 scale:1.2],nil] ,[CCDelayTime actionWithDuration:0.2],[CCFadeOut actionWithDuration:0.4],nil];
	[levelNum runAction:doFade];
	
	//Make front-end background layer move animation
	id delayAnim = [CCDelayTime actionWithDuration:1.0];
	id moveLeftAnim = [CCMoveTo actionWithDuration:15 position:ccp(-_frontBg.contentSize.width+winSize.width, _frontBg.position.y)];
	[_frontBg runAction:[CCSequence actions:delayAnim, moveLeftAnim, nil]];
    
    //Launch the fire demon!
	[self addDemonToGame];
	
	//Create Pause and Sound Control Buttons
	[self drawPauseButtons];
	[self genBackground];
	[self scheduleUpdate];    
	[self schedule:@selector(callEveryFrame:)];
	[self schedule:@selector(gameLogic:) interval:enemyInterval];
	[self schedule:@selector(gameLogic2:) interval:attackerInterval];
	[self schedule:@selector(bulletCollisions:)];
	[self schedule:@selector(detectBomb:)];
	//[self schedule:@selector(repeatBackground) interval:1/100];
	[self schedule:@selector(startMeteor) interval:meteorInterval];
	[self schedule:@selector(detectDebrisColide) interval:.01];
	[self schedule:@selector(detectAttackerColide) interval:.01];
	[self schedule:@selector(checkIfSpaceshipIsHit)];
}

-(void)reset {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
    // Clear out any objects
    for (CCSprite *ghost in _ghost) {
        [self removeChild:ghost cleanup:YES];
    }
    [_ghost removeAllObjects];
	
    for (CCSprite *knife in _knife) {
        [self removeChild:knife cleanup:YES];
    }
    [_knife removeAllObjects];
    
    // Remove old bg if it exists
    if (_curBg != nil) {
        [self removeChild:_curBg cleanup:YES];
        self._curBg = nil;
    }
	
	//Set different space ship lives per level
	self.lives = STARTING_LIVES + self.difficulty;
	lastTimeEnemyLaunched = 0;
	enemyInterval = 1.0;
	attackerInterval = 6.0 - self.difficulty;
	meteorInterval = 8.0 - self.difficulty;
	
	//Set diffult bombs number
	self.bombDestroyAll = NO;
	self.canLaunchBomb =YES;
	self.bombs = STARTING_BOMBS + self.difficulty;
	
	//Setup the spaceship lives
	[self drawLives:self.lives];
	
	livesCount = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"X%d", self.lives] fntFile:@"hud_font.fnt"];
	livesCount.anchorPoint = ccp(0,0);
	livesCount.position = ccp((life.contentSize.width*self.lives)+15, winSize.height-25);
	livesCount.color = ccWHITE;
	[self addChild:livesCount z:3];
	
	//Show bombs number
	CCSprite *hudBomb = [CCSprite spriteWithFile:@"hud_live.png"];
	hudBomb.anchorPoint = ccp(0,0);
	hudBomb.position = ccp(hudBomb.contentSize.width, winSize.height-35);
	[self addChild:hudBomb z:3];
	
	bombsCount = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"X%d", self.bombs] fntFile:@"hud_font.fnt"];
	bombsCount.anchorPoint = ccp(0,0);
	bombsCount.position = ccp(hudBomb.contentSize.width+20, winSize.height-45);
	bombsCount.color = ccWHITE;
	[self addChild:bombsCount z:3];
	
    //Add new background per different level
	//_background = [CCSprite spriteWithFile:delegate.curLevel._bgImageName];
    //_background.anchorPoint = ccp(0,0);
    //[self addChild:_background z:-1];
	_frontBg = [CCSprite spriteWithFile:delegate.curLevel._frontBgName];
	_frontBg.anchorPoint = ccp(0,0);
	[self addChild:_frontBg z:1];
	
	_backgroundNode = [CCParallaxNode node];
	[self addChild:_backgroundNode z:-1];
	_spacedust1 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
	_spacedust2 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
	_planetsunrise = [CCSprite spriteWithFile:@"bg_planetsunrise.png"];
	_galaxy = [CCSprite spriteWithFile:@"bg_galaxy.png"];
	_spacialanomaly = [CCSprite spriteWithFile:@"bg_spacialanomaly.png"];
	_spacialanomaly2 = [CCSprite spriteWithFile:@"bg_spacialanomaly2.png"];
	_saturn = [CCSprite spriteWithFile:@"black_hole.png"];
	
	CGPoint dustSpeed = ccp(0.2, 0.2);
	CGPoint bgSpeed = ccp(0.05, 0.05);
	
	[_backgroundNode addChild:_spacedust1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(0, winSize.height/2)];
	[_backgroundNode addChild:_spacedust2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(_spacedust1.contentSize.width, winSize.height/2)];        
	[_backgroundNode addChild:_galaxy z:-1 parallaxRatio:bgSpeed positionOffset:ccp(0, winSize.height*0.7)];
	[_backgroundNode addChild:_planetsunrise z:-1 parallaxRatio:bgSpeed positionOffset:ccp(600, winSize.height*0.1)];        
	[_backgroundNode addChild:_spacialanomaly z:-1 parallaxRatio:bgSpeed positionOffset:ccp(900, winSize.height*0.5)];        
	[_backgroundNode addChild:_spacialanomaly2 z:-1 parallaxRatio:bgSpeed positionOffset:ccp(1500, winSize.height*0.8)];
	[_backgroundNode addChild:_saturn z:-1 parallaxRatio:bgSpeed positionOffset:ccp(1200, winSize.height*0.8)];
	
	//Adding particle stars to background
	NSArray *starsArray = [NSArray arrayWithObjects:@"Stars1.plist", @"Stars2.plist", @"Stars3.plist", nil];
	for(NSString *stars in starsArray) {        
		CCParticleSystemQuad *starsEffect = [CCParticleSystemQuad particleWithFile:stars];        
		[self addChild:starsEffect z:1];
	}
	
	//Show current Level
	CCLabelTTF *levelTitle = [CCLabelTTF labelWithString:@"Mission " dimensions:CGSizeMake(100, 50) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
	levelTitle.position = ccp(winSize.width/2-levelTitle.contentSize.width/2, winSize.height-levelTitle.contentSize.height/2);
	levelTitle.color = ccc3(255,255,255);
	[self addChild:levelTitle z:3];
	
	_curLevel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", delegate.curLevel._levelNum] dimensions:CGSizeMake(50, 50) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
	_curLevel.position = ccp(winSize.width/2, winSize.height-_curLevel.contentSize.height/2);
	_curLevel.color = ccc3(255,255,255);
	[self addChild:_curLevel z:3];
	
	// Store reference to current background so we can remove it on next reset
    self._curBg = _background;
    
    // Reset stats
    _knifesDestroyed = 0; //Reset destroyed ghost number to 0 when level up.
    self._nextKnife = nil;
	_score = 0; //Reset score to 0 when level up.
    _oldScore = -1;
	_mode = 1; //Set bullet button mode to 1 (fire) when start.
	
	_bulletOn = [[CCMenuItemImage itemFromNormalImage:@"projectile-button-on.png" selectedImage:@"projectile-button-on.png" target:nil selector:nil] retain];
	_bulletOff = [[CCMenuItemImage itemFromNormalImage:@"projectile-button-off.png" selectedImage:@"projectile-button-off.png" target:nil selector:nil] retain];
    CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self
														   selector:@selector(bulletButtonTapped:) items:_bulletOn, _bulletOff, nil];
	CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
	toggleMenu.position = ccp(80, 30);
	[self addChild:toggleMenu z:3];
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

-(void)update:(ccTime)dt {
    float PIXELS_PER_SECOND = 100;
    static float offset = 0;
    offset += PIXELS_PER_SECOND * dt;
    
    CGSize textureSize = _background.textureRect.size;
    [_background setTextureRect:CGRectMake(offset*0.7, 0, textureSize.width, textureSize.height)];
    
    
    CGPoint backgroundScrollVel = ccp(-1000, 0);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
	
	//Repeat background objects
	NSArray *spaceDusts = [NSArray arrayWithObjects:_spacedust1, _spacedust2, nil];
	for (CCSprite *spaceDust in spaceDusts) {
		if ([_backgroundNode convertToWorldSpace:spaceDust.position].x < -spaceDust.contentSize.width) {
			[_backgroundNode incrementOffset:ccp(2*spaceDust.contentSize.width,0) forChild:spaceDust];
		}
	}
	
	NSArray *backgrounds = [NSArray arrayWithObjects:_planetsunrise, _galaxy, _spacialanomaly, _spacialanomaly2, _saturn, nil];
	for (CCSprite *background in backgrounds) {
		if ([_backgroundNode convertToWorldSpace:background.position].x < -background.contentSize.width) {
			[_backgroundNode incrementOffset:ccp(2000,0) forChild:background];
		}
	}
	
	//Add the spacelife to game
	CGSize winSize = [CCDirector sharedDirector].winSize;
	double curTime = CACurrentMediaTime();
	if (curTime > _nextSpacelifeSpawn) {
		float randSecs = [self randomValueBetween:0.20 andValue:1.0];
		_nextSpacelifeSpawn = randSecs + curTime;
		
		float randY = [self randomValueBetween:0.0 andValue:winSize.height];
		float randDuration = [self randomValueBetween:2.0 andValue:10.0];
		float scaleSize = [self randomValueBetween:0.5 andValue:1.0];
		
		CCSprite *spacelife = [_spacelifes objectAtIndex:_nextSpacelife];
		_nextSpacelife++;
		if (_nextSpacelife >= _spacelifes.count) _nextSpacelife = 0;
		
		[spacelife stopAllActions];
		spacelife.position = ccp(winSize.width+spacelife.contentSize.width/2, randY);
		spacelife.visible = YES;
		[spacelife runAction:[CCSequence actions:
							  [CCScaleTo actionWithDuration:0 scale:scaleSize], 
							  [CCMoveBy actionWithDuration:randDuration position:ccp(-winSize.width-spacelife.contentSize.width, 0)],
							  [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
							  nil]];
	}
	
}

- (void)setInvisible:(CCNode *)node {
	node.visible = NO;
}

-(BOOL) isGameOver {
	return self.lives <= 0; 
}

-(void)addDemonToGame {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	if(self.demon != nil) 
	{
		[self removeChild:self.demon.sprite cleanup:YES];
		self.demon.sprite = nil;
	}
    self.demon = [[Demon alloc] initWithSpriteFileName1:@"flying-taco.png" currentLayer:self theGame:self];
	self.demon.sprite.position = ccp(winSize.width/2, winSize.height+demon.sprite.contentSize.height/2); 
	[self addChild:demon.sprite z:2];
	//[_ghost addObject:demon.sprite];
	[self.demon launch];
	
	//Call the 3 bullets Monster to game
	GameObject *enemy = [ObjectFactory enemy];
	float positionY = (signed)(arc4random() % (int)(winSize.height - 80)) + 40;
	enemy.position = ccp(winSize.width+50, positionY);
	//Make the monster move!
	CCAction *action = [ActionFactory moveByFrom:enemy.position degree:-180 speed:25];
	[enemy runAction:action];
	[self addChild:enemy z:2 tag:kTagAttacker];
	[_ghost addObject:enemy];
}

-(void) addSpaceshipToGame {
	if([self isGameOver]) {
		[self loadGameOver]; 
	}
	else {
		if(self.spaceship != nil) {
			[self removeChild:self.spaceship.sprite cleanup:YES];
			self.spaceship.sprite = nil;
		}
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		CGSize windowSize = [[CCDirector sharedDirector] winSize];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet.plist"];
		spaceSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spritesheet.png"];
        [self addChild:spaceSpriteSheet];
		//Load up the frames of our flying animation
        NSMutableArray *flyAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [flyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Spaceship_lg_%d.png", i]]];
        }
        CCAnimation *flyingAnim = [CCAnimation animationWithFrames:flyAnimFrames delay:0.1f];
		self.flyingAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flyingAnim restoreOriginalFrame:NO]];
		
		//Make space ship
		self.spaceship = [[Spaceship alloc] initWithSpriteFileName:@"Spaceship_lg_1.png" currentLayer:self theGame:self];
		spaceship.sprite.position = ccp(spaceship.sprite.contentSize.width/2, windowSize.height/2);
		
		//Give few seconds of immortality to the re-spawn spaceship
		[self.spaceship.sprite runAction:[CCBlink actionWithDuration:0.5 blinks:5]];
		//Spaceship flying animation
		[self.spaceship.sprite runAction:flyingAction];
		
		[_movableSprites addObject:spaceship.sprite];
		[spaceSpriteSheet addChild:spaceship.sprite z:2 tag:kTagHero];
		self.player = (GameObject *)self.spaceship.sprite;
	}
}

-(void) checkIfSpaceshipIsHit {
	if(self.spaceship.isImmortal || self.spaceship.isDead) return;
	
	CCNode *monsterBullet = [self getChildByTag:kTagMonsterBullet];
	
	// spaceship hit by a demon 
	if([collisionManager isCollided:self.demon.sprite objectUnderCollision:spaceship.sprite]) 
	{
		[self removeLifeByTag:self.lives];
		self.lives -= 1;
		[self.spaceship hit];
		[self performSelector:@selector(addSpaceshipToGame) withObject:nil afterDelay:1.0];
		[livesCount setString:[NSString stringWithFormat:@"X%d", self.lives]];
	} 
	else if ([collisionManager isCollided:self.demon.fireball objectUnderCollision:spaceship.sprite] 
			 || ([collisionManager isCollided:monsterBullet objectUnderCollision:spaceship.sprite]) ) 
	{
		[MusicHandler playDamageMusic];
		[monsterBullet reset];
		//You can change the hp number to make diferent extent of damage.
		self.spaceship.hp -= 1;
		[self.spaceship.sprite runAction:[CCSequence actions:
                                          [CCTintTo actionWithDuration:0.1 red:255 green:0 blue:0], 
                                          [CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255], nil]];
		if (self.spaceship.hp <= 0) {
			[self removeLifeByTag:self.lives];
			self.lives -= 1; 
			[self.spaceship hit];
			[self performSelector:@selector(addSpaceshipToGame) withObject:nil afterDelay:1.0];
			[livesCount setString:[NSString stringWithFormat:@"X%d", self.lives]];
			self.spaceship.hp = self.spaceship.maxHp;
		}
	}
}

-(void)checkIfDemonIsHit {	
	if(self.demon.isDead) return; 
	
	if(bombDestroyAll || [collisionManager isCollided:self.spaceship.laser objectUnderCollision:demon.sprite]) 
	{
		if (bombDestroyAll) { //Launch bomb!
			self.demon.hp = 0; //Kill the demon directly!
		} 
		else {
			self.demon.hp -= 1; //Let the laser gun have 5 attack point
			[self.demon.sprite runAction:[CCSequence actions:
										  [CCTintTo actionWithDuration:0.1 red:255 green:0 blue:0], 
										  [CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255], nil]];
			[MusicHandler playDemonHitMusic];
		}
		
		CGPoint enemyPos = CGPointZero;
		int bonusScore;
		bonusScore = self.demon.curScore; //bonus score feedback
		
		//Demon is dead
		if (self.demon.hp <= 0) {
			_score += self.demon.curScore;
			//Show the score feedback that granted for specific enemy. 
			enemyPos = ccp(enemyPos.x+demon.sprite.position.x, enemyPos.y+demon.sprite.position.y+demon.sprite.contentSize.height/2);
			CCLabelBMFont *feedTxt = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", bonusScore] fntFile:@"feedbackFont.fnt"];
			feedTxt.position = enemyPos;
			feedTxt.color = ccRED;
			[self addChild:feedTxt z:5];
			
			//Make bonus score label fade out
			float dTime =0;
			for(CCSprite *p in [feedTxt children]) 
			{
				[p runAction:[CCSequence actions:
							  [CCDelayTime actionWithDuration:1+(dTime/3)],
							  [CCMoveBy actionWithDuration:0.5 position:ccp(0,20)],
							  nil]];
				dTime++;
			}
			[feedTxt runAction:[CCSequence actions:
								[CCDelayTime actionWithDuration:0.5],
								[CCFadeOut actionWithDuration:1],
								[CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
								nil]];
			[self.demon hit];
		}
		//update score only when it changes for efficiency
		if (_score != _oldScore) {
			_oldScore = _score;
			[_scoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
		}
		//Relaunch demon to game
		[self performSelector:@selector(addDemonToGame) withObject:nil afterDelay:5.0];
	}
}

//Remove one spaceshp live pic
-(void)removeLifeByTag:(int)liveTag {
	if(liveTag > 0) {
		NSLog(@"removeLifeByTag tag = %d",liveTag);
		[self removeChildByTag:liveTag cleanup:YES];
	}
}

//Draw the spaceship lives pics
-(void)drawLives:(int)newLive {
	int x = 0;
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	for (int i=1; i<=newLive; i++) {
		life = [CCSprite spriteWithFile:@"heart.png"];
		[life setTag:i];
		life.position = ccp(x+life.contentSize.width,winSize.height-life.contentSize.height/2); 
		[self addChild:life z:2];
		x = x + life.contentSize.width; 
	}
}

-(void)explodeBomb {
	self.canLaunchBomb = NO;
	self.bombs--;
	[bombsCount setString:[NSString stringWithFormat:@"X%d",self.bombs]];
	
	[MusicHandler playHugeExplosionMusic];
	[megaexplosion resetSystem];
	
	CCParticleExplosion *explosion = [CCParticleExplosion node];
	explosion.texture = [[CCTextureCache sharedTextureCache] addImage: @"explosionParticle.png"];
	explosion.autoRemoveOnFinish = YES;
	explosion.position = ccp(240, 160);
	explosion.speed = 200;
	[self addChild:explosion z:5];
	
	self.bombDestroyAll = YES;
	
	[self schedule:@selector(allowBombs) interval:2];
}

-(void)allowBombs {
	[self unschedule:@selector(allowBombs)];
	self.canLaunchBomb = YES;
	self.bombDestroyAll = NO;
}

-(void)detectBomb:(ccTime)dt {
	CGPoint enemyPos = CGPointZero;
	int bonusScore;
	
	NSMutableArray *ghostsToDelete = [[NSMutableArray alloc]init];
	for (CCSprite *ghost in _ghost) {
		if (bombDestroyAll) {
			Monster *monster = (Monster *)ghost;
			bonusScore = monster.curScore; //bonus score feedback
			monster.hp = 0;
			[monster runAction:[CCSequence actions:
								[CCTintTo actionWithDuration:0.1 red:255 green:0 blue:0], 
								[CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255], nil]];
			if (monster.launched && monster.hp <= 0) {
				monster.launched = NO;
				_score += monster.curScore;
				[ghostsToDelete addObject:ghost];
			}
			break;
			
			CollisionAttacker *attacker = (CollisionAttacker *)ghost;
			bonusScore = attacker.curScore; //bonus score feedback
			attacker.hp = 0;
			if (attacker.launched && attacker.hp <= 0) {
				attacker.launched = NO;
				_score += attacker.curScore;
				[ghostsToDelete addObject:ghost];
			}
			break;
			
			GameObject *evil = (GameObject *)ghost;
			bonusScore = evil.curScore; //bonus score feedback
			evil.hp = 0;
			NSLog(@"Evil HP = %d", evil.hp);
			if (evil.launched && evil.hp <= 0) {
				evil.launched = NO;
				_score += evil.curScore;
				[ghostsToDelete addObject:ghost];
			}
			break;
		}
	}
	
	for (CCSprite *ghost in ghostsToDelete) {
		[ghost stopAllActions];
		[_ghost removeObject:ghost];
		
		//Show the score feedback that granted for specific enemy. 
		//Showing these encouraging messages are very important in a game, 
		//because they make the player feel rewarded for his ability, thus making him want to keep playing.
		enemyPos = ccp(enemyPos.x+ghost.position.x, enemyPos.y+ghost.position.y+ghost.contentSize.height/2);
		CCLabelBMFont *feedTxt = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", bonusScore] fntFile:@"feedbackFont.fnt"];
		feedTxt.position = enemyPos;
		feedTxt.color = ccRED;
		[self addChild:feedTxt z:5];
		
		//Make bonus score label fade out
		float dTime = 0;
		for(CCSprite *p in [feedTxt children]) 
		{
			[p runAction:[CCSequence actions:
						  [CCDelayTime actionWithDuration:1+(dTime/3)],
						  [CCMoveBy actionWithDuration:0.5 position:ccp(0,20)],
						  nil]];
			dTime++;
		}
		[feedTxt runAction:[CCSequence actions:
							[CCDelayTime actionWithDuration:0.5],
							[CCFadeOut actionWithDuration:1],
							[CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
							nil]];
		//The explode is used to call the explode animation method 
		id explode1 = [CCCallFuncN actionWithTarget:self selector:@selector(attackerExplosion:)];
		id explode2 = [CCCallFuncN actionWithTarget:self selector:@selector(monsterExplosion:)];
		id disappear = [CCFadeTo actionWithDuration:.5 opacity:0];
		id actionMoveDown = [CCCallFuncN actionWithTarget:self selector:@selector(targetHit:)];
		
		//Check if you hit the monster or attacker
		if (ghost.tag == kTagAttacker) {
			[MusicHandler playExplosion3Music];
			[ghost runAction:[CCSequence actions:explode1, disappear, actionMoveDown, nil]];
		} else if (ghost.tag == kTagGhost) {
			[MusicHandler playMonsterHitMusic];
			[ghost runAction:[CCSequence actions:explode2, disappear, actionMoveDown, nil]];
		}
		
		//Reach the score, Level complete! go to next level.
		AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		if (_score > (delegate.curLevel._levelScore * self.difficulty)) {
			[self removeChild:ghost cleanup:YES];
			[_ghost removeObject:ghost];
			[self runAction:[CCCallFuncN actionWithTarget:self selector:@selector(curMissionDone:)]];
		}
	}
	[ghostsToDelete release];
	
	//update score only when it changes for efficiency
	if (_score != _oldScore) {
		_oldScore = _score;
		[_scoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
	}
}	

-(void)repeatBackground {
	static float bk_f=0.0f;
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	bk_f -=1.0; //Move the bg image left per 1/60 interval.
	if (bk_f <= winSize.width-_background.contentSize.width) {bk_f=0;}
	_background.position = ccp(bk_f, 0);
}

//mode 0 = moving mode
//mode 1 = fire mode
- (void)bulletButtonTapped:(id)sender
{
	[MusicHandler playButtonClick];
	
	if (_mode == 1) {
		_mode = 0;
	} else {
		_mode = 1;
	}
}

//Load Game Over Scene
-(void)loadGameOver {
	[MusicHandler pauseBackgroundMusic];
	
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate loadGameOverScene];
}

//Make fire animation after monster killed
-(void)monsterExplosion:(id)sender {
	CCNode *target = (CCNode *)sender;
	
	CCParticleFire *explosion = [[CCParticleFire alloc] init]; 
	[explosion setTotalParticles:10];
	[explosion setAutoRemoveOnFinish:YES];
	[explosion setLife:5];
	[explosion setDuration:1];
	[explosion setEndSize:-1];
	
	explosion.position = target.position;
	[self addChild:explosion z:3];
}

//Make explode animation after attacker killed
-(void)attackerExplosion:(id)sender {
	CCNode *target = (CCNode *)sender;
	
	CCParticleSystemQuad *explosionRing = [CCParticleSystemQuad particleWithFile:@"ExplodingRing.plist"]; 
	[explosionRing setAutoRemoveOnFinish:YES];
	
	explosionRing.position = target.position;
	[self addChild:explosionRing z:3];
}

-(void)attackerExplosion2:(id)sender {
	
	CCNode *target = (CCNode *)sender;
	
	//[[SimpleAudioEngine sharedEngine] playEffect:@"huge-explosion.caf"];
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"explosionC.plist"];
	_spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"explosionC.png"];
	[self addChild:_spriteSheet z:3];
	// Load up the frames of our animation
	NSMutableArray *explodeAnimFrames = [NSMutableArray array];
	for(int i = 1; i <= 6; ++i) {
		[explodeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
									  [NSString stringWithFormat:@"explosionC%d.png", i]]];
	}
	CCAnimation *Anim = [CCAnimation animationWithFrames:explodeAnimFrames delay:0.1f];
	//Make Explosion Anim SpriteSheet
	id doExplode = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:Anim restoreOriginalFrame:NO] times:1];
	id explodeDisappear = [CCFadeTo actionWithDuration:.1 opacity:0];
	id actionExplodeDown = [CCCallFuncN actionWithTarget:self selector:@selector(explodeFinished:)];
	//_explodeAction is CCAction object which combined above explode action.
	self._explodeAction = [CCSequence actions:doExplode, explodeDisappear, actionExplodeDown, nil];
	self._explode = [CCSprite spriteWithSpriteFrameName:@"explosionC1.png"]; 
	[_spriteSheet addChild:_explode];
	_explode.position = ccp(target.position.x,target.position.y);
	[_explode runAction:_explodeAction];
}

-(void)explodeFinished:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[_spriteSheet removeChild:sprite cleanup:YES];
	[self removeChild:_spriteSheet cleanup:YES];
}

//Detect the Attacker object collision with the hero.
-(void) detectAttackerColide {
	CCNode *attacker = [self getChildByTag:kTagAttacker];
	//CCNode *hero = [self getChildByTag:kTagHero];
	
	float xDif = attacker.position.x - spaceship.sprite.position.x;
	float yDif = attacker.position.y - spaceship.sprite.position.y;
	float distance = sqrt(xDif * xDif + yDif * yDif);
	NSLog(@"Distance between Attacker and Spaceship = %d", distance);
	
	if (distance < 40) {
		[_ghost removeObject:attacker];
		NSLog(@"Attacker Collide!!!");
		
		id disappear = [CCFadeTo actionWithDuration:.5 opacity:0];
		id actionMoveDown = [CCCallFuncN actionWithTarget:self selector:@selector(targetHit:)];
		[attacker runAction:[CCSequence actions:disappear, actionMoveDown, nil]];
		
		if(self.spaceship.isImmortal || self.spaceship.isDead) return;
		self.isTouchEnabled = NO;
		self.isAccelerometerEnabled = NO;
		
		[self removeLifeByTag:self.lives];
		self.lives -= 1;
		[self.spaceship hit];
		[self performSelector:@selector(addSpaceshipToGame) withObject:nil afterDelay:1.0];
		[livesCount setString:[NSString stringWithFormat:@"X%d", self.lives]];
	}
}

//Detect the Attacker object collision with the hero.
-(void) detectDebrisColide {
	if(self.spaceship.isImmortal || self.spaceship.isDead) return; 
	
	CCNode *spaceDebris = [self getChildByTag:kTagDebris];
	//CCNode *hero = [self getChildByTag:kTagHero];
	
	float xDif = spaceDebris.position.x - spaceship.sprite.position.x;
	float yDif = spaceDebris.position.y - spaceship.sprite.position.y;
	float distance = sqrt(xDif * xDif + yDif * yDif);
	NSLog(@"distance = %d", distance);
    
	if (distance < 37) {
		self.isTouchEnabled = NO;
		self.isAccelerometerEnabled = NO;
		
		//Make meteor disappear
		[spaceDebris runAction:[CCFadeTo actionWithDuration:.5 opacity:0]];
		
		[self removeLifeByTag:self.lives];
		self.lives -= 1;
		[self.spaceship hit];
		[self performSelector:@selector(addSpaceshipToGame) withObject:nil afterDelay:1.0];
		[livesCount setString:[NSString stringWithFormat:@"X%d", self.lives]];
	}
}

-(void)deschedule:(id)sender {
	//Stop all schedule actions when hero die
	[self unschedule:@selector(gameLogic:)];
	[self unschedule:@selector(gameLogic2:)];
	[self unschedule:@selector(detectAttackerColide)];
	[self unschedule:@selector(detectDebrisColide)];
	[self unschedule:@selector(bulletCollisions:)];
}

//Positions the explosion emitter and sets it off
- (void)startExplosion {
	_particleExplosion.position = _meteor.position;
	[_particleExplosion resetSystem];
	[MusicHandler playMeteorExplodeMusic];
}

//Add Space debris to attack hero, like fire meteor.
- (void)startMeteor {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[_particleFire resetSystem];
	
	//Create and add the fire meteor sprite
	_spaceDebris = [[NSMutableArray alloc]init];
	_meteor = [CCSprite spriteWithFile:@"meteor.png"];
	_meteor.position = ccp(-_meteor.contentSize.width, winSize.height + _meteor.contentSize.height);
	[self addChild:_meteor z:2 tag:kTagDebris];
	[_spaceDebris addObject:_meteor];
	
	//Make sure the meteor is fully visible and normal size
	_meteor.opacity = 255;
	_meteor.scale = 1.0f;
	
	//Move the meteor to a random position somewhere across the top of the screen
	float meteorStartX = [self randomValueBetween:0.0 andValue:1.0] * winSize.width;
	float meteorStartY = winSize.height + _meteor.contentSize.height*0.5f;
	_meteor.position = ccp(meteorStartX, meteorStartY);
	
	//Generate a random position to move to on the bottom of the screen
	float meteorEndX = [self randomValueBetween:0.0 andValue:1.0] * winSize.width;
	//Generate a random number between -360 and 360
	float spinAmount = [self randomValueBetween:0.0 andValue:1.0] * 720.0f - 360.0f;
	
	CGPoint meteorEndPoint = ccp(meteorEndX, -_meteor.contentSize.height*0.5f);
	
	CCMoveTo *meteorMove = [CCMoveTo actionWithDuration:1.0f position:meteorEndPoint];
	CCCallFunc *emitter = [CCCallFunc actionWithTarget:self selector:@selector(startExplosion)];
	CCFadeOut *meteorFadeOut = [CCFadeOut actionWithDuration:0.2f];
	CCScaleTo *scaleOrigSize = [CCScaleTo actionWithDuration:0.2f scale:2.0f];
	CCRotateBy *meteorSpin = [CCRotateBy actionWithDuration:1.0f angle:spinAmount];
	CCRepeat *repeatSpin = [CCRepeat actionWithAction:meteorSpin times:1];
	
	//Compose the meteorMove and repeatSpin actions
	CCSpawn *meteorFall = [CCSpawn actions:repeatSpin, meteorMove, nil];
	//Compose the fade and scaleOrigSize actions
	CCSpawn *explode = [CCSpawn actions:meteorFadeOut, scaleOrigSize, nil];
	//Make the meteor fall, and then explode
	CCCallFunc *ceaseFire = [CCCallFunc actionWithTarget:self selector:@selector(stopParticleFire)];
	CCCallFuncN *moveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	CCSequence *doMeteorAnim = [CCSequence actions:meteorFall, emitter, explode, ceaseFire, moveDone, nil];
	
	[_meteor runAction:doMeteorAnim];
	
	//If we turned off the fire trail, turn it back on
	if (!(_particleFire.active)) {
		[_particleFire resetSystem];
	}
}


-(void)stopParticleFire {
	[_particleFire stopSystem];
}

- (void)animateAttacker:(CCSprite*)attacker
{
	//Move speed of the attacker
	ccTime actualDuration = 0.1;
	
	// Create the actions
	id actionMove = [CCMoveBy actionWithDuration:actualDuration position:ccpMult(ccpNormalize(ccpSub(spaceship.sprite.position,attacker.position)), 10)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(attackerMoveFinished:)];
	[attacker runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)attackerMoveFinished:(id)sender {
	CCSprite *attacker = (CCSprite *)sender;
	CGPoint diff = ccpSub(spaceship.sprite.position, attacker.position);
	float angleRadians = atanf((float)diff.y / (float)diff.x);
	float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
	float cocosAngle = -1 * angleDegrees;
	if (diff.x < 0) {
		cocosAngle += 180;
	}
	attacker.rotation = cocosAngle;
	[self animateAttacker: attacker];
}

-(void)addAttacker {
	CGSize winSize = [[CCDirector sharedDirector]winSize];
	_attacker = nil;
	if ((signed)(arc4random()%5) == 0) {
		_attacker = [AGSystems attacker];
	} else if ((signed)(arc4random()%5) == 1) {
		_attacker = [AuricomResearch attacker];
	} else if ((signed)(arc4random()%5) == 2) {
		_attacker = [FEISAR attacker];
	} else if ((signed)(arc4random()%5) == 3) {
		_attacker = [PirhanaAdvancements attacker];
	} else if ((signed)(arc4random()%5) == 4) {
		_attacker = [QirexRD attacker];
	}
	int minY = _attacker.contentSize.height/2;
	int maxY = winSize.height/2;
	int rangeY = maxY - minY;
	//The actual virtical distance between ghosts
	int actualY = (arc4random()%rangeY) + minY;
	
	//The start position of different ghost
	_attacker.position = ccp(winSize.width + (_attacker.contentSize.width/2), actualY);
	[self addChild:_attacker z:1 tag:kTagAttacker];
	[_ghost addObject:_attacker];
	[self animateAttacker:_attacker];
}

-(void)addGhost {
	CGSize winSize = [[CCDirector sharedDirector]winSize];
	//This will give a same chance to spawn each type of monster.
	_moveGhost = nil;
	if ((signed)(arc4random()%3) == 0) {
		_moveGhost = [WeakAndFastMonster monster];
	} else if ((signed)(arc4random()%3 == 1)) {
		_moveGhost = [StrongAndSlowMonster monster];
	} else if ((signed)(arc4random()%3 == 2)) {
		_moveGhost = [StrongAndFastMonster monster];
	}
	
	int minY = _moveGhost.contentSize.height/2;
	int maxY = winSize.height/2;
	int rangeY = maxY - minY;
	//The actual virtical distance between ghosts
	int actualY = (arc4random()%rangeY) + minY;
	
	//The start position of different ghost
	_moveGhost.position = ccp(winSize.width + (_moveGhost.contentSize.width/2), actualY);
	[self addChild:_moveGhost z:1 tag:kTagGhost];
	[_ghost addObject:_moveGhost];
	
	int minDuration = _moveGhost.minMoveDuration;
	int maxDuration = _moveGhost.maxMoveDuration;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = ((signed)(arc4random()%rangeDuration) + minDuration) - self.difficulty;
	
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-_moveGhost.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[_moveGhost runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)spriteMoveFinished:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	
	if (sprite.tag == kTagGhost) {
		[_ghost removeObject:sprite];
		[self removeChild:sprite cleanup:YES];
        //[self runAction:[CCCallFuncN actionWithTarget:self selector:@selector(deschedule:)]];
		//[self runAction:[CCCallFuncN actionWithTarget:self selector:@selector(loadGameOver)]];
	}else if (sprite.tag == kTagKnife) {
		[_knife removeObject:sprite];
		[sprite removeFromParentAndCleanup:YES];
	}else if (sprite.tag == kTagDebris) {
		[_ghost removeObject:sprite];
	}
}

-(void)gameLogic:(ccTime)dt {
	static double lastTimeTargetAdded = 0;
	double now = [[NSDate date] timeIntervalSince1970];
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if(lastTimeTargetAdded == 0 || now - lastTimeTargetAdded >= delegate.curLevel._spawnRate) {
		[self addGhost];
		lastTimeTargetAdded = now;
	}
}

-(void)gameLogic2:(ccTime)dt {
	static double lastTimeTargetAdded = 0;
	double now = [[NSDate date] timeIntervalSince1970];
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if(lastTimeTargetAdded == 0 || now - lastTimeTargetAdded >= delegate.curLevel._spawnRate) {
		[self addAttacker];
		lastTimeTargetAdded = now;
	}
}

-(CGRect)myRect:(CCSprite *)sp
{
	CGRect rect = CGRectMake(sp.position.x-sp.contentSize.width/2, 
							 sp.position.y-sp.textureRect.size.height/2, 
							 sp.contentSize.width, 
							 sp.contentSize.height);
	return rect;
}

//collision detection with bullet and monster
-(void)bulletCollisions:(ccTime)dt {
	
	NSMutableArray *knifesToDelete = [[NSMutableArray alloc]init];
	for (CannonBall *knife in _knife) {
		CGRect knifeRect = [self myRect:knife];
		
		BOOL monsterHit = FALSE;
		CGPoint enemyPos = CGPointZero;
		int bonusScore;
		
		NSMutableArray *ghostsToDelete = [[NSMutableArray alloc]init];
		for (CCSprite *ghost in _ghost) {
			CGRect ghostRect = [self myRect:ghost];
			
			if (CGRectIntersectsRect(knifeRect, ghostRect)) {
				if (![knife shouldDamageMonster:ghost]) continue;
				monsterHit = TRUE;
				Monster *monster = (Monster *)ghost;
				bonusScore = monster.curScore; //bonus score feedback
				monster.hp--;
				NSLog(@"Monster HP: %d", monster.hp);
				[monster runAction:[CCSequence actions:
									[CCTintTo actionWithDuration:0.1 red:255 green:0 blue:0], 
									[CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255], nil]];
				if (monster.launched && monster.hp <= 0) {
					monster.launched = NO;
					_score += monster.curScore;
					[ghostsToDelete addObject:ghost];
				}
				break;
				
				CollisionAttacker *attacker = (CollisionAttacker *)ghost;
				bonusScore = attacker.curScore; //bonus score feedback
				attacker.hp--;
				if (attacker.launched && attacker.hp <= 0) {
					attacker.launched = NO;
					_score += attacker.curScore;
					[ghostsToDelete addObject:ghost];
				}
				break;
				
				GameObject *evil = (GameObject *)ghost;
				bonusScore = evil.curScore; //bonus score feedback
				evil.hp--;
				if (evil.launched && evil.hp <= 0) {
					evil.launched = NO;
					_score += evil.curScore;
					[ghostsToDelete addObject:evil];
				}
				break;
			}
		}
		
		for (CCSprite *ghost in ghostsToDelete) {
			[ghost stopAllActions];
			[_ghost removeObject:ghost];
			
			//Show the score feedback that granted for specific enemy. 
			//Showing these encouraging messages are very important in a game, 
			//because they make the player feel rewarded for his ability, thus making him want to keep playing.
			enemyPos = ccp(enemyPos.x+ghost.position.x, enemyPos.y+ghost.position.y+ghost.contentSize.height/2);
			CCLabelBMFont *feedTxt = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", bonusScore] fntFile:@"feedbackFont.fnt"];
			feedTxt.position = enemyPos;
			feedTxt.color = ccRED;
			[self addChild:feedTxt z:5];
			
			//Make bonus score label fade out
			float dTime = 0;
			for(CCSprite *p in [feedTxt children]) {
				[p runAction:[CCSequence actions:
							  [CCDelayTime actionWithDuration:1+(dTime/3)],
							  [CCMoveBy actionWithDuration:0.5 position:ccp(0,20)],
							  nil]];
				dTime++;
			}
			[feedTxt runAction:[CCSequence actions:
								[CCDelayTime actionWithDuration:0.5],
								[CCFadeOut actionWithDuration:1],
								[CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
								nil]];
			//The explode is used to call the explode animation method 
			id explode1 = [CCCallFuncN actionWithTarget:self selector:@selector(attackerExplosion:)];
			id explode2 = [CCCallFuncN actionWithTarget:self selector:@selector(monsterExplosion:)];
			id disappear = [CCFadeTo actionWithDuration:.5 opacity:0];
			id actionMoveDown = [CCCallFuncN actionWithTarget:self selector:@selector(targetHit:)];
			
			//Check if you hit the monster or attacker
			if (ghost.tag == kTagAttacker) {
				[MusicHandler playAttackerHitMusic];
				[ghost runAction:[CCSequence actions:explode1, disappear, actionMoveDown, nil]];
			} else if (ghost.tag == kTagGhost) {
				[MusicHandler playMonsterHitMusic];
				[ghost runAction:[CCSequence actions:explode2, disappear, actionMoveDown, nil]];
			}
			_knifesDestroyed++;
			
			//Reach the score, Level complete! go to next level.
			AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			if (_score > delegate.curLevel._levelScore) {
				[self removeChild:ghost cleanup:YES];
				[_ghost removeObject:ghost];
				[self runAction:[CCCallFuncN actionWithTarget:self selector:@selector(curMissionDone:)]];
			}
		}
		if (monsterHit) {
			[knifesToDelete addObject:knife];
			[MusicHandler playDamageMusic];
		}
		[ghostsToDelete release];
		
	}
	
	for (CCSprite *knife in knifesToDelete) {
		[_knife removeObject:knife];
		//[spaceSpriteSheet removeChild:knife cleanup:YES];
		//Use the same method below instead to clean spritesheet image!
		[knife removeFromParentAndCleanup:YES];
	}
	[knifesToDelete release];
	
	//update score only when it changes for efficiency
	if (_score != _oldScore) {
		_oldScore = _score;
		[_scoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
	}
	
}

//Make animation after current mission complete
- (void)curMissionDone:(id)sender {
    
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	self.isTouchEnabled = NO;
	self.isAccelerometerEnabled = NO;
	self.spaceship.isImmortal = YES;
	
	[self stopAllActions];
	[self runAction:[CCCallFuncN actionWithTarget:self selector:@selector(deschedule:)]];
	
	//Space ship flight away animation.
	id moveToMiddle = [CCSpawn actions:
					   [CCMoveTo actionWithDuration:.5 position:ccp(spaceship.sprite.position.x, winSize.height/2)], 
					   [CCRotateTo actionWithDuration:.5 angle:0], 
					   nil];
	id flightAway = [CCEaseInOut actionWithAction:
					 [CCMoveTo actionWithDuration:2 position:ccp(winSize.width+spaceship.sprite.contentSize.width, winSize.height/2)] rate:5];
	
	[spaceship.sprite runAction:[CCSequence actions:moveToMiddle, flightAway, nil]];
	
	//Play Level Up sound effect
	[MusicHandler playMissionDoneMusic];
	
	//Make Level Up animation when current level complete.
	CCSprite *levelUpSprite = [CCSprite spriteWithFile:@"level-up.png" rect:CGRectMake(0, 0, 101, 57)];
	levelUpSprite.position = ccp(winSize.width/2, winSize.height+levelUpSprite.contentSize.height/2);
	[self addChild:levelUpSprite z:10];
	
	id moveDown = [CCEaseInOut actionWithAction:
				   [CCMoveTo actionWithDuration:1.0 position:ccp(winSize.width/2, winSize.height/2)] rate:5];
	id doFade = [CCSequence actions:
				 [CCFadeTo actionWithDuration:.5 opacity:255],
				 [CCFadeTo actionWithDuration:.5 opacity:0],nil];
	id levelDone = [CCCallFunc actionWithTarget:self selector:@selector(missionDone:)];
	
	[levelUpSprite runAction:[CCSequence actions:moveDown, doFade, levelDone, nil]];
	
}

//Process Game Logic after current mission complete
-(void)missionDone:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	
	[MusicHandler pauseBackgroundMusic];
	
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate levelComplete];
}

-(void)targetHit:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
}

-(void)selectSpriteForTouch:(CGPoint)touchLocation {
	CCSprite *newSprite = nil;
	for (CCSprite *sprite in _movableSprites) {
		if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
			newSprite = sprite;
			break;
		}
	}
	if (newSprite != _selSprite) {
		[_selSprite stopAllActions];
		[_selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0.0]];
		CCRotateTo *rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
		CCRotateTo *rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
		CCRotateTo *rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
		CCSequence *rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
		[newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
		_selSprite = newSprite;
	}
}

-(void)panForTranslation:(CGPoint)translation {
	if (_selSprite) {
		CGPoint newPos = ccpAdd(_selSprite.position, translation);
		_selSprite.position = newPos;
	}
}

-(void)drawPauseButtons {
	CCMenuItemImage *pause = [CCMenuItemImage itemFromNormalImage:@"pause-button.png" selectedImage:@"pause-button.png" target:self selector:@selector(pauseGame:)];
	_pauseButton = [CCMenu menuWithItems:pause, nil];
	_pauseButton.position = ccp(20, 20);
	[self addChild:_pauseButton z:7];
}

-(void)drawSoundButtons {
	CCMenuItemImage *sound = [CCMenuItemImage itemFromNormalImage:@"sound-button-on.png" selectedImage:@"sound-button-on.png" target:self selector:@selector(soundSlider:)];
	_soundButton = [CCMenu menuWithItems:sound, nil];
	_soundButton.position = ccp(460, 20);
	[self addChild:_soundButton z:10];
}

-(void)soundSlider:(id)sender {
	if (self.ssClicked) return;
	self.ssClicked = YES;
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	ssBack = [CCSprite spriteWithFile:@"soundSlidersBack.png"];
	ssBack.position = ccp(winSize.width/2, winSize.height/2);
	[self addChild:ssBack z:11];
	
	musicVolumeTitle = [CCLabelTTF labelWithString:@"Volume Control" fontName:@"Marker Felt" fontSize:26];
	musicVolumeTitle.position = ccp(240,200);
	musicVolumeTitle.color = ccWHITE;
	[self addChild:musicVolumeTitle z:12];
	
	//Change Music Volume
	musicBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onMusicClick:) items:
				[CCMenuItemImage itemFromNormalImage:@"music_button.png" selectedImage:@"music_button_down.png"],
				[CCMenuItemImage itemFromNormalImage:@"music_button_down.png" selectedImage:@"music_button.png"],
				nil];
	musicBtn.position = ccp(winSize.width/2 - 135, winSize.height/2);
	
	// Sound on/off button
	soundBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundClick:) items:
				[CCMenuItemImage itemFromNormalImage:@"sound_button.png" selectedImage:@"sound_button_down.png"],
				[CCMenuItemImage itemFromNormalImage:@"sound_button_down.png" selectedImage:@"sound_button.png"],
				nil];
	soundBtn.position = ccp(winSize.width/2 - 135, winSize.height/2 - 40);
	
	SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
	
	// Music Slider
	self.musicSlider = [CCMenuItemSlider itemFromTrackImage: @"slider-bar-white.png" knobImage: @"slider-btn.png" target:self selector: @selector(onMusicSlide:)];
	self.musicSlider.minValue = 0;
	self.musicSlider.maxValue = 100;
	self.musicSlider.value = floor(sae.backgroundMusicVolume * 100);
	self.musicSlider.position = ccp(winSize.width/2 + 45, winSize.height/2);
	
	// Sound Effect Slider
	self.soundSlider = [CCMenuItemSlider itemFromTrackImage: @"slider-bar-white.png" knobImage: @"slider-btn.png" target:self selector: @selector(onSoundSlide:)];
	self.soundSlider.minValue = 0;
	self.soundSlider.maxValue = 100;
	self.soundSlider.value = floor(sae.effectsVolume * 100);
	self.soundSlider.position = ccp(winSize.width/2 + 45, winSize.height/2 - 40);
	
	gritterClose = [CCMenuItemImage itemFromNormalImage:@"gritter-close.png" selectedImage:@"gritter-close.png" target:self selector:@selector(onBackClick:)];
	gritterClose.position = ccp(420, 230);
	
	ssMenu = [CCMenu menuWithItems:musicBtn, self.musicSlider, soundBtn, self.soundSlider, gritterClose, nil];
	ssMenu.position = ccp(0,0);
	[self addChild:ssMenu z:12];
}

- (void)onMusicSlide:(id)sender {
    CCMenuItemSlider *slider = (CCMenuItemSlider*)sender;
	[SimpleAudioEngine sharedEngine].backgroundMusicVolume = (slider.value / 100.0);
}

- (void)onMusicClick:(id)sender {
	[MusicHandler playButtonClick];
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([sender selectedIndex] == 1) {
		[usrDef setBool:NO forKey:@"music"];
		self.prevMusicLevel = self.musicSlider.value;
		self.musicSlider.value = 0;
		[SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
	}
	else {
		[usrDef setBool:YES forKey:@"music"];
		self.musicSlider.value = self.prevMusicLevel;
		[SimpleAudioEngine sharedEngine].backgroundMusicVolume = (self.prevMusicLevel / 100.0);
	}
}

- (void)onSoundSlide:(id)sender {
    CCMenuItemSlider* slider = (CCMenuItemSlider*)sender;
	[SimpleAudioEngine sharedEngine].effectsVolume = (slider.value / 100.0);
}

- (void)onSoundClick:(id)sender {
	[MusicHandler playButtonClick];
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([sender selectedIndex] == 1) {
		[usrDef setBool:NO forKey:@"sound"];
		self.prevSoundLevel = self.soundSlider.value;
		self.soundSlider.value = 0;
		[SimpleAudioEngine sharedEngine].effectsVolume = 0;
	}
	else {
		[usrDef setBool:YES forKey:@"sound"];
		self.soundSlider.value = self.prevSoundLevel;
		[SimpleAudioEngine sharedEngine].effectsVolume = (self.prevSoundLevel / 100.0);
	}
}

- (void)onBackClick:(id)sender {
	self.ssClicked = NO;
	[MusicHandler playButtonClick];
	[self removeChild:ssBack cleanup:YES];
	[self removeChild:ssMenu cleanup:YES];
	[self removeChild:musicVolumeTitle cleanup:YES];
}

-(void)drawResumeButtons {
	CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage:@"play-button.png" selectedImage:@"play-button.png" target:self selector:@selector(resumeGame:)];
	_playButton = [CCMenu menuWithItems:play, nil];
	_playButton.position = ccp(20, 20);
	[self addChild:_playButton z:10];
}

-(void)pauseGame:(id)sender {
	[MusicHandler playButtonClick];
	BOOL isPaused = [[CCDirector sharedDirector] isPaused];
	if (!isPaused) {
		self.isTouchEnabled = NO;
		self.isAccelerometerEnabled = NO;
		
		[MusicHandler pauseBackgroundMusic];
		[[CCDirector sharedDirector] pause];
		
		_pauseLayer = [CCColorLayer layerWithColor: ccc4(0, 0, 0, 200) width: 480 height: 320];
		_pauseLayer.anchorPoint = ccp(0, 0);
		[self addChild: _pauseLayer z:8];
		
		_minda = [CCSprite spriteWithFile:@"Midna_Angry_3.png"];
        _minda.position = ccp(350,150);
        [self addChild:_minda z:10];
		
		_spacemanPause = [CCSprite spriteWithFile:@"spaceman2.png"];
        _spacemanPause.position = ccp(_spacemanPause.contentSize.width/2, _spacemanPause.contentSize.height/2);
        [self addChild:_spacemanPause z:10];
        
        _pausedTitle = [CCLabelTTF labelWithString:@"Game Paused" fontName:@"Marker Felt" fontSize:40];
        _pausedTitle.position = ccp(240,260);
		_pausedTitle.color = ccORANGE;
        [self addChild:_pausedTitle z:10];
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:30];
        CCMenuItem *resume = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(resumeGame:)];
		CCMenuItem *restart = [CCMenuItemFont itemFromString:@"Restart" target:self selector:@selector(restartMission:)];
		CCMenuItem *quit = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(mainMenu:)];
        _pauseMenu = [CCMenu menuWithItems:resume, restart, quit, nil];
        _pauseMenu.position = ccp(240, 150);
        [_pauseMenu alignItemsVerticallyWithPadding:12.5f];
        [self addChild:_pauseMenu z:10];
		
		//Draw play(resume) button after game paused
		[self drawResumeButtons];
		[self drawSoundButtons];
	}
}

-(void)resumeGame:(id)sender {
	if (self.ssClicked) return;
	self.isTouchEnabled = YES;
	self.isAccelerometerEnabled = YES;
	[MusicHandler playButtonClick];
	[self removeChild:_pauseMenu cleanup:YES];
	[self removeChild:_pauseLayer cleanup:YES];
	[self removeChild:_pausedTitle cleanup:YES];
	[self removeChild:_minda cleanup:YES];
	[self removeChild:_spacemanPause cleanup:YES];
	[self removeChild:_soundButton cleanup:YES];
	[MusicHandler resumeBackgroundMusic];
    [[CCDirector sharedDirector] resume];
	//Remove the play button after resume game
	[_playButton runAction:[CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)]];
}

-(void)restartMission:(id)sender {
	if (self.ssClicked) return;
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HelloWorld node]]];
}

-(void)mainMenu:(id)sender {
	if (self.ssClicked) return;
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[MenuScene node]]];
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	static float prevX=0, prevY=0;
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	if(self.spaceship && !self.spaceship.isImmortal)
	{
		float speedY = -100 * -accelY;
		
		if(speedY > self.spaceship.movementSpeed)
			speedY = self.spaceship.movementSpeed;
		else if(speedY < -self.spaceship.movementSpeed)
			speedY = -self.spaceship.movementSpeed;
		
		if((accelY > 0 || self.spaceship.sprite.position.y > self.spaceship.sprite.textureRect.size.height/2) && ( accelY < 0 || self.spaceship.sprite.position.y < winSize.height - self.spaceship.sprite.textureRect.size.height/2))
            [self.spaceship.sprite setPosition:ccp(self.spaceship.sprite.position.y+speedY, self.spaceship.sprite.position.y)];
	}
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	[self selectSpriteForTouch:touchLocation];
    
    [self genBackground];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	CGPoint oldTouchLocation = [touch previousLocationInView:[touch view]];
	oldTouchLocation = [[CCDirector sharedDirector]convertToGL:oldTouchLocation];
	oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
	
	CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
	[self panForTranslation:translation];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_mode == 0) { //laser fire
		if (canLaunchBomb && bombs>0) {
			[self explodeBomb];
			[self checkIfDemonIsHit];
		}
	} else {
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint convertedLocation = [[CCDirector sharedDirector]convertToGL:location];
		
		// Play a sound after you take fire!
		[MusicHandler playBulletFireMusic];
		
		self._nextKnife = [[[CannonBall alloc] initWithSpriteFrameName:@"laserbeam_blue.png"] autorelease];
		_nextKnife.position = spaceship.sprite.position;
		
		//Rotate cannon to face shooting direction
		CGPoint shootVector = ccpSub(convertedLocation, _nextKnife.position);
		CGFloat shootAngle = ccpToAngle(shootVector);
		CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
		
		CGFloat curAngle = spaceship.sprite.rotation;
		CGFloat rotateDiff = cocosAngle - curAngle;
		if (rotateDiff > 180)
			rotateDiff -= 360;
		if (rotateDiff < -180)
			rotateDiff += 360;
		CGFloat rotateSpeed = 0.2 / 180; // Would take 0.2 seconds to rotate half a circle
		CGFloat rotateDuration = fabs(rotateDiff * rotateSpeed);
		
		// Move player slightly backwards
		[spaceship.sprite runAction:[CCSequence actions:
                                     [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle], 
                                     [CCCallFuncN actionWithTarget:self selector:@selector(finishShoot)], 
                                     nil]];
		
		// Move projectile offscreen
		ccTime delta = 1.0;
		CGPoint normalizedShootVector = ccpNormalize(shootVector);
		CGPoint overshotVector = ccpMult(normalizedShootVector, 420 * self.difficulty); //Make the valur bigger can make faster bullet speed!
		CGPoint offscreenPoint = ccpAdd(_nextKnife.position, overshotVector);
		
		[_nextKnife runAction:[CCSequence actions:[CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle], 
							   [CCMoveTo actionWithDuration:delta position:offscreenPoint], 
							   [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], 
							   nil]];
	}
}

-(void)finishShoot {
	[spaceSpriteSheet addChild:_nextKnife z:1 tag:kTagKnife];
	[_knife addObject:_nextKnife];
	
	//Release
	self._nextKnife = nil;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    delete _world;
	_world = NULL;
    [_background release];
	_background = nil;
	[spaceship release];
	spaceship = nil;
	[flyingAction release];
	flyingAction = nil;
	[_ghost release];
	_ghost = nil;
	[_knife release];
	_knife = nil;
	[_monsterKnife release];
	_monsterKnife = nil;
	[_nextKnife release];
	_nextKnife = nil;
	[_movableSprites release];
    _movableSprites = nil;
	[spaceSpriteSheet release];
	spaceSpriteSheet = nil;
	[super dealloc];
}

@end

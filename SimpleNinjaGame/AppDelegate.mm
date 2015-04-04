//
//  AppDelegate.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/6/21.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"
#import "MenuScene.h"
#import "Level.h"
#import "GameOverScene.h"
#import "GameWinScene.h"
#import "NewLevelScene.h"
#import "CCTouchDispatcher.h"
#import "MusicHandler.h"
#import "WorldPanelScene.h"

@implementation AppDelegate

@synthesize window;
@synthesize _curLevelIndex;
@synthesize _lastLevelIndex;
@synthesize _mainScene;
@synthesize _gameOverScene;
@synthesize _gameWinScene;
@synthesize _newLevelScene;
@synthesize _levels;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CCDirector *director = [CCDirector sharedDirector];
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[[director openGLView] swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    // CC_DIRECTOR_INIT()
    //
    // 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
    // 2. EAGLView multiple touches: disabled
    // 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
    // 4. Parents EAGLView to the newly created window
    // 5. Creates Display Link Director
    // 5a. If it fails, it will use an NSTimer director
    // 6. It will try to run at 60 FPS
    // 7. Display FPS: NO
    // 8. Device orientation: Portrait
    // 9. Connects the director to the EAGLView
    //
    // CC_DIRECTOR_INIT();
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupCocos2d];
}

- (void) setupCocos2d {
    if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeNSTimer];
    CCDirector *__director = [CCDirector sharedDirector];
    [__director setDeviceOrientation:kCCDeviceOrientationPortrait];
    [__director setDisplayFPS:YES];
    [__director setAnimationInterval:1.0/60];
	
	EAGLView *__glView = [EAGLView viewWithFrame:[window bounds]
									 pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
									 depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						  ];
	
    [__director setOpenGLView:__glView];
    [window addSubview:__glView];
    [window makeKeyAndVisible];
	
    // not sure why, the page turn says to turn that on
    // [[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
    // Obtain the shared director in order to...
    CCDirector *director = [CCDirector sharedDirector];
	
    // Sets landscape mode
    [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	
    // Turn on display FPS
    //[director setDisplayFPS:YES];
	
    // Turn on multiple touches
    EAGLView *view = [director openGLView];
    [view setMultipleTouchEnabled:YES];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	// make the OpenGLView a child of the view controller
	[viewController setView:__glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
    // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
    // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
    // You can change anytime.
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// Load levels
    self._levels = [[[NSMutableArray alloc] init] autorelease];
    Level *level1 = [[[Level alloc] initWithLevelNum:1 spawnRate:3 levelScore:300 bgImageName:@"star_bg1.png" frontBgName:@"city-bg.png" bgmName:@"bgm1.caf" levelName:@"MISSION 1" levelDoneBg:@"level-done1.png"] autorelease];
    Level *level2 = [[[Level alloc] initWithLevelNum:2 spawnRate:2 levelScore:400 bgImageName:@"star_bg2.png" frontBgName:@"city-bg.png" bgmName:@"bgm2.caf" levelName:@"MISSION 2" levelDoneBg:@"level-done2.png"] autorelease];
	Level *level3 = [[[Level alloc] initWithLevelNum:3 spawnRate:1 levelScore:500 bgImageName:@"star_bg3.png" frontBgName:@"city-bg.png" bgmName:@"bgm3.caf" levelName:@"MISSION 3" levelDoneBg:@"level-done3.png"] autorelease];
    [_levels addObject:level1];
    [_levels addObject:level2];
    [_levels addObject:level3];
	self._curLevelIndex = 0;
	self._lastLevelIndex = 0;
    
    self._mainScene = [HelloWorld scene];
    self._newLevelScene = [NewLevelScene node];
    self._gameOverScene = [GameOverScene node];
	//[_mainScene reset];
	
	[MusicHandler playMenuMusic];
	
    [[CCDirector sharedDirector] runWithScene: [MenuScene scene]];
}

- (Level *)curLevel {
    return [_levels objectAtIndex:_curLevelIndex];
}

//Return the last level of current level
- (Level *)lastLevel {
    return [_levels objectAtIndex:_lastLevelIndex];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)loadGameOverScene {
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameOverScene node]]];
	[MusicHandler playGameLoseMusic];
}

- (void)loadWinScene {
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:1 scene:[GameWinScene node]]];
	[MusicHandler playGameWinMusic];
}

- (void)loadNewLevelScene {
    //[_newLevelScene reset];
	[[CCDirector sharedDirector] replaceScene:[NewLevelScene node]];
}

- (void)nextLevel {
	//[_mainScene reset];
	[[CCDirector sharedDirector] replaceScene:[HelloWorld node]];
}

-(void)goToLevel:(int)levelNum {
	_curLevelIndex = levelNum;
	[self nextLevel];
}

- (void)restartGame {
    _curLevelIndex = 0;
	_lastLevelIndex = 0;
    [self nextLevel];
}

- (void)levelComplete {   
    _lastLevelIndex = _curLevelIndex;
    _curLevelIndex++;
    if (_curLevelIndex >= [_levels count]) {
        _curLevelIndex = 0;
        [self loadWinScene];
    } else {
        [self loadNewLevelScene];
		[MusicHandler playLevelUpMusic];
    }
    
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end

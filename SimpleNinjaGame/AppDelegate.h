//
//  AppDelegate.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/6/21.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class RootViewController;
@class Level;
@class HelloWorld;
@class GameWinScene;
@class GameOverScene;
@class NewLevelScene;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    int _curLevelIndex;
	int _lastLevelIndex;
    NSMutableArray *_levels;
    HelloWorld *_mainScene;
    GameOverScene *_gameOverScene;
	GameWinScene *_gameWinScene;
    NewLevelScene *_newLevelScene;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) int _curLevelIndex;
@property (nonatomic, assign) int _lastLevelIndex;
@property (nonatomic, retain) NSMutableArray *_levels;
@property (nonatomic, retain) HelloWorld *_mainScene;
@property (nonatomic, retain) GameOverScene *_gameOverScene;
@property (nonatomic, retain) GameWinScene *_gameWinScene;
@property (nonatomic, retain) NewLevelScene *_newLevelScene;

- (void) setupCocos2d;
- (Level *)curLevel;
-(Level *)lastLevel;
- (void)nextLevel;
- (void)levelComplete;
- (void)restartGame;
- (void)loadGameOverScene;
- (void)loadWinScene;

@end

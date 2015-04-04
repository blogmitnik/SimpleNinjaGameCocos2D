//
//  NewLevelScene.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewLevelScene.h"
#import "HelloWorldLayer.h"
#import "Level.h"
#import "AppDelegate.h"
#import "MusicHandler.h"


@implementation NewLevelScene

- (void)reset {
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3],
					 [CCCallFunc actionWithTarget:self selector:@selector(newLevelDone)],
                     nil]];
}

-(id) init
{
	if((self=[super init])) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		//Make different Level complete bg image
		AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		CCSprite *background = [CCSprite spriteWithFile:delegate.lastLevel._levelDoneBg rect:CGRectMake(0, 0,480,320)];
		background.anchorPoint = ccp(0,0);
		[self addChild:background z:0];
		//Make opacity background layer
		CCNode *bgLayer = [CCColorLayer layerWithColor: ccc4(0, 0, 0, 155) width: 420 height: 260];
		bgLayer.isRelativeAnchorPoint = YES;
		bgLayer.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild: bgLayer z:1];
		
		[CCMenuItemFont setFontName:@"Marker Felt"];
		[CCMenuItemFont setFontSize:32];
        CCMenuItemFont *play = [CCMenuItemFont itemFromString:[NSString stringWithFormat:@"Play Mission %d", delegate.curLevel._levelNum] target:self selector:@selector(newLevelDone:)];
        play.color = ccWHITE;
        CCMenu *nextlevel = [CCMenu menuWithItems:play, nil];
        nextlevel.position = ccp(winSize.width/2, winSize.height/2);
		[nextlevel alignItemsVerticallyWithPadding:10];
        [self addChild:nextlevel z:100];
		
	}	
	return self;
}

- (void)newLevelDone:(id)sender {
    //May add some change level animation here!
	
	[MusicHandler playButtonClick];
	[self runAction:[CCCallFunc actionWithTarget:self selector:@selector(changeLevel)]];
}

-(void)changeLevel {
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate nextLevel];
}

- (void)dealloc {
	
	[super dealloc];
}

@end

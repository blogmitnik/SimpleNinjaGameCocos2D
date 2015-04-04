//
//  GameWin.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameWinScene.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameWinScene
@synthesize label;

-(id) init
{
	if( (self=[super init] )) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background = [CCSprite spriteWithFile:@"space.jpg"];
		background.position = ccp(240, 160);
		[self addChild:background z:0];
		
		CCSprite *earth = [CCSprite spriteWithFile:@"earth.png" rect:CGRectMake(0, 0, 480, 300)];
        earth.anchorPoint = ccp(0,0);
        earth.position = ccp(0,-300);
        [self addChild:earth z:1];
		
		id fadeAction = [CCSequence actions:
						 [CCFadeTo actionWithDuration:0.5 opacity:0],
						 [CCDelayTime actionWithDuration:1.0],
						 [CCFadeTo actionWithDuration:0.5 opacity:255],nil];
		
		id moveAction = [CCSequence actions:
						 [CCMoveTo actionWithDuration:3 position:ccp(0,0)],nil];
		[earth runAction:[CCSpawn actions:fadeAction, moveAction, nil]];
		
		CCSprite *hero = [CCSprite spriteWithFile:@"Sangheili.png" rect:CGRectMake(0, 0, 161, 250)];
        hero.position = ccp(385,130);
		[hero setOpacity:0];
        [self addChild:hero z:2];
		[hero runAction:[CCSequence actions:
						 [CCFadeTo actionWithDuration:3.5 opacity:0],
						 [CCDelayTime actionWithDuration:1.0],
						 [CCFadeTo actionWithDuration:0.5 opacity:255],nil]];
		
		CCSprite *spacemonkey = [CCSprite spriteWithFile:@"space-monkey.png"];
        spacemonkey.position = ccp(spacemonkey.contentSize.width/2 + 20 ,winSize.height/2 + 115);
        [spacemonkey setOpacity:0];
		[self addChild:spacemonkey z:2];
		[spacemonkey runAction:[CCSequence actions:
								[CCDelayTime actionWithDuration:4.0], 
								fadeAction, 
								[CCRotateTo actionWithDuration:1.0 angle:70], 
								[CCMoveTo actionWithDuration:3.0 position:ccp(winSize.width + spacemonkey.contentSize.width, spacemonkey.position.y)], 
								nil]];
		
		label = [CCLabelTTF labelWithString:@"You win :P" fontName:@"Marker Felt" fontSize:32];
		label.color = ccc3(0,0,0);
		label.position = ccp(winSize.width/2, winSize.height/2 + 30);
		[self addChild:label z:100];
		
		[self runAction:[CCSequence actions:
						 [CCDelayTime actionWithDuration:10],
						 [CCCallFunc actionWithTarget:self selector:@selector(gameWinDone)],
						 nil]];
		
	}	
	return self;
}

- (void)gameWinDone {
	//Stop the bgm
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[[CCDirector sharedDirector] replaceScene:[HelloWorld scene]];
}

- (void)dealloc {
	[super dealloc];
}

@end

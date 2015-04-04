//
//  GameOverScene.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameOverScene

@synthesize label;
@synthesize label2;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		self.isTouchEnabled = YES;
		
		CCSprite *background = [CCSprite spriteWithFile:@"game-over-splash.png" rect:CGRectMake(0, 0, 480,320)];
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:background z:0];
		
		label = [CCLabelTTF labelWithString:@"You lose the game...XD" fontName:@"Marker Felt" fontSize:36];
		label.color = ccc3(255,255,255);
		label.position = ccp(winSize.width/2, winSize.height/2 + 110);
		[self addChild:label z:1];
		
		label2 = [CCLabelTTF labelWithString:@"Tap screen to play again" fontName:@"Marker Felt" fontSize:30];
        label2.color = ccc3(255, 255, 255);
		label2.position = ccp(winSize.width/2, winSize.height/2 - 100);
		[self addChild:label2 z:1];
		
		id fadeAction = [CCSequence actions:
						 [CCFadeTo actionWithDuration:0.5 opacity:255],
						 [CCDelayTime actionWithDuration:0.1],
						 [CCFadeTo actionWithDuration:0.5 opacity:0],nil];
		
		[label2 runAction:[CCRepeatForever actionWithAction:fadeAction]];
		
	}	
	return self;
}

-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorld node]]];
	return YES;
}

- (void)dealloc {
	[super dealloc];
}

@end
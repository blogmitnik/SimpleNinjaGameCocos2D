//
//  Tutorial.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"
#import "MusicHandler.h"

@implementation Tutorial

@synthesize theGame,ttBack,ttLabel,spaceman;

-(id)initWithText:(NSString *)text theGame:(HelloWorld *)game
{
	if ((self = [super init]))
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		self.theGame = game;
		[theGame addChild:self z:5];
		
		ttBack = [CCSprite spriteWithFile:@"tutorialBg.png"];
		ttBack.position = ccp(winSize.width/2, winSize.height/2);
		[ttBack setOpacity:0];
		[self addChild:ttBack];
		
		ttLabel = [CCLabelTTF labelWithString:text dimensions:CGSizeMake(270,110) alignment:UITextAlignmentCenter fontName:@"Futura LT Bold" fontSize:12];
		ttLabel.position = ccp(winSize.width/2, winSize.height/2);
		ttLabel.color = ccBLACK;
		[ttLabel setOpacity:0];
		[self addChild:ttLabel];
		
		spaceman = [CCSprite spriteWithFile:@"spaceman.png"];
		spaceman.position = ccp(winSize.width-spaceman.contentSize.width/2, spaceman.contentSize.height/2);
		[spaceman setOpacity:0];
		[self addChild:spaceman];
		
		[ttBack runAction:[CCFadeIn actionWithDuration:1]];
		[ttLabel runAction:[CCFadeIn actionWithDuration:1]];
		[spaceman runAction:[CCFadeIn actionWithDuration:1]];
		
		theGame.isTouchEnabled = NO;
	}
	return (self);
}

- (CGRect)rect
{
	CGRect c = CGRectMake(ttBack.position.x-(self.ttBack.textureRect.size.width/2) * self.ttBack.scaleX ,ttBack.position.y-(self.ttBack.textureRect.size.height/2)* self.ttBack.scaleY,self.ttBack.textureRect.size.width* self.ttBack.scaleX,self.ttBack.textureRect.size.height * self.ttBack.scaleY);
	return c;
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ( ![self containsTouchLocation:touch]) return NO;
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	[MusicHandler playButtonClick];
	[ttBack runAction:[CCFadeOut actionWithDuration:1]];
	[ttLabel runAction:[CCFadeOut actionWithDuration:1]];
	[spaceman runAction:[CCFadeOut actionWithDuration:1]];
	[self runAction:[CCCallFunc actionWithTarget:self selector:@selector(removal)]];
}

-(void)removal
{
	//[theGame schedule:@selector(drainTime) interval:0.20];
	theGame.isTouchEnabled = YES;
	
	[theGame startGame];
	[theGame removeChild:self cleanup:YES];
}

@end

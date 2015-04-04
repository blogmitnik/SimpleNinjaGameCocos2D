//
//  Tutorial.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "CCTouchDispatcher.h"

@interface Tutorial : CCNode <CCTargetedTouchDelegate> {
	HelloWorld *theGame;
	CCSprite *ttBack;
	CCLabelTTF *ttLabel;
	CCSprite *spaceman;
}

@property(nonatomic,retain) HelloWorld *theGame;
@property(nonatomic,retain) CCSprite *ttBack;
@property(nonatomic,retain) CCLabelTTF *ttLabel;
@property(nonatomic,retain) CCSprite *spaceman;

-(id)initWithText:(NSString *)text theGame:(HelloWorld *)game;

@end

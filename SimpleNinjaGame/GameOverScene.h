//
//  GameOverScene.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverScene : CCLayer {
	
	CCLabelTTF *label;
	CCLabelTTF *label2;
}

@property(nonatomic,retain)CCLabelTTF *label;
@property(nonatomic,retain)CCLabelTTF *label2;

+(id)scene;
-(BOOL) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
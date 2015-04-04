//
//  Monster.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Monster : CCSprite {
	
	int _curHp;
	int _maxHp;
	int _curScore;
	int _minMoveDuration;
	int _maxMoveDuration;
	bool launched;
	float _lastTimeFired;
	float _fireInterval;
	float _firingSpeed;

}

@property (nonatomic,readwrite) int hp;
@property (nonatomic,readwrite) int maxHp;
@property (nonatomic,assign) int curScore;
@property (nonatomic,assign) int minMoveDuration;
@property (nonatomic,assign) int maxMoveDuration;
@property (nonatomic,readwrite) bool launched;
@property (nonatomic,readwrite) float lastTimeFired;
@property (nonatomic,readwrite) float fireInterval;
@property (nonatomic,readwrite) float firingSpeed;

@end


@interface WeakAndFastMonster : Monster {
}
+(id)monster;
@end


@interface StrongAndSlowMonster : Monster {
}
+(id)monster;
@end


@interface StrongAndFastMonster : Monster {
}
+(id)monster;
@end

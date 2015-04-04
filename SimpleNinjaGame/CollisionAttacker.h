//
//  CollisionAttacker.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"

@interface CollisionAttacker : CCSprite {
	int _curHp;
	int _curScore;
	bool launched;
	float _lastTimeFired;
	float _fireInterval;
	float _firingSpeed;
}
@property(nonatomic,assign) int hp;
@property(nonatomic,assign) int curScore;
@property (nonatomic,readwrite) bool launched;
@property (nonatomic,readwrite) float lastTimeFired;
@property (nonatomic,readwrite) float fireInterval;
@property (nonatomic,readwrite) float firingSpeed;

@end

@interface AGSystems : CollisionAttacker {
}
+(id)attacker;
@end


@interface AuricomResearch : CollisionAttacker {
}
+(id)attacker;
@end


@interface FEISAR : CollisionAttacker {
}
+(id)attacker;
@end

@interface PirhanaAdvancements : CollisionAttacker {
}
+(id)attacker;
@end

@interface QirexRD : CollisionAttacker {
}
+(id)attacker;
@end

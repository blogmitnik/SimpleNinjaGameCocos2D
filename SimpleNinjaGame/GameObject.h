//
//  GameObject.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class HelloWorld;
@class Spaceship;

typedef enum _kGameObjectOwner {
    kGameObjectOwnerWorld = 0,
    kGameObjectOwnerPlayer = 1,
    kGameObjectOwnerEnemy = 2,
} kGameObjectOwner;


@interface GameObject : CCSprite {
    kGameObjectOwner owner;
    int maxLife;
    int life;
    int damage;
	int _curHp;
	int _maxHp;
	int _curScore;
	bool launched;
}

- (void)initGameObject;
- (void)onFrame:(ccTime)dt;
- (void)mainPhase:(ccTime)dt;
- (GameObject *)hitTestPhase:(ccTime)dt;
- (void)cleanupPhase;
-(BOOL)isCollided:(GameObject *)source objectUnderCollision:(GameObject *)target;

@property (nonatomic, readonly) HelloWorld *theGame;
@property (nonatomic, assign) kGameObjectOwner owner;
@property (nonatomic, assign) int maxLife;
@property (nonatomic, assign) int life;
@property (nonatomic, assign) int damage;

@property (nonatomic,readwrite) int hp;
@property (nonatomic,readwrite) int maxHp;
@property (nonatomic,assign) int curScore;
@property (nonatomic,readwrite) bool launched;

@end

//
//  Level.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {
    int _levelNum;
	int _levelScore;
    float _spawnRate;
    NSString *_bgImageName;
	NSString *_frontBgName;
	NSString *_bgmName;
	NSString *_levelName;
	NSString *_levelDoneBg;
}

@property (nonatomic, assign) int _levelNum;
@property (nonatomic, assign) float _spawnRate;
@property (nonatomic, assign) int _levelScore;
@property (nonatomic, copy) NSString *_bgImageName;
@property (nonatomic, copy) NSString *_frontBgName;
@property (nonatomic, copy) NSString *_bgmName;
@property (nonatomic, copy) NSString *_levelName;
@property (nonatomic, copy) NSString *_levelDoneBg;

- (id)initWithLevelNum:(int)levelNum spawnRate:(float)spawnRate levelScore:(int)levelScore bgImageName:(NSString *)bgImageName frontBgName:(NSString *)frontBgName bgmName:(NSString *)bgmName levelName:(NSString *)levelName levelDoneBg:(NSString *)levelDoneBg;

@end

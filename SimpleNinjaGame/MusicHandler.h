//
//  MusicHandler.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleAudioEngine.h"

@interface MusicHandler : NSObject {
	
}

+(void) preload;
+(void) playBackgroundMusic;
+(void) pauseBackgroundMusic;
+(void) resumeBackgroundMusic;
+(void) playButtonClick;
+(void) playMenuMusic;
+(void) playGameLoseMusic;
+(void) playGameWinMusic;
+(void) playMissionDoneMusic;
+(void) playLevelUpMusic;
+(void) playLevelCompleteMusic;
+(void) playGameOverMusic;
+(void) playDamageMusic;
+(void) playHugeExplosionMusic;
+(void) playMonsterHitMusic;
+(void) playMonsterAttackMusic;
+(void) playAttackerHitMusic;
+(void) playDemonAttackMusic;
+(void) playDemonHitMusic;
+(void) playBulletFireMusic;
+(void) playMeteorExplodeMusic;
+(void) playLaserMusic;
+(void) playLaser2Music;
+(void) playExplosion1Music;
+(void) playExplosion2Music;
+(void) playExplosion3Music;

@end

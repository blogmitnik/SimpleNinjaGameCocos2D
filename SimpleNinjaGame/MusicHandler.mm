//
//  MusicHandler.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MusicHandler.h"
#import "AppDelegate.h"
#import "Level.h"


@implementation MusicHandler

static NSString *BUTTON_CLICK_EFFECT = @"click.mp3";

+(void) preload {
	//Preload sound effects
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgm1.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgm2.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgm3.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"ow.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"laugh.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"bullet.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"click.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"huge-explosion.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"monsterHit.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"gotlife.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"lose.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"gameover.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"level-up.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosionA.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosionB.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosionC.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"meteor-explode.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"laser.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"laser_ship.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"fireball.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Temple_of_Groovy.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_CLICK_EFFECT];
}

+(void) playMenuMusic {
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Temple_of_Groovy.mp3" loop:YES];
}

+(void) playButtonClick {
	[[SimpleAudioEngine sharedEngine] playEffect:BUTTON_CLICK_EFFECT];
}

+(void) playBackgroundMusic {
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:delegate.curLevel._bgmName];
}

+(void) pauseBackgroundMusic {
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

+(void) resumeBackgroundMusic {
	[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

+(void) playGameWinMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"bgm.caf"];
}

+(void) playGameLoseMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"lose.wav"];
}

+(void) playMissionDoneMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"pickup.caf"];
}

+(void) playLevelUpMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"level-up.wav"];
}

+(void) playLevelCompleteMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"gotlife.wav"];
}

+(void) playGameOverMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"gameover.wav"];
}

+(void) playDamageMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"damage.mp3"];
}

+(void) playHugeExplosionMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"huge-explosion.caf"];
}

+(void) playMonsterAttackMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"laugh.caf"];
}

+(void) playMonsterHitMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"ow.caf"];
}

+(void) playAttackerHitMusic {
	[[SimpleAudioEngine sharedEngine] playEffect:@"explosionC.wav"];
}

+(void) playDemonAttackMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"fireball.wav"];
}

+(void) playDemonHitMusic {
	[[SimpleAudioEngine sharedEngine] playEffect:@"monsterHit.wav"];
}

+(void) playBulletFireMusic {
	[[SimpleAudioEngine sharedEngine]playEffect:@"bullet.mp3"];
}

+(void) playMeteorExplodeMusic {
	[[SimpleAudioEngine sharedEngine] playEffect:@"meteor-explode.caf"];
}

+(void) playLaserMusic {
	[[SimpleAudioEngine sharedEngine] playEffect:@"laser.wav"];
}

+(void) playLaser2Music {
	[[SimpleAudioEngine sharedEngine] playEffect:@"laser_ship.caf"];
}

+(void) playExplosion1Music {
	[[SimpleAudioEngine sharedEngine] playEffect:@"explosionA.wav"];
}

+(void) playExplosion2Music {
	[[SimpleAudioEngine sharedEngine] playEffect:@"explosionB.wav"];
}

+(void) playExplosion3Music {
	[[SimpleAudioEngine sharedEngine] playEffect:@"explosionC.wav"];
}

@end

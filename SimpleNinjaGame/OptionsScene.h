//
//  OptionsScene.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCMenuItemSlider.h"
#import "MusicHandler.h"
#import "SimpleAudioEngine.h"
#import "MenuScene.h"
#import "CCRadioMenu.h"

@interface Options : CCLayer {
	CCMenuItem *easyBtn;
	CCMenuItem *normalBtn;
	CCMenuItem *hardBtn;
	CCMenuItemSlider *musicSlider;
	CCMenuItemSlider *soundSlider;
	CCMenuItemToggle *musicBtn;
	CCMenuItemToggle *soundBtn;
	int prevMusicLevel;
	int prevSoundLevel;
	CCLabelTTF *_label;
}

@property (nonatomic, retain) CCMenuItem *easyBtn;
@property (nonatomic, retain) CCMenuItem *normalBtn;
@property (nonatomic, retain) CCMenuItem *hardBtn;
@property (nonatomic, retain) CCMenuItemSlider *musicSlider;
@property (nonatomic, retain) CCMenuItemSlider *soundSlider;
@property (nonatomic, retain) CCMenuItemToggle *musicBtn;
@property (nonatomic, retain) CCMenuItemToggle *soundBtn;
@property int prevMusicLevel;
@property int prevSoundLevel;

- (id) init;
- (void) selectDifficulty:(id)sender;
- (void) onMusicClick:(id)sender;
- (void) onMusicSlide:(id)sender;
- (void) onSoundClick:(id)sender;
- (void) onSoundSlide:(id)sender;
- (void)onBackClick:(id)sender;

@end

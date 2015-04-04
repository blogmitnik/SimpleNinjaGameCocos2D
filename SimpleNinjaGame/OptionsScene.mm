//
//  OptionsScene.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"

@implementation Options

@synthesize easyBtn, normalBtn, hardBtn, soundSlider, musicSlider, soundBtn, musicBtn, prevMusicLevel, prevSoundLevel;

- (id) init {
    self = [super init];
    if (self != nil) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		_label = [[CCLabelTTF labelWithString:@"" 
								   dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentCenter 
									 fontName:@"Arial" fontSize:26] retain];
        _label.position = ccp(100, 50);
		[self addChild:_label z:1];
		
		CCSprite *background = [CCSprite spriteWithFile:@"game_option_bg.png"];
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:background z:0];
		
		//Make opacity background layer
		CCNode *bgLayer = [CCColorLayer layerWithColor: ccc4(0, 0, 0, 135) width: 420 height: 260];
		bgLayer.isRelativeAnchorPoint = YES;
		bgLayer.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild: bgLayer z:1];
		
		CCLabelBMFont *gameSetting = [CCLabelBMFont labelWithString:@"Game Settings" fntFile:@"feedbackFont.fnt"];
		[gameSetting setColor:ccWHITE];
		gameSetting.position = ccp(winSize.width/2, winSize.height - 60);
		[self addChild:gameSetting z:2];
		
		//Select Difficulty Label
		CCLabelBMFont * difficultyLabel = [CCLabelBMFont labelWithString:@"Difficulty" fntFile:@"hud_font.fnt"];
		[difficultyLabel setColor:ccWHITE];
		[self addChild:difficultyLabel z:1];
		difficultyLabel.position = ccp(80, 210);
		
		//Select Difficulty Button
		easyBtn = [CCMenuItemImage itemFromNormalImage:@"easy-btn.png" 
                                                       selectedImage:@"easy-btn-dwn.png"
													 disabledImage:@"easy-btn-dis.png" target:self selector:@selector(selectDifficulty:)];
        normalBtn = [CCMenuItemImage itemFromNormalImage:@"normal-btn.png" 
                                                       selectedImage:@"normal-btn-dwn.png" 
													   disabledImage:@"normal-btn-dis.png" target:self selector:@selector(selectDifficulty:)];
        hardBtn = [CCMenuItemImage itemFromNormalImage:@"hard-btn.png" 
                                                       selectedImage:@"hard-btn-dwn.png" 
													 disabledImage:@"hard-btn-dis.png" target:self selector:@selector(selectDifficulty:)];
        
		CCRadioMenu *radioMenu = [CCRadioMenu menuWithItems:easyBtn, normalBtn, hardBtn, nil];
        radioMenu.position = ccp(280, 210);
        [radioMenu alignItemsHorizontallyWithPadding:10];
        radioMenu.selectedItem_ = easyBtn;
        [easyBtn selected];
        [self addChild:radioMenu z:1];
		
		//Set if specific mode is unlocked
		[easyBtn setIsEnabled:YES];
		[normalBtn setIsEnabled:YES];
		[hardBtn setIsEnabled:YES];
		
		[easyBtn setTag:1];
		[normalBtn setTag:2];
		[hardBtn setTag:3];
		
		//Change Music Volume
		musicBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onMusicClick:) items:
									  [CCMenuItemImage itemFromNormalImage:@"music_button.png" selectedImage:@"music_button_down.png"],
									  [CCMenuItemImage itemFromNormalImage:@"music_button_down.png" selectedImage:@"music_button.png"],
									  nil];
		musicBtn.position = ccp(winSize.width/2 - 165, winSize.height/2);
		
		// Sound on/off button
		soundBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundClick:) items:
									  [CCMenuItemImage itemFromNormalImage:@"sound_button.png" selectedImage:@"sound_button_down.png"],
									  [CCMenuItemImage itemFromNormalImage:@"sound_button_down.png" selectedImage:@"sound_button.png"],
									  nil];
		soundBtn.position = ccp(winSize.width/2 - 165, winSize.height/2 - 40);
		
		SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
		
		// Music Slider
		self.musicSlider = [CCMenuItemSlider itemFromTrackImage: @"slider-bar-white.png" knobImage: @"slider-btn.png" target:self selector: @selector(onMusicSlide:)];
		self.musicSlider.minValue = 0;
		self.musicSlider.maxValue = 100;
		self.musicSlider.value = floor(sae.backgroundMusicVolume * 100);
		self.musicSlider.position = ccp(winSize.width/2 + 45, winSize.height/2);
		
		// Sound Effect Slider
		self.soundSlider = [CCMenuItemSlider itemFromTrackImage: @"slider-bar-white.png" knobImage: @"slider-btn.png" target:self selector: @selector(onSoundSlide:)];
		self.soundSlider.minValue = 0;
		self.soundSlider.maxValue = 100;
		self.soundSlider.value = floor(sae.effectsVolume * 100);
		self.soundSlider.position = ccp(winSize.width/2 + 45, winSize.height/2 - 40);
		
		// Back to Main Menu
		CCMenuItemSprite *backBtn = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button_down.png" target:self selector:@selector(onBackClick:)];
		backBtn.position = ccp(380, 60);
		
		CCMenu *menu = [CCMenu menuWithItems:musicBtn, self.musicSlider, soundBtn, self.soundSlider, backBtn, nil];
		menu.position = ccp(0,0);
		[self addChild:menu z:2];
		
		NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
		if([usrDef boolForKey:@"music"] == NO)
			musicBtn.selectedIndex = 0;
		if([usrDef boolForKey:@"sound"] == NO)
			soundBtn.selectedIndex = 0;
		if([usrDef integerForKey:@"difficulty"] == 1)
			[easyBtn selected];
		if([usrDef integerForKey:@"difficulty"] == 2)
			[normalBtn selected];
		if([usrDef integerForKey:@"difficulty"] == 3)
			[hardBtn selected];
    }
    return self;
}

- (void)onMusicSlide:(id)sender {
    CCMenuItemSlider *slider = (CCMenuItemSlider*)sender;
	[SimpleAudioEngine sharedEngine].backgroundMusicVolume = (slider.value / 100.0);
}

- (void)onMusicClick:(id)sender {
	[MusicHandler playButtonClick];
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([sender selectedIndex] == 1) {
		[usrDef setBool:NO forKey:@"music"];
		self.prevMusicLevel = self.musicSlider.value;
		self.musicSlider.value = 0;
		[SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
	}
	else {
		[usrDef setBool:YES forKey:@"music"];
		self.musicSlider.value = self.prevMusicLevel;
		[SimpleAudioEngine sharedEngine].backgroundMusicVolume = (self.prevMusicLevel / 100.0);
	}
}

- (void)onSoundSlide:(id)sender {
    CCMenuItemSlider* slider = (CCMenuItemSlider*)sender;
	[SimpleAudioEngine sharedEngine].effectsVolume = (slider.value / 100.0);
}

- (void)onSoundClick:(id)sender {
	[MusicHandler playButtonClick];
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([sender selectedIndex] == 1) {
		[usrDef setBool:NO forKey:@"sound"];
		self.prevSoundLevel = self.soundSlider.value;
		self.soundSlider.value = 0;
		[SimpleAudioEngine sharedEngine].effectsVolume = 0;
	}
	else {
		[usrDef setBool:YES forKey:@"sound"];
		self.soundSlider.value = self.prevSoundLevel;
		[SimpleAudioEngine sharedEngine].effectsVolume = (self.prevSoundLevel / 100.0);
	}
}

- (void)onBackClick:(id)sender {
	[MusicHandler playButtonClick];
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:0 scene:[MenuScene node]]];
}

-(void)selectDifficulty:(id)sender {
	[MusicHandler playButtonClick];
	
	CCMenuItemImage *btn = (CCMenuItemImage *)sender;
	int difficultyMode = btn.tag;
	
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if (difficultyMode == 1)
		[usrDef setInteger:1 forKey:@"difficulty"];
	if (difficultyMode == 2)
		[usrDef setInteger:2 forKey:@"difficulty"];
	if (difficultyMode == 3)
		[usrDef setInteger:3 forKey:@"difficulty"];
	
	[_label setString:[NSString stringWithFormat:@"mode: %d", difficultyMode]];
}

@end

//
//  WorldPanelScene.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/6/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CocosOverlayScrollView.h"

@class TouchDelegatingView;
@class NMPanelMenu;

@interface WorldPanelScene : CCLayer {
	int nextWorld_;
    BOOL transitioning_;
    CocosOverlayScrollView* scrollView;
    TouchDelegatingView* touchDelegatingView;
    UIPageControl* pageControl;
}

// returns a Scene that contains the HSLevelSelectionScene as the only child
+(id) scene;
-(void) levelPicked: (id) sender ;

@end

//
//  UIMyController.h
//  Zombie
//
//  Created by Teresa di Tada on 6/25/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMyController : UIViewController {
    
    NSTimer *timer;
    IBOutlet UILabel *myCounterLabel;
}

@property (nonatomic, retain) UILabel *myCounterLabel;

-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;

@end

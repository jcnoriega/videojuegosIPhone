//
//  UIMyController.m
//  Zombie
//
//  Created by Teresa di Tada on 6/25/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "UIMyController.h"

@implementation UIMyController
@synthesize myCounterLabel;

int hours, minutes, seconds;
int secondsLeft;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    secondsLeft = 16925;
    [self countdownTimer];
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ) {
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    } else {
        secondsLeft = 16925;
    }
}

-(void)countdownTimer {
    
    secondsLeft = hours = minutes = seconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

@end
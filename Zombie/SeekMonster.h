//
//  SeekMonster.h
//  Zombie
//
//  Created by AdminMacLC01 on 6/3/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "SimpleMonster.h"

@interface SeekMonster : SimpleMonster

- (void) update: (NSTimeInterval)currentTime;
- (NSMutableArray *) getWalkingFrames: (int) index;

@end

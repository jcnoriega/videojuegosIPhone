//
//  BombZombie.h
//  Zombie
//
//  Created by Teresa di Tada on 6/26/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//
#import "SimpleMonster.h"

@interface BombMonster : SimpleMonster

- (void) update: (NSTimeInterval)currentTime;
- (NSMutableArray *) getWalkingFrames: (int) index;

@end


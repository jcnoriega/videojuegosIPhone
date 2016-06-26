//
//  BombZombie.m
//  Zombie
//
//  Created by Teresa di Tada on 6/26/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "BombMonster.h"

@implementation BombMonster

-(void) update: (NSTimeInterval)currentTime {
    
    double dx = (self.player.position.x - self.position.x);
    double dy = (self.player.position.y - self.position.y);
    //double dist = sqrt(dx*dx + dy*dy);
    
    self.physicsBody.velocity = CGVectorMake(dx * 0.1, dy * 0.1);
    self.lastUpdateTimeInterval = currentTime;
    int i = super.getDirection;
    self.walkFrames = [self getWalkingFrames:i];
    [self removeActionForKey:@"walkingInPlaceBear"];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures: self.walkFrames
                                      timePerFrame:0.3f
                                            resize:NO
                                           restore:YES]] withKey:@"walkingInPlaceBear"];
    
    
}

- (NSMutableArray *) getWalkingFrames: (int) index {
    NSMutableArray *walkingFrames = [NSMutableArray array];
    SKTextureAtlas *zombieAnimatedAtlas = [SKTextureAtlas atlasNamed:@"BombZombie"];
    int j;
    for (j=0; j<=3; j++) {
        NSString * textureName = [NSString stringWithFormat:@"BombZombie%d-%d", index, j];
        SKTexture * texture = [zombieAnimatedAtlas textureNamed:textureName];
        [walkingFrames addObject:texture];
    }
    return walkingFrames;
}


@end

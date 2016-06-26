//
//  SeekMonster.m
//  Zombie
//
//  Created by Teresa di Tada on 6/3/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "SeekMonster.h"

@implementation SeekMonster

-(void) update: (NSTimeInterval)currentTime {
    
    double dx = (self.player.position.x - self.position.x);
    double dy = (self.player.position.y - self.position.y);
    //double dist = sqrt(dx*dx + dy*dy);
    
    self.physicsBody.velocity = CGVectorMake(dx * 0.3, dy * 0.3);
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
    SKTextureAtlas *zombieAnimatedAtlas = [SKTextureAtlas atlasNamed:@"SeekZombie"];
    int j;
    for (j=0; j<=3; j++) {
        NSString * textureName = [NSString stringWithFormat:@"SeekZombie%d-%d", index, j];
        SKTexture * texture = [zombieAnimatedAtlas textureNamed:textureName];
        [walkingFrames addObject:texture];
    }
    return walkingFrames;
}


@end

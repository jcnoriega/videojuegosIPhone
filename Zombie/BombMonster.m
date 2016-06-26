//
//  BombZombie.m
//  Zombie
//
//  Created by Teresa di Tada on 6/26/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "BombMonster.h"

@implementation BombMonster{
    bool explode;
}

- (id)init {
    self = [super init];
    self->explode = NO;
    return self;
}

-(void) update: (NSTimeInterval)currentTime {
    
    int rand = arc4random_uniform(1000);
    if (rand < 0.1){
        self->explode = YES;
    }
    
    if(self->explode){
        if(self.yScale < 4 && self.xScale < 4){
            self.yScale = self.yScale + 0.1;
            self.xScale = self.xScale + 0.1;
        }
    }
    
    double dx = (self.player.position.x - self.position.x);
    double dy = (self.player.position.y - self.position.y);
    if(self->explode){
        self.physicsBody.velocity = CGVectorMake(dx * 0.05, dy * 0.05);
    }else{
        self.physicsBody.velocity = CGVectorMake(dx * 0.15, dy * 0.15);
    }
    self.lastUpdateTimeInterval = currentTime;
    int i = super.getDirection;
    self.walkFrames = [self getWalkingFrames:i];
    [self removeActionForKey:@"walkingInPlace"];
    [self runAction:[SKAction repeatActionForever:
                [SKAction animateWithTextures: self.walkFrames
                                    timePerFrame:0.3f
                                        resize:NO
                                        restore:YES]] withKey:@"walkingInPlace"];
    
}

- (NSMutableArray *) getWalkingFrames: (int) index {
    NSMutableArray *walkingFrames = [NSMutableArray array];
    SKTextureAtlas *zombieAnimatedAtlas = [SKTextureAtlas atlasNamed:@"BombZombie"];
    int j;
    for (j=0; j<=2; j++) {
        NSString * textureName = [NSString stringWithFormat:@"BombZombie%d-%d", index, j];
        SKTexture * texture = [zombieAnimatedAtlas textureNamed:textureName];
        [walkingFrames addObject:texture];
    }
    return walkingFrames;
}


@end

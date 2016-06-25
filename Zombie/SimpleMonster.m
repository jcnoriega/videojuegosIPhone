//
//  SimpleMonster.m
//  Zombie
//
//  Created by Jose Carlos Noriega Defferrari on 5/12/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "SimpleMonster.h"

@implementation SimpleMonster

static CGPoint directions[4];


- (id)init {
    self = [super init];
    self.direction = CGPointMake(0,1);
    return self;
}

+ (void) initializeDirections {
    static BOOL initialized = NO;
    if (!initialized) {
        directions[0] = CGPointMake(-1, 0); //izq
        directions[1] = CGPointMake(1, 0); //der
        directions[2] = CGPointMake(0, 1); //arr
        directions[3] = CGPointMake(0, -1); //abj
        initialized = YES;
    }
}

+ (id) spriteNodeWithImageNamed : (NSString *) name
{
    SimpleMonster * monster = [super spriteNodeWithImageNamed: @"WandererZombie3-0"];
    int i = 0 + arc4random() % (4 - 0);
    monster.direction = directions[i];
    monster.xScale = 0.6;
    monster.yScale = 0.6;
    monster.walkFrames = [monster getWalkingFrames:i];
    [monster runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures: monster.walkFrames
                                       timePerFrame:0.3f
                                            resize:NO
                                            restore:YES]] withKey:@"walkingInPlaceBear"];
  
    return monster;
}

- (NSMutableArray *) getWalkingFrames: (int) index {
    NSMutableArray *walkingFrames = [NSMutableArray array];
    SKTextureAtlas *zombieAnimatedAtlas = [SKTextureAtlas atlasNamed:@"WandererZombie"];
    int j;
    for (j=0; j<=3; j++) {
        NSString * textureName = [NSString stringWithFormat:@"WandererZombie%d-%d", index, j];
        SKTexture * texture = [zombieAnimatedAtlas textureNamed:textureName];
        [walkingFrames addObject:texture];
    }
    return walkingFrames;
}

-(void) update: (NSTimeInterval)currentTime {
    NSTimeInterval interval = currentTime - self.lastUpdateTimeInterval;
    CGPoint previousDirection = self.direction;
    CGPoint newDirection;
    if (interval >= 4) {
        int i = 0 + arc4random() % (4 - 0);
        newDirection = directions[i];
        while(CGPointEqualToPoint(previousDirection, newDirection)) {
            i = 0 + arc4random() % (4 - 0);
            newDirection = directions[i];

        }
        self.walkFrames = [self getWalkingFrames:i];
        [self removeActionForKey:@"walkingInPlaceBear"];
        [self runAction:[SKAction repeatActionForever:
                            [SKAction animateWithTextures: self.walkFrames
                                             timePerFrame:0.3f
                                                   resize:NO
                                                  restore:YES]] withKey:@"walkingInPlaceBear"];
        self.lastUpdateTimeInterval = currentTime;
        self.direction = newDirection;
        self.physicsBody.velocity = CGVectorMake(newDirection.x * 15, newDirection.y * 15);
    }
}

-(int) getDirection{
    if(self.physicsBody.velocity.dx >= 0){
        return 1;
    }else if(self.physicsBody.velocity.dx < 0){
        return 0;
    }
    return 0;
}
@end

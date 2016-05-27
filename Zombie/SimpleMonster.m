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
        directions[0] = CGPointMake(-1, 0);
        directions[1] = CGPointMake(1, 0);
        directions[2] = CGPointMake(0, 1);
        directions[3] = CGPointMake(0, -1);
        initialized = YES;
    }
}

+ (id) spriteNodeWithImageNamed : (NSString *) name
{
    NSMutableArray *walkingFrames = [NSMutableArray array];
    SKTextureAtlas *zombieAnimatedAtlas = [SKTextureAtlas atlasNamed:@"sprites"];
    NSString * textureName = @"SimpleZombieFront";
    SKTexture *temp = [zombieAnimatedAtlas textureNamed:textureName];
    [walkingFrames addObject:temp];
    textureName = @"SimpleZombieFrontRight";
    temp = [zombieAnimatedAtlas textureNamed:textureName];
    [walkingFrames addObject:temp];
    textureName = @"SimpleZombieFront";
    temp = [zombieAnimatedAtlas textureNamed:textureName];
    [walkingFrames addObject:temp];
    textureName = @"SimpleZombieFrontLeft";
    temp = [zombieAnimatedAtlas textureNamed:textureName];
    [walkingFrames addObject:temp];
    
    SimpleMonster * monster = [super spriteNodeWithImageNamed: @"SimpleZombieFront"];
    int i = 0 + arc4random() % (4 - 0);
    monster.direction = directions[i];
    monster.walkFrames = walkingFrames;
    [monster runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures: monster.walkFrames
                                       timePerFrame:0.4f
                                            resize:NO
                                            restore:YES]] withKey:@"walkingInPlaceBear"];
  
    return monster;
}


-(void) update: (NSTimeInterval)currentTime {
    NSTimeInterval interval = currentTime - self.lastUpdateTimeInterval;
    CGPoint previousDirection = self.direction;
    CGPoint newDirection;
    if (interval >= 2) {
        int i = 0 + arc4random() % (4 - 0);
        newDirection = directions[i];
        while(CGPointEqualToPoint(previousDirection, newDirection)) {
            int j = 0 + arc4random() % (4 - 0);
            newDirection = directions[j];

        }
        self.lastUpdateTimeInterval = currentTime;
        self.direction = newDirection;
        self.physicsBody.velocity = CGVectorMake(newDirection.x * 50, newDirection.y * 50);
    }
}
@end

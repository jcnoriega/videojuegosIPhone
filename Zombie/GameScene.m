//
//  GameScene.m
//  Zombie
//
//  Created by Jose Carlos Noriega Defferrari on 4/21/16.
//  Copyright (c) 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "GameScene.h"
#define kMinDistance    25
#define kMinDuration    0.1
#define kMinSpeed       100
#define kMaxSpeed       500

@interface GameScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) CGPoint faceDirection;
@end

@implementation GameScene
    CGPoint start;
    NSTimeInterval startTime;
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        self.faceDirection = CGPointMake(1,0);
        
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.dynamic = YES;
        self.player.physicsBody.categoryBitMask = playerCategory;
        CGSize sceneSize = self.frame.size;
        CGFloat lowerXlimit = self.player.size.width/2;
        CGFloat lowerYlimit = self.player.size.height/2;
        CGFloat upperXlimit = sceneSize.width - self.player.size.width/2;
        CGFloat upperYlimit = sceneSize.height - self.player.size.height/2;
        SKConstraint *constraint = [SKConstraint
                           positionX:[SKRange rangeWithLowerLimit:lowerXlimit upperLimit:upperXlimit]
                           Y:[SKRange rangeWithLowerLimit:lowerYlimit upperLimit:upperYlimit]];
        self.player.constraints = @[constraint];
        [self addChild:self.player];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /* Avoid multi-touch gestures (optional) */
    if ([touches count] > 1) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    // Save start location and time
    start = location;
    startTime = touch.timestamp;
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    // Determine distance from the starting point
    CGFloat dx = location.x - start.x;
    CGFloat dy = location.y - start.y;
    CGFloat magnitude = sqrt(dx*dx+dy*dy);
    if (magnitude >= kMinDistance) {
        // Determine time difference from start of the gesture
        CGFloat dt = touch.timestamp - startTime;
        if (dt > kMinDuration) {
            // Determine gesture speed in points/sec
            CGFloat speed = magnitude / dt;
            if (speed >= kMinSpeed && speed <= kMaxSpeed) {
                // Calculate normalized direction of the swipe
                dx = dx / magnitude;
                dy = dy / magnitude;
                NSLog(@"Swipe detected with speed = %g and direction (%g, %g)",speed, dx, dy);
                CGFloat absY = fabs(dy);
                CGFloat absX = fabs(dx);
                CGFloat playerX = self.player.position.x;
                CGFloat playerY = self.player.position.y;
                CGPoint direction;
                if (absY > absX) {
                    if (dy < 0) {
                        direction = CGPointMake(playerX, playerY - 1000);
                        self.faceDirection = CGPointMake(0, -1);
                    } else {
                        direction = CGPointMake(playerX, playerY + 1000);
                        self.faceDirection = CGPointMake(0, 1);
                    }
                } else {
                    if (dx < 0) {
                        direction = CGPointMake(playerX - 1000, playerY);
                        self.faceDirection = CGPointMake(-1, 0);
                    } else {
                        direction = CGPointMake(playerX + 1000, playerY);
                        self.faceDirection = CGPointMake(1, 0);
                    }
                }
                SKAction * move = [SKAction moveTo:direction duration:15];
                [self.player runAction: move];
            }
        }
    } else {
        // 2 - Set up initial location of projectile
        [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
        SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        CGFloat projectilePositionX;
        CGFloat projectilePositionY;
        if (self.faceDirection.x != 0) {
            //looking horizontally
            projectilePositionX = self.player.position.x +
                                self.faceDirection.x *(self.player.size.width/2 + projectile.size.width/2);
            projectilePositionY = self.player.position.y;
        } else {
            //looking vertically
            projectilePositionX = self.player.position.x;
            projectilePositionY = self.player.position.y +
                                self.faceDirection.y *(self.player.size.height/2 + projectile.size.width/2);
        }
        projectile.position = CGPointMake(projectilePositionX, projectilePositionY);
        [self addChild:projectile];
        CGPoint projectileDestination = CGPointMake(self.player.position.x + self.faceDirection.x*1000,
                                                self.player.position.y + self.faceDirection.y*1000);
        SKAction * actionMove = [SKAction moveTo:projectileDestination duration:5];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    }
}


@end

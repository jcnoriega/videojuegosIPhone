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
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic, strong) NSMutableArray * monsters;
@end

static const uint32_t limitCategory = 0x1 << 0;
static const uint32_t playerCategory = 0x1 << 1;
static const uint32_t projectileCategory = 0x1 << 2;
static const uint32_t monsterCategory = 0x1 << 3;
static const uint32_t foodCategory = 0x1 << 4;

typedef enum {
    Random,
    Seek,
    Bomb
} EnemyType;

@implementation GameScene
CGPoint start;
NSTimeInterval startTimeGame;
SKLabelNode *countDown;
SKLabelNode *score;
SKLabelNode *middleText;
int scoreValue;
BOOL startGamePlay = YES;
NSTimeInterval startTime;
int gameTimeInSec = 60.0;
bool GameOver = NO;

-(void)initializeScene{
    
    self.monsters = [NSMutableArray array];
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Player2-1"];
    
    self.player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.dynamic = YES;
    self.player.physicsBody.categoryBitMask = playerCategory;
    self.player.physicsBody.contactTestBitMask = monsterCategory | foodCategory;
    self.player.physicsBody.allowsRotation = NO;
    self.player.name = @"player";
    self.player.xScale = 0.7;
    self.player.yScale = 0.7;
    self.player.zPosition = 50;
    
    CGSize sceneSize = self.frame.size;
    CGFloat lowerXlimit = self.player.size.width/2;
    CGFloat lowerYlimit = self.player.size.height/2;
    CGFloat upperXlimit = sceneSize.width - self.player.size.width/2;
    CGFloat upperYlimit = sceneSize.height - self.player.size.height/2;
    SKConstraint *constraint = [SKConstraint
                                positionX:[SKRange rangeWithLowerLimit:lowerXlimit upperLimit:upperXlimit]
                                Y:[SKRange rangeWithLowerLimit:lowerYlimit upperLimit:upperYlimit]];
    self.player.constraints = @[constraint];
    
    NSLog(@"Frame height = %f",self.frame.size.height);
    NSLog(@"Frame width = %f",self.frame.size.width);
    [self addChild:self.player];
    
    [SimpleMonster initializeDirections];
    
    countDown = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
    countDown.fontSize = 12;
    countDown.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*0.95);
    countDown.fontColor = [SKColor whiteColor];
    countDown.name = @"countDown";
    countDown.zPosition = 100;
    [self addChild:countDown];
    
    score = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
    score.fontSize = 12;
    score.position = CGPointMake(CGRectGetMaxX(self.frame)*0.95, CGRectGetMaxY(self.frame)*0.95);
    score.fontColor = [SKColor whiteColor];
    score.name = @"score";
    score.zPosition = 100;
    scoreValue = 0;
    score.text = [NSString stringWithFormat:@"Score: %d",scoreValue];
    [self addChild:score];
    
    middleText = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
    middleText.fontSize = 26;
    middleText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    middleText.fontColor = [SKColor whiteColor];
    middleText.name = @"middletext";
    middleText.zPosition = 100;
    [self addChild:middleText];
    
    CGSize coverageSize = CGSizeMake(2000,2000); //the size of the entire image you want tiled
    CGRect textureSize = CGRectMake(0, 0, 50, 50); //the size of the tile.
    CGImageRef backgroundCGImage = [UIImage imageNamed:@"Background"].CGImage;
    UIGraphicsBeginImageContext(CGSizeMake(coverageSize.width, coverageSize.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(context, textureSize, backgroundCGImage);
    UIImage *tiledBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:tiledBackground.CGImage];
    SKSpriteNode *backgroundTiles = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    backgroundTiles.position = CGPointMake(0,0);
    [self addChild:backgroundTiles];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initializeScene];
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        self.faceDirection = CGPointMake(0,-1);
        
        self.physicsWorld.contactDelegate = self; //declare this class as the contact delegate
        
    }
    return self;
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    if (((contact.bodyA.categoryBitMask == monsterCategory)
         && (contact.bodyB.categoryBitMask == playerCategory)) || ((contact.bodyB.categoryBitMask == monsterCategory) && (contact.bodyA.categoryBitMask == playerCategory)))
    {
        GameOver = YES;
        countDown.text=@":(";
        middleText.text =@"GAME OVER";
    } else if ((contact.bodyA.categoryBitMask == monsterCategory)
        && (contact.bodyB.categoryBitMask == projectileCategory))
    {
        [contact.bodyA.node removeFromParent];
        [contact.bodyB.node removeFromParent];
        scoreValue = scoreValue + 1;
        score.text = [NSString stringWithFormat:@"Score: %d",scoreValue];
        
    }else if ((contact.bodyA.categoryBitMask == foodCategory)
              && (contact.bodyB.categoryBitMask == playerCategory))
    {
        [contact.bodyA.node removeFromParent];
        if([contact.bodyA.node.name isEqualToString:@"badfood"]){
            gameTimeInSec = gameTimeInSec - 40;
        }else{
            gameTimeInSec = gameTimeInSec + 10;
        }
    }else if ((contact.bodyB.categoryBitMask == foodCategory)
              && (contact.bodyA.categoryBitMask == playerCategory))
    {
        [contact.bodyB.node removeFromParent];
        if([contact.bodyB.node.name isEqualToString:@"badfood"]){
            gameTimeInSec = gameTimeInSec - 40;
        }else{
            gameTimeInSec = gameTimeInSec + 10;
        }
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
     SKNode* obj;
     
     if ([obj isKindOfClass:[GameScene class]]) {
     [((GameScene*)obj) ]
     }
     
     
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

- (Food * )addFood{
    Food * food = [Food spriteNodeWithImageNamed:@"food"];
    
    int minY = food.size.height / 2;
    int maxY = self.frame.size.height - food.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    int minX = food.size.width / 2;
    int maxX = self.frame.size.width - food.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    food.position = CGPointMake(actualX, actualY);
    food.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:food.size];
    food.physicsBody.dynamic = NO;
    food.physicsBody.categoryBitMask = foodCategory;
    food.physicsBody.contactTestBitMask = playerCategory;
    food.physicsBody.allowsRotation = NO;
    food.physicsBody.usesPreciseCollisionDetection = YES;
    return food;
}

- (SimpleMonster * )addMonster: (NSTimeInterval)currentTime withType:(EnemyType) enemy {
    SimpleMonster * monster;    // Create sprite
    if(enemy==Seek){
        monster = [SeekMonster spriteNodeWithImageNamed:@"monster"];
    }else if(enemy==Bomb){
        monster = [BombMonster spriteNodeWithImageNamed:@"monster"];
    }else{
       monster = [SimpleMonster spriteNodeWithImageNamed:@"monster"];
    }
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
    monster.physicsBody.dynamic = YES;
    monster.physicsBody.categoryBitMask = monsterCategory; 
    monster.physicsBody.contactTestBitMask = projectileCategory | playerCategory;
    monster.physicsBody.allowsRotation = NO;
    //monster.physicsBody.collisionBitMask = 0; // 5
    monster.physicsBody.usesPreciseCollisionDetection = YES;
    monster.name = @"monster";
    monster.player = self.player;
    monster.frameheight = self.frame.size.height;
    monster.framewidth = self.frame.size.width;
    [monster update: currentTime];
    // Determine where to spawn the monster along the Y axis
    int minY = monster.size.height;
    int maxY = self.frame.size.height - monster.size.height;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    int minX = monster.size.width;
    int maxX = self.frame.size.width - monster.size.width;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    
    monster.position = CGPointMake(actualX, actualY);
    monster.physicsBody.velocity=CGVectorMake(monster.direction.x*15, monster.direction.y*15);
    monster.physicsBody.linearDamping = 0; //You may want to remove the air-resistance external force.
    monster.physicsBody.affectedByGravity = false;
    
    CGSize sceneSize = self.frame.size;
    CGFloat lowerXlimit = monster.size.width/2;
    CGFloat lowerYlimit = monster.size.height/2;
    CGFloat upperXlimit = sceneSize.width - monster.size.width/2;
    CGFloat upperYlimit = sceneSize.height - monster.size.height/2;
    SKConstraint *constraint = [SKConstraint
                                positionX:[SKRange rangeWithLowerLimit:lowerXlimit upperLimit:upperXlimit]
                                Y:[SKRange rangeWithLowerLimit:lowerYlimit upperLimit:upperYlimit]];
    monster.constraints = @[constraint];
    
    [self addChild:monster];
    return monster;
    
    
    /* // Determine speed of the monster
     int minDuration = 2.0;
     int maxDuration = 4.0;
     int rangeDuration = maxDuration - minDuration;
     int actualDuration = (arc4random() % rangeDuration) + minDuration;
     
     // Create the actions
     SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, actualY) duration:actualDuration];
     SKAction * actionMoveDone = [SKAction removeFromParent];
     [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
     */
}

- (void)update:(NSTimeInterval)currentTime {
    NSTimeInterval interval = currentTime - self.lastUpdateTimeInterval;
    if (interval >= 5) {
        self.lastUpdateTimeInterval = currentTime;
        int i = arc4random_uniform(3);
        EnemyType enemy = Random;
        if(i==1){
            enemy = Seek;
        }else if(i==2){
            enemy = Bomb;
        }
        [self.monsters addObject: [self addMonster: currentTime withType:enemy]];
    }
    if (arc4random_uniform(500) < 0.5) {
        [self addChild:[self addFood]];
    }
    
    for (SimpleMonster * monster in self.monsters)
    {
        [monster update:currentTime];
    }
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    /*
     CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
     self.lastUpdateTimeInterval = currentTime;
     if (timeSinceLast > 1) { // more than a second since last update
     timeSinceLast = 1.0 / 60.0;
     self.lastUpdateTimeInterval = currentTime;
     }
     
     [self updateWithTimeSinceLastUpdate:timeSinceLast]; */
    
    if(startGamePlay){
        startTimeGame = currentTime;
        startGamePlay = NO;
    }
    int countDownInt = gameTimeInSec - (int) (currentTime - startTimeGame);
    if(countDownInt>0 && !GameOver){
        countDown.text = [NSString stringWithFormat:@"%i",(int)countDownInt];
    }else{
        countDown.text=@":(";
        middleText.text = @"GAME OVER";
    }
    
    
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    // Determine distance from the starting point
    CGFloat dx = location.x - start.x;
    CGFloat dy = location.y - start.y;
    CGFloat magnitude = sqrt(dx*dx+dy*dy);
    if (magnitude >= kMinDistance && !GameOver) {
        // Determine time difference from start of the gesture
        CGFloat dt = touch.timestamp - startTime;
        if (dt > kMinDuration) {
            // Determine gesture speed in points/sec
            CGFloat speed = magnitude / dt;
            if (speed >= kMinSpeed && speed <= kMaxSpeed) {
                // Calculate normalized direction of the swipe
                dx = dx / magnitude;
                dy = dy / magnitude;
                CGFloat absY = fabs(dy);
                CGFloat absX = fabs(dx);
                CGFloat playerX = self.player.position.x;
                CGFloat playerY = self.player.position.y;
                CGPoint direction;
                NSMutableArray *walkingFrames = [NSMutableArray array];
                SKTextureAtlas *playerAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Player"];
                int index = 0;
                int j;
                if (absY > absX) {
                    if (dy < 0) {
                        direction = CGPointMake(playerX, playerY - 1000);
                        self.faceDirection = CGPointMake(0, -1);
                        index = 2;
                    } else {
                        direction = CGPointMake(playerX, playerY + 1000);
                        self.faceDirection = CGPointMake(0, 1);
                        index = 0;
                    }
                } else {
                    if (dx < 0) {
                        direction = CGPointMake(playerX - 1000, playerY);
                        self.faceDirection = CGPointMake(-1, 0);
                        index = 3;
                    } else {
                        direction = CGPointMake(playerX + 1000, playerY);
                        self.faceDirection = CGPointMake(1, 0);
                        index = 1;
                    }
                }
                for (j=0; j<=2; j++) {
                    NSString * textureName = [NSString stringWithFormat:@"Player%d-%d", index, j];
                    SKTexture * texture = [playerAnimatedAtlas textureNamed:textureName];
                    [walkingFrames addObject:texture];
                }
                [self removeActionForKey:@"walkingHero"];
                SKAction * animation = [SKAction repeatActionForever:
                                        [SKAction animateWithTextures: walkingFrames
                                                         timePerFrame:0.125f
                                                               resize:YES
                                                              restore:YES]];
                SKAction * move = [SKAction moveTo:direction duration:15];
                SKAction * group = [SKAction group:@[animation, move]];
                [self.player runAction: group];
            }
        }
    } else if(!GameOver){
        // 2 - Set up initial location of projectile
        [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
        SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        projectile.name = @"projectile";
        projectile.xScale = 0.6;
        projectile.yScale = 0.6;
        
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

- (void) restart {
    
    [self removeAllChildren];
    [self removeAllActions];
    [self initializeScene];
}


@end


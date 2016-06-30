//
//  MenuScene.m
//  Zombie
//
//  Created by Teresa di Tada on 6/27/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"


@implementation MenuScene
SKLabelNode *play;
SKLabelNode *title;
SKLabelNode *credits;
SKLabelNode *creditstext;
SKLabelNode *creditstext2;
bool isInCredits = NO;

-(void)initializeScene{

    title = [SKLabelNode labelNodeWithFontNamed:@"Zapfino"];
    title.fontSize = 40;
    title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.7);
    title.fontColor = [SKColor blackColor];
    title.name = @"title";
    title.zPosition = 100;
    title.text = @"Ninjas vs Zombies";
    [self addChild:title];
    
    play = [SKLabelNode labelNodeWithFontNamed:@"papyrus"];
    play.fontSize = 26;
    play.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) );
    play.fontColor = [SKColor whiteColor];
    play.name = @"play";
    play.zPosition = 100;
    play.text = @"Play";
    [self addChild:play];
    
    
    credits = [SKLabelNode labelNodeWithFontNamed:@"papyrus"];
    credits.fontSize = 26;
    credits.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 0.7);
    credits.fontColor = [SKColor whiteColor];
    credits.name = @"credits";
    credits.zPosition = 100;
    credits.text = @"Credits";
    [self addChild:credits];
    
    creditstext = [SKLabelNode labelNodeWithFontNamed:@"Avenir-Light "];
    creditstext.fontSize = 12;
    creditstext.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    creditstext.fontColor = [SKColor whiteColor];
    creditstext.name = @"creditstext";
    creditstext.zPosition = 100;
    [self addChild:creditstext];
    
    
    creditstext2 = [SKLabelNode labelNodeWithFontNamed:@"Avenir-Light "];
    creditstext2.fontSize = 12;
    creditstext2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 0.9);
    creditstext2.fontColor = [SKColor whiteColor];
    creditstext2.name = @"creditstext2";
    creditstext2.zPosition = 100;
    [self addChild:creditstext2];
    
    
    SKSpriteNode * monster = [SKSpriteNode spriteNodeWithImageNamed:@"WandererZombie0-0"];
    monster.zPosition = 50;
    monster.xScale = 0.9;
    monster.yScale = 0.9;
    monster.position = CGPointMake(CGRectGetMaxX(self.frame) * 0.8, CGRectGetMidY(self.frame) );
    [self addChild:monster];
    
    SKSpriteNode * monster2 = [SKSpriteNode spriteNodeWithImageNamed:@"SeekZombie1-1"];
    monster2.zPosition = 50;
    monster2.yScale = 0.9;
    monster2.xScale = 0.9;
    monster2.position = CGPointMake(CGRectGetMidX(self.frame) * 0.5, CGRectGetMidY(self.frame) * 0.6);
    [self addChild:monster2];
    
    SKSpriteNode * monster3 = [SKSpriteNode spriteNodeWithImageNamed:@"BombZombie2-1"];
    monster3.zPosition = 50;
    monster3.yScale = 0.9;
    monster3.xScale = 0.9;
    monster3.position = CGPointMake(CGRectGetMaxX(self.frame) * 0.9, CGRectGetMidY(self.frame) * 1.4);
    [self addChild:monster3];

    
    
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
        
        self.physicsWorld.contactDelegate = self; //declare this class as the contact delegate
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    /* Avoid multi-touch gestures (optional) */
    if ([touches count] > 1) {
        return;
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if ([node.name isEqualToString: @"play"]) {
            SKScene *sampleScene = [[GameScene alloc] initWithSize:self.size];
            SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
            [self.view presentScene:sampleScene transition:transition];
        }
        else if([node.name isEqualToString: @"credits"] && !isInCredits){
            isInCredits = YES;
           play.text = @"";
           credits.text = @"Back";
           creditstext.text = @"Created by Teresa di Tada and Jose Noriega";
            creditstext2.text = @"Copyright © 2016. All rights reserved.";
        }else if([node.name isEqualToString: @"credits"] && isInCredits){
            isInCredits = NO;
            play.text = @"Play";
            credits.text = @"Credits";
            creditstext.text = @"";
            creditstext2.text = @"";
        }
    }
}

@end
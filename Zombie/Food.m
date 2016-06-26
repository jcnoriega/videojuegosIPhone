//
//  Food.m
//  Zombie
//
//  Created by Teresa di Tada on 6/26/16.
//  Copyright © 2016 Jose Carlos Noriega Defferrari. All rights reserved.
//

#import "Food.h"

@implementation Food

int badFoodDamageInSec = 40;
int goodFoodUpInSec = 10;

+ (id) spriteNodeWithImageNamed : (NSString *) name
{
    Food * food = food = [super spriteNodeWithImageNamed: @"GoodFood0"];
    int i = (int)arc4random_uniform(5);
    
    if(i==1){
        food = [super spriteNodeWithImageNamed: @"GoodFood1"];
    }else if(i==2){
        food = [super spriteNodeWithImageNamed: @"BadFood"];
        food.name = @"badfood";
    }else if(i == 3){
        food =  [super spriteNodeWithImageNamed: @"GoodFood2"];
    }
    food.xScale = 0.4;
    food.yScale = 0.4;
    
    return food;
}

@end

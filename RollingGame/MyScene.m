//
//  MyScene.m
//  RollingGame
//
//  Created by Yashwanth on 8/22/14.
//  Copyright (c) 2014 Yashwanth. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    SKSpriteNode *play;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
       play = [SKSpriteNode spriteNodeWithImageNamed:@"start.jpg"];
        play.position=CGPointMake(160,250);
        [self addChild:play];
        self.backgroundColor=[UIColor blueColor];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([self nodeAtPoint:location]==self->play) {
            NSLog(@"hai u r into the game");
           PlayScene *scene = [PlayScene sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeResizeFill;
            SKTransition *transition = [SKTransition flipVerticalWithDuration:1.5];
            [self.view presentScene:scene transition:transition];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

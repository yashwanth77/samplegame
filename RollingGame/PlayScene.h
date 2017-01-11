//
//  PlayScene.h
//  RollingGame
//
//  Created by Yashwanth on 8/22/14.
//  Copyright (c) 2014 Yashwanth. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BlockStatus1.h"
#import "MyScene.h"
@interface PlayScene : SKScene<SKPhysicsContactDelegate>
@property NSMutableArray *explosionTextures;
@property NSMutableArray  *explosionTextures1 ;
@property NSMutableArray *cloudsTextures;
@property SKEmitterNode *smokeTrail;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) SKAction *laughSound;
@property (strong, nonatomic) SKAction *owSound;
@end

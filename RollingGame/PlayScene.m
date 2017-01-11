//
//  PlayScene.m
//  RollingGame
//
//  Created by Yashwanth on 8/22/14.
//  Copyright (c) 2014 Yashwanth. All rights reserved.
//





#import "PlayScene.h"

static const uint8_t heroCategory = 1;
static const uint8_t powerCategory = 3;
static const uint8_t blockCategory = 2;
static const uint8_t block1Category = 4;
static const uint8_t block2Category = 5;

@implementation PlayScene
{
    SKSpriteNode *runningbar;
    SKSpriteNode *hero;
    SKSpriteNode *power;
     SKSpriteNode *block1;
    SKSpriteNode *block2;
   
    SKSpriteNode *block3;
    SKSpriteNode *rollbutton;
     SKLabelNode *scoreText;
    CGFloat barx;
    CGFloat maxbarx;
    CGFloat speed;
    CGFloat herobaseline;
    BOOL onground;
    CGFloat velocity;
    CGFloat gravity;
    NSMutableDictionary *blockstatuses;
    CGFloat  blockMaxx;
    CGFloat originpositionX;
    int score;
    int count;
    int speed1;
     NSArray *_bearWalkingFrames;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        herobaseline=0;
        speed=5;
        velocity=0;
        onground=true;
        gravity=0.6;
        blockstatuses = [[NSMutableDictionary alloc]init];
        blockMaxx=0;
        originpositionX=0;
        //scoreText.fontName=@"ChalkDuster";
        score=0;
        count=0;
        speed1=5;
        
        
        NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
        _smokeTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
        _smokeTrail.position = CGPointMake(500, 500);
        
        
        
        
        block3 = [SKSpriteNode spriteNodeWithImageNamed:@"block3.png"];
        rollbutton = [SKSpriteNode spriteNodeWithImageNamed:@"hero2.gif"];
        
        
        block1 = [SKSpriteNode spriteNodeWithImageNamed:@"block1.png"];
        block2 = [SKSpriteNode spriteNodeWithImageNamed:@"block3.gif"];
        runningbar = [SKSpriteNode spriteNodeWithImageNamed:@"bottombar.jpg"];
        //hero = [SKSpriteNode spriteNodeWithImageNamed:@"hero2.gif"];
        SKTextureAtlas *explosionAtlas1 = [SKTextureAtlas atlasNamed:@"running_man"];
        NSArray *textureNames1 = [explosionAtlas1 textureNames];
        _explosionTextures1 = [NSMutableArray new];
        for (NSString *name in textureNames1) {
            SKTexture *texture1 = [explosionAtlas1 textureNamed:name];
            [_explosionTextures1 addObject:texture1];
        }
        hero = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures1 objectAtIndex:0]];
        hero.position=CGPointMake(CGRectGetMinX(self.frame)+34, herobaseline);
        //hero.zPosition = 1;
        //hero.scale = 0.6;
        [self walkingBear];
        power = [SKSpriteNode spriteNodeWithImageNamed:@"power.jpg"];
        scoreText= [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
        
        self.physicsWorld.contactDelegate=self;
        
        
        runningbar.anchorPoint=CGPointMake(0, 0.5);
        runningbar.position=CGPointMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame)+runningbar.size.height/2);
       
        barx=runningbar.position.x;
        maxbarx=runningbar.size.width-self.frame.size.width;
        maxbarx *=-1;
       //self.backgroundColor=[UIColor blueColor];
        
        
        herobaseline=runningbar.position.y+(runningbar.size.height/2)+hero.size.height/2;
        
        
       
       
        hero.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:hero.size.width/2];
        hero.physicsBody.affectedByGravity=false;
        hero.physicsBody.categoryBitMask = heroCategory;
        hero.physicsBody.contactTestBitMask = blockCategory | powerCategory|block2Category|block1Category;
    
        hero.physicsBody.collisionBitMask = 0;
        
        
        block1.position=CGPointMake(CGRectGetMaxX(self.frame)+block1.size.width, herobaseline-10);
        block2.position=CGPointMake(CGRectGetMaxX(self.frame)+block1.size.width, herobaseline);
        power.position=CGPointMake(CGRectGetMaxX(self.frame)+100, herobaseline+200);
        block3.position=CGPointMake(CGRectGetMaxX(self.frame)+300, herobaseline-20);
        rollbutton.position=CGPointMake(280,30);
        rollbutton.name = @"rollbutton";//how the node is identified later
        rollbutton.zPosition = 1.0;
        
        block1.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:block1.size];
        block1.physicsBody.dynamic=false;
        block1.physicsBody.categoryBitMask = blockCategory;
        block1.physicsBody.contactTestBitMask = heroCategory|block2Category|block1Category;
        //block1.physicsBody.collisionBitMask = 0;
        
        block2.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:block2.size];
        block2.physicsBody.dynamic=false;
        block2.physicsBody.categoryBitMask = block1Category;
        block2.physicsBody.contactTestBitMask = heroCategory|block2Category|blockCategory;
        //block2.physicsBody.collisionBitMask = 0;
        
        block3.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:block3.size];
        block3.physicsBody.dynamic=false;
        block3.physicsBody.categoryBitMask = block2Category;
        block3.physicsBody.contactTestBitMask = heroCategory|block1Category|blockCategory;
        
        power.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:power.size];
        power.physicsBody.dynamic=false;
        power.physicsBody.categoryBitMask = powerCategory;
        power.physicsBody.contactTestBitMask = heroCategory;
        //power.physicsBody.collisionBitMask = 0;
        
        
        SKTextureAtlas *explosionAtlas = [SKTextureAtlas atlasNamed:@"EXPLOSION"];
        NSArray *textureNames = [explosionAtlas textureNames];
        _explosionTextures = [NSMutableArray new];
        for (NSString *name in textureNames) {
            SKTexture *texture = [explosionAtlas textureNamed:name];
            [_explosionTextures addObject:texture];
        }
        
        
        
//        _walkFrames = [NSMutableArray new];
//        SKTextureAtlas *bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"runningman"];
//        int numImages = bearAnimatedAtlas.textureNames.count;
//        for (int i=1; i <= numImages/2; i++) {
//            NSString *textureName = [NSString stringWithFormat:@"bear%d", i];
//            SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
//            [_walkFrames addObject:temp];
//        }
//        _bearWalkingFrames = _walkFrames;
//        SKTexture *temp = _bearWalkingFrames[0];
        
        
        
        
        
        block1.name=@"block1";
        block2.name=@"block2";
        power.name=@"power";
        block3.name=@"block3";
       
        
        blockstatuses[@"block1"]=[[BlockStatus1 alloc]init];
        blockstatuses[@"block2"]=[[BlockStatus1 alloc]init];
        blockstatuses[@"power"]=[[BlockStatus1 alloc]init];
        blockstatuses[@"block3"]=[[BlockStatus1 alloc]init];
        blockstatuses[@"cloud2"]=[[BlockStatus1 alloc]init];
        
        [blockstatuses[@"block1"] findStatus:false withGap:[self myrandom] withInterval:0];
        [blockstatuses[@"block2"] findStatus:false withGap:[self getRandomNumberBetween:101 to:201] withInterval:0];
        [blockstatuses[@"power"] findStatus:false withGap:[self myrandom1] withInterval:0];
        [blockstatuses[@"block3"] findStatus:false withGap:[self getRandomNumberBetween:151 to:251] withInterval:0];
         [blockstatuses[@"cloud2"] findStatus:false withGap:[self getRandomNumberBetween:2 to:3] withInterval:0];
        
        scoreText.text=@"0";
        scoreText.fontSize=42;
        scoreText.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100);
        blockMaxx=0-block1.size.width/2;
        originpositionX=block1.position.x;
        
        
        self.laughSound = [SKAction playSoundFileNamed:@"laugh.caf" waitForCompletion:NO];
        self.owSound = [SKAction playSoundFileNamed:@"ow.caf" waitForCompletion:NO];
        
        
        
        // Add at bottom of popMole method, change the sequence action to:
        //SKAction *sequence = [SKAction sequence:@[ self.laughSound]];
        
        // Add inside touchesBegan: method, change the sequence action to:
        //SKAction *sequence1 = [SKAction sequence:@[self.owSound]];
        
         [self addChild:hero];
         [self addChild:runningbar];
         [self addChild:block1];
        [self addChild:block2];
        [self addChild:scoreText];
        [self addChild:power];
        [self addChild:block3];
        //[self addChild:rollbutton];
        [self addChild:_smokeTrail];
       
    }
    return self;
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}
-(void)walkingBear
{
    //This is our general runAction method to make our man walk.
    SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures1 timePerFrame:0.07];
    //SKAction *remove = [SKAction removeFromParent];
    [hero runAction:[SKAction repeatActionForever:explosionAction]];
    return;
}

-(void)update:(CFTimeInterval)currentTime {
    
    
    
    
    
    if (runningbar.position.x <= maxbarx) {
        runningbar.position=CGPointMake(0, CGRectGetMinY(self.frame)+runningbar.size.height/2);
       
    }
    
    
    //hero.zRotation -= speed* M_PI/180;
    velocity += gravity;
    
    CGPoint herotemp = hero.position;
    herotemp.y -=velocity;
    hero.position=herotemp;
    
    if (hero.position.y < herobaseline) {
        CGPoint temp = hero.position;
        temp.y =herobaseline;
        hero.position=temp;
        velocity=0;
        onground=true;
    }
    
    
    
    
    CGPoint temp = runningbar.position;
    temp.x -=speed;
    runningbar.position=temp;
    
    [self blockRunner];
     //[self createObjects];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (onground && ! [node.name isEqualToString:@"rollbutton"]) {
        velocity=-18;
        onground=false;
    }
    
    
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"rollbutton"]) {
        hero.zRotation -= 300* M_PI/180;
    }
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (velocity < -9.0) {
        velocity=-9.0;
    }
}

-(UInt32)myrandom
{
    return (arc4random() % 100) + 50;
}
-(UInt32)myrandom1
{
    return (arc4random() % 3000) + 2000;
}

-(void)blockRunner
{
    for (NSString *block in blockstatuses){
        SKNode *thisblock=[self childNodeWithName:block];
        BlockStatus1 *bs=[blockstatuses objectForKey:block];
        if ([bs shoulRunBlock]) {
            if ([block isEqual:@"power"]) {
                bs.timeGapForNextRun=[self myrandom1];
            }
            if ([block isEqual:@"cloud1"] || [block isEqual:@"cloud2"]) {
                bs.timeGapForNextRun=[self myrandom];
            }
            bs.timeGapForNextRun=[self myrandom];
            bs.currentInterval=0;
            bs.isRunning=true;
            
            
//            int randomClouds = [self getRandomNumberBetween:10 to:40];
//            if(randomClouds%10==0){
//                
//                int whichCloud = [self getRandomNumberBetween:0 to:3];
//                SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithTexture:[_cloudsTextures objectAtIndex:whichCloud]];
//                int randomYAxix = [self getRandomNumberBetween:herobaseline to:self.size.height];
//                cloud.position = CGPointMake(self.size.height+cloud.size.height/2, randomYAxix);
//                cloud.zPosition = 1;
//                int randomTimeCloud = [self getRandomNumberBetween:1 to:9];
//                
//                SKAction *move =[SKAction moveTo:CGPointMake(cloud.size.height, randomYAxix) duration:randomTimeCloud];
//                //SKAction *remove = [SKAction removeFromParent];
//                [cloud runAction:[SKAction repeatActionForever:move]];
//                //[cloud runAction:[SKAction sequence:@[remove]]];
//                [self addChild:cloud];
//            }
            

        }
        
       
        if (bs.isRunning) {
            if (thisblock.position.x>blockMaxx) {
               
                CGPoint temp = thisblock.position;
                temp.x -=speed;
                thisblock.position=temp;
            }
            else{
                CGPoint temp = thisblock.position;
                temp.x =originpositionX;
                //temp.x=500;
                thisblock.position=temp;
                bs.isRunning=false;
                
                
                if ([block isEqual:@"block1"]||[block isEqual:@"block2"] || [block isEqual:@"block3"]) {
                     score++;
                    if ((score%20)==0) {
                      speed1=  speed+.5;
                        NSLog(@"speed %f",speed);
                        NSLog(@"speed1 %d",speed1);
                    }
                }
               
                
                
                
                
                
            
                scoreText.text=[@(score) stringValue];
            }
        }
        else{
            bs.currentInterval++;
        }
    }
    
        
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
    
    
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    
    if (contact.bodyA.categoryBitMask ==2 || contact.bodyA.categoryBitMask==4 ||contact.bodyA.categoryBitMask==5 ) {
        NSLog(@"col is %u",collision);
             [self died];
    }
    
    else if (contact.bodyA.categoryBitMask==3 && contact.bodyB.categoryBitMask==1)
    {
        NSLog(@"haii");
        //[power removeFromParent];
        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
        explosion.zPosition = 1;
        explosion.scale = 0.6;
        explosion.position = contact.bodyA.node.position;
        
        [self addChild:explosion];
        
        SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.07];
        SKAction *remove = [SKAction removeFromParent];
        [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(myspeed:)
                                       userInfo:nil
                                        repeats:YES];

       
        
    }
   

    
    
    


      }


-(void)myspeed:(NSTimer *)timer
{
    speed=speed1+5;
    count++;
    block1.physicsBody.categoryBitMask = 0;
    block1.physicsBody.contactTestBitMask = 0;
    block1.physicsBody.collisionBitMask = 0;
    
    
    block2.physicsBody.categoryBitMask = 0;
    block2.physicsBody.contactTestBitMask = 0;
    block2.physicsBody.collisionBitMask = 0;
    
    block3.physicsBody.categoryBitMask = 0;
    block3.physicsBody.contactTestBitMask = 0;
    block3.physicsBody.collisionBitMask = 0;
    
    hero.physicsBody.categoryBitMask = 0;
    hero.physicsBody.contactTestBitMask = 0;
    hero.physicsBody.collisionBitMask = 0;
    if (count>50) {
        
        if (speed==0) {
            speed=5;
        }
        else{
            speed=speed1;
        }
        NSLog(@"updated speed is %f",speed);
        NSLog(@"updated speed1 is %d",speed1);
        hero.physicsBody.categoryBitMask = heroCategory;
        hero.physicsBody.contactTestBitMask = blockCategory | powerCategory;
        
        block1.physicsBody.categoryBitMask = blockCategory;
        block1.physicsBody.contactTestBitMask = heroCategory;
        
        block2.physicsBody.categoryBitMask = blockCategory;
        block2.physicsBody.contactTestBitMask = heroCategory;
        
        block3.physicsBody.categoryBitMask = blockCategory;
        block3.physicsBody.contactTestBitMask = heroCategory;
        count=0;
        [timer invalidate];
    }
    
    

}



-(void)died
{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"laugh" withExtension:@"caf"];
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (!self.audioPlayer) {
        NSLog(@"Error creating player: %@", error);
    }
    
    [self.audioPlayer play];
    
    
    
    SKScene *sampleScene = [[MyScene alloc] initWithSize:self.size];
    sampleScene.scaleMode=SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
    [self.view presentScene:sampleScene transition:transition];
}





-(void)createObjects {
    
    // Create random start point
    //float randomStartPoint = arc4random_uniform(4) * 64 + 32;
    CGPoint startPoint = CGPointMake(150,300);
    
    // Create random object and add to scene
    SKTexture* objectTexture;
    switch (arc4random_uniform(2)) {
        case 0:
            objectTexture = [SKTexture textureWithImageNamed:@"images-12.jpg"];
            break;
        case 1:
           // objectTexture = [SKTexture textureWithImageNamed:@"imgres-3.jpg"];
            break;
        default:
            break;
    }
    SKSpriteNode *object = [SKSpriteNode spriteNodeWithTexture:objectTexture];
    object.position=CGPointMake(20, 20);
    object.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:object.size];
    object.physicsBody.dynamic = YES;
    object.physicsBody.affectedByGravity = NO;
    object.physicsBody.categoryBitMask = 0;
    object.physicsBody.collisionBitMask = 0;
    object.physicsBody.contactTestBitMask = 0;
    
    object.position = startPoint;
    object.name = @"object";
    object.zPosition = 20;
    
    [self addChild: object];
}
@end

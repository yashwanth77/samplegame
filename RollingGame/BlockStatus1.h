//
//  BlockStatus1.h
//  RollingGame
//
//  Created by Yashwanth on 8/25/14.
//  Copyright (c) 2014 Yashwanth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockStatus1 : NSObject
@property (nonatomic, assign)  BOOL isRunning;
@property (nonatomic, assign) UInt32 timeGapForNextRun;
@property (nonatomic, assign)UInt32 currentInterval;
-(BOOL)shoulRunBlock;
-(void)findStatus:(BOOL)isrunning withGap:(UInt32)timegapForNextRun withInterval:(UInt32)currentinterval;

@end

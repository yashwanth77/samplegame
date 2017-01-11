//
//  BlockStatus1.m
//  RollingGame
//
//  Created by Yashwanth on 8/25/14.
//  Copyright (c) 2014 Yashwanth. All rights reserved.
//

#import "BlockStatus1.h"
  @implementation BlockStatus1

//+ (id)sharedManager:(BOOL)isrunning withGap:(UInt32)timegapForNextRun withInterval:(UInt32)currentinterval {
//    static BlockStatus1 *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//        
//    });
//    [self findStatus:isrunning withGap:timegapForNextRun withInterval:currentinterval];
//    return sharedMyManager;
//}

-(void)findStatus:(BOOL)isrunning withGap:(UInt32)timegapForNextRun withInterval:(UInt32)currentinterval
{
  self. isRunning=isrunning;
    self.timeGapForNextRun=timegapForNextRun;
    self.currentInterval=currentinterval;
}

-(BOOL)shoulRunBlock
{
    return self.currentInterval > self.timeGapForNextRun;
    //return true;
}
@end

//
//  MtcDoodleDelegate.h
//  JusCall
//
//  Created by Fiona on 10/31/15.
//  Copyright © 2015 Fiona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JusCall.h"

#define dWidth ([UIScreen mainScreen].bounds.size.width*1.0)
#define dHeight (16*dWidth/9)

@protocol MtcDoodleDelegate

- (void)doodleDidStart;
- (void)doodleDidStop;

@end

@interface MtcDoodleManager : NSObject 

+ (void) Init: (JCallId)callId delegate:(id<MtcDoodleDelegate>)delegate;
+ (void) Destroy:(JCallId) callId;
+ (void) StartDoodle:(JCallId) callId pageCount:(int) pageCount imageFilePaths:(NSArray *)imageFilePaths;
+ (void) StopDoodle:(JCallId)callId;
@end
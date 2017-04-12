//
//  MtcRing.h
//  BatterHD
//
//  Created by Loc on 13-5-8.
//  Copyright (c) 2013年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

void MtcRingInit(NSURL *fileURL);
void MtcRingReset(NSURL *fileURL);

void MtcRingStartRing();
void MtcRingStopRing();

BOOL MtcRingIsPlaying();
void MtcRingStartPlay();
void MtcRingStopPlay();

void MtcRingResetCategory();

BOOL MtcAudioAccessoryConnected();

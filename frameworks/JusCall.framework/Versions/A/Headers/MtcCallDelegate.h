//
//  MtcCallDelegate.h
//  VoIPTester
//
//  Created by Loc on 13-7-26.
//  Copyright (c) 2013年 juphoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JusCall.h"

extern NSString * const CallIncomingNotificationCategory;
extern NSString * const CallIncomingNotificationActionAnswer;
extern NSString * const CallIncomingNotificationActionDecline;
extern NSString * const CallIncomingNotificationSessionKey;

#define EN_CALL_DELEGATE_FAIL_CALL                 -1
#define EN_CALL_DELEGATE_FAIL_ANSWER               -2
#define EN_CALL_DELEGATE_FAIL_CALL_DISC            -3
#define EN_CALL_DELEGATE_FAIL_CALL_PICKUPX         -4
#define EN_CALL_DELEGATE_FAIL_AUDIO_DEVICE         -5
#define EN_CALL_DELEGATE_FAIL_CALL_AUDIO_INIT      -6
#define EN_CALL_DELEGATE_FAIL_ANSWER_AUDIO_INIT    -7

#define kCallPause "Call Pause"
#define kCallInterrupt "Call Interrupt"
#define kCallResume "Call Resume"
#define kVideoPause "Video Pause"
#define kVideoResume "Video Resume"
#define kVideoOff "Video Off"
#define kVideoOn "Video On"

enum {
    CallStateNone,
    CallStateIncoming,
    CallStateAnswering,
    CallStateCalling,
    CallStateOutgoing,
    CallStateAlertedRing,
    CallStateConnecting,
    CallStateTalking,
    CallStateDisconnected,
    CallStateEnding
};

@protocol MtcCallDelegate

@required

- (void)call:(NSString *)uri displayName:(NSString *)displayName peerDisplayName:(NSString *)peerDisplayName isVideo:(BOOL)isVideo;
- (void)incoming:(JCallId)dwSessId animated:(BOOL)animated;
- (void)outgoing:(JCallId)dwSessId;
- (void)alerted:(JCallId)dwSessId alertType:(int)dwAlertType;
- (void)connecting:(JCallId)dwSessId;
- (void)talking:(JCallId)dwSessId;
- (void)termed:(JCallId)dwSessId statCode:(JStatusCode)dwStatCode reason:(const char *)pcReason;
- (void)logouted:(JStatusCode)dwStatCode;

- (void)callIncomingAnswer:(JCallId)dwSessId phone:(NSString *)phone;
- (void)callIncomingDecline:(JCallId)dwSessId;

- (void)startPreview;
- (void)startVideo:(JCallId)dwSessId;
- (void)stopVideo:(JCallId)dwSessId;

- (void)netStaChanged:(JCallId)dwSessId video:(int)bVideo send:(int)bSend status:(int)iStatus;

- (void)session:(JCallId)dwSessId info:(char *)pcInfo;

- (void)didBecomeActive;
- (void)connectionChanged;

- (BOOL)isCalling;
- (BOOL)isTalking;

@end

extern Class MtcCallDelegateClass();
extern UILocalNotification * MtcCallDelegateIncomingNotification(JCallId dwSessId);

@interface MtcCallManager : NSObject 

+ (void) Init;
+ (void) Set : (id<MtcCallDelegate>)callDelegate;

+ (void) Call : (NSString *)number displayName:(NSString *)displayName peerDisplayName : (NSString *)peerDisplayName isVideo:(BOOL)isVideo;

+ (void) DidBecomeActive;
+ (void) ConnectionChanged;

+ (void) Answer : (JCallId)dwSessId;
+ (void) Decline : (JCallId)dwSessId;

+ (BOOL) IsCalling;
+ (BOOL) IsTalking;
+ (BOOL) IsCSCalling;

+ (void) SetTrafficMode : (int)mode;

+ (int) GetTrafficMode;

+ (BOOL) CheckNet : (NSString *)phone;

+ (void) SetEnabled : (NSString *)key isEnabled : (BOOL) isEnabled;
+ (BOOL) GetEnabled : (NSString *)key;

+ (void) AutoAnswer : (BOOL)isEnabled withVideo : (BOOL) withVideo;

+ (void) SetPreviewScale : (CGFloat) scale;
+ (CGFloat) GetPreviewScale;

+ (void) SetPreviewAxis : (CGFloat)xscale yscale : (CGFloat) yscale;
+ (CGPoint) GetPreviewAxis;

@end
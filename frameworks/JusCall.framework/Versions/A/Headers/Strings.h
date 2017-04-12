//
//  Strings.h
//  Batter
//
//  Created by cathy on 12-10-22.
//  Copyright (c) 2011Âπ?__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMagnifierEnabled @"MagnView"
#define kAutoAnswerEnabled @"AutoAnswerEnabled"
#define kAutoAnswerWithVideo @"AutoAnswerWithVideo"

#define resourceBundlePath [[NSBundle mainBundle] pathForResource:@"JusCall" ofType:@"bundle"]
#define resourcesBundle [NSBundle bundleWithPath:resourceBundlePath]

#define LocalizedString(key) [resourcesBundle localizedStringForKey:(key) value:@"" table:nil]

#define kStringOk LocalizedString(@"OK")

#define kStringUnverifiedNumber LocalizedString(@"Unverified number")

#define kStringCancel LocalizedString(@"Cancel")

//keypad
#define kStringCalleeHasNotInstalled LocalizedString(@"\"%@\" Hasn't Installed %@")

#define kStringTemporarilyUnavailableTitle LocalizedString(@"Temporarily Unavailable")
#define kStringOfflineTitle LocalizedString(@"Offline")
#define kStringOfflineMessage LocalizedString(@"\"%@\" is offline.")

//call
//call-button
#define kStringEnd LocalizedString(@"End")
#define kStringAnswer LocalizedString(@"Answer")
#define kStringDecline LocalizedString(@"Decline")
#define kstringText LocalizedString(@"Text")
#define kstringAddVideo LocalizedString(@"add video")
#define kstringAddCall LocalizedString(@"add call")
#define kstringContacts LocalizedString(@"contacts")
#define kStringRedial LocalizedString(@"Redial")
#define kStringNotifyTitle LocalizedString(@"Notify")
#define kStringNotify LocalizedString(@"notify")
#define kStringCallShare LocalizedString(@"call share")
#define kStringMute LocalizedString(@"mute")
#define kStringSwitch LocalizedString(@"switch")
#define kStringSpeaker LocalizedString(@"speaker")
#define kStringRegularCall LocalizedString(@"Regular Call")
#define kStringAudio LocalizedString(@"audio")
#define kStringCameraOff LocalizedString(@"camera off")
#define kStringCameraOffTitle LocalizedString(@"Camera Off")
#define kstringCameraOn LocalizedString(@"camera on")
#define kStringIgnore LocalizedString(@"Ignore")
#define kStringEndAndAnswer LocalizedString(@"End & Answer")
#define kStringEndAndVoiceAnswer LocalizedString(@"End & Voice Answer")
#define kStringEndAndVideoAnswer LocalizedString(@"End & Video Answer")
#define kStringAddToCall LocalizedString(@"Add to Call")

//call-status
#define kStringAnswering LocalizedString(@"answering")
#define kStringCalling LocalizedString(@"calling")
#define kStringRinging LocalizedString(@"ringing")
#define kStringConnecting LocalizedString(@"connecting")
#define kStringCallEnding LocalizedString(@"call ending")
#define kStringCallEnded LocalizedString(@"call ended")

//call-error status
#define kStringCallReconnecting LocalizedString(@"reconnecting")
#define kStringCallDisconnected LocalizedString(@"call disconnected")
#define kStringCallPaused LocalizedString(@"call paused")
#define kStringCallInterrupted LocalizedString(@"call interrupted")
#define kStringVideoPaused LocalizedString(@"video paused")
#define kStringVideoCameraOff LocalizedString(@"video camera off")
#define kStringVideoPausedForQoS LocalizedString(@"video paused for QoS")
#define kStringSwitchedToVoiceCall LocalizedString(@"switched to voice call")
#define kStringPoorConnection LocalizedString(@"poor connection")
#define kStringCheckNetwork LocalizedString(@"check the network connection")

//call-term
#define kStringHasNotBeenInstalled LocalizedString(@"%@ hasn't been installed")
#define kStringCalleeOffline LocalizedString(@"callee is offline")
#define kStringOffline LocalizedString(@"offline")
#define kStringCalleeBusy LocalizedString(@"callee is busy")
#define kStringNoAnswer LocalizedString(@"no answer")
#define kStringTemporarilyUnavailable LocalizedString(@"temporarily unavailable")
#define kStringNoInternetConnection LocalizedString(@"no Internet connection")

//call-notification
#define kStringVoiceCallFrom LocalizedString(@"Voice call from")
#define kStringVideoCallFrom LocalizedString(@"Video call from")
#define kStringMissedVoiceCallFrom LocalizedString(@"Missed voice call from")
#define kStringMissedVideoCallFrom LocalizedString(@"Missed video call from")

#define kStringTouchToReturnToCall LocalizedString(@"Touch to return to call")

#define kStringPleaseHangUpTheRegularCallBeforeYouAnswer LocalizedString(@"Please hang up the regular call before you answer %@.")

#define kStringCall LocalizedString(@"Call")
#define kStringClose LocalizedString(@"Close")

//call-error
#define kStringAudioDeviceInitializationFailed LocalizedString(@"Audio device initialization failed.")
#define kStringAudioDeviceError LocalizedString(@"Audio device error.")
#define kStringAudioDeviceOccupied LocalizedString(@"audio device occupied")

//call-statistics
#define kStringStatistics LocalizedString(@"Statistics")
#define kStringVoiceTitle LocalizedString(@"Voice")
#define kStringVideoTitle LocalizedString(@"Video")
#define kStringNotRunning LocalizedString(@"Not running")

//call-check
#define kStringCannotCallYourself LocalizedString(@"Can't call yourself")

//format
#define kStringFormatStringString LocalizedString(@"%@ %@")
//
//  YBViewController.m
//  yunba-demo
//
//  Created by YunBa on 13-12-6.
//  Copyright (c) 2013年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBViewController.h"

@interface YBViewController ()
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *yunbaScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *demoScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *messageListScrollView;

// pub/sub view
@property (strong, nonatomic) IBOutlet UIView *pubSubView;
@property (retain, nonatomic) IBOutlet UISwitch *subscribedSwitch;
@property (retain, nonatomic) IBOutlet UITextField *subTopicText;
@property (retain, nonatomic) IBOutlet UIButton *pubButton;
@property (retain, nonatomic) IBOutlet UITextField *pubContentText;
@property (retain, nonatomic) IBOutlet UITextField *pubTopicText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pubQosSegment;

// alias view
@property (strong, nonatomic) IBOutlet UIView *aliasView;
@property (retain, nonatomic) IBOutlet UIButton *aliasSetButton;
@property (retain, nonatomic) IBOutlet UITextField *aliasSetText;
@property (retain, nonatomic) IBOutlet UIButton *aliasGetButton;
@property (retain, nonatomic) IBOutlet UITextField *aliasGetText;

// presence view
@property (strong, nonatomic) IBOutlet UIView *presenceView;
@property (retain, nonatomic) IBOutlet UISwitch *presenceSubSwitch;
@property (retain, nonatomic) IBOutlet UITextField *presenceSubText;
@property (retain, nonatomic) IBOutlet UIButton *aliasPubButton;
@property (retain, nonatomic) IBOutlet UITextField *aliasPubContentText;
@property (retain, nonatomic) IBOutlet UITextField *aliasPubText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aliasPubQosSegment;

// get topic list /get alias list /get state view
@property (strong, nonatomic) IBOutlet UIView *getsView;
@property (retain, nonatomic) IBOutlet UIButton *getTopicListButton;
@property (retain, nonatomic) IBOutlet UITextField *getTopicListText;
@property (retain, nonatomic) IBOutlet UIButton *getStateButton;
@property (retain, nonatomic) IBOutlet UITextField *getStateText;
@property (retain, nonatomic) IBOutlet UIButton *getAliasListButton;
@property (retain, nonatomic) IBOutlet UITextField *getAliasListText;

// pub2 view
@property (strong, nonatomic) IBOutlet UIView *pub2View;
@property (weak, nonatomic) IBOutlet UIButton *pub2Button;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pub2TypeSegment;
@property (weak, nonatomic) IBOutlet UITextField *pub2TopicText;
@property (weak, nonatomic) IBOutlet UITextField *pub2ContentText;
@property (weak, nonatomic) IBOutlet UITextField *pub2AlertText;
@property (weak, nonatomic) IBOutlet UITextField *pub2BadgeText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pub2SoundSegment;
@property (weak, nonatomic) IBOutlet UITextField *pub2Key1Text;
@property (weak, nonatomic) IBOutlet UITextField *pub2Value1Text;

//v2 get topic list /get alias list /get state view
@property (strong, nonatomic) IBOutlet UIView *getsV2View;
@property (retain, nonatomic) IBOutlet UIButton *getTopicListV2Button;
@property (retain, nonatomic) IBOutlet UITextField *getTopicListV2Text;
@property (retain, nonatomic) IBOutlet UIButton *getStateV2Button;
@property (retain, nonatomic) IBOutlet UITextField *getStateV2Text;
@property (retain, nonatomic) IBOutlet UIButton *getAliasListV2Button;
@property (retain, nonatomic) IBOutlet UITextField *getAliasListV2Text;

@end

@implementation YBViewController {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNotificationHandler];
    UITapGestureRecognizer *tabToDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyboard)];
    [_yunbaScrollView addGestureRecognizer:tabToDismissKeyboard];
    _yunbaScrollView.scrollsToTop = NO;
    _demoScrollView.scrollsToTop = NO;
    _messageListScrollView.scrollsToTop = YES;
    
    CGRect subViewRect = _demoScrollView.bounds;
    int i = 0;
    for (UIView * subView in @[_pubSubView, _aliasView, _presenceView, _getsView, _pub2View, _getsV2View]) {
        subViewRect.origin.x = i * subViewRect.size.width;
        [subView setFrame:subViewRect];
        [_demoScrollView addSubview:subView];
        i++;
    }
    [_demoScrollView setContentSize:CGSizeMake(i*subViewRect.size.width, subViewRect.size.height)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)addNotificationHandler {
    NSNotificationCenter *defaultNC = [NSNotificationCenter defaultCenter];
    [defaultNC addObserver:self selector:@selector(onConnectionStateChanged:) name:kYBConnectionStatusChangedNotification object:nil];
    [defaultNC addObserver:self selector:@selector(onMessageReceived:) name:kYBDidReceiveMessageNotification object:nil];
    [defaultNC addObserver:self selector:@selector(onPresenceReceived:) name:kYBDidReceivePresenceNotification object:nil];
}

- (void)removeNotificationHandler {
    NSNotificationCenter *defaultNC = [NSNotificationCenter defaultCenter];
    [defaultNC removeObserver:self];
}

- (void)onConnectionStateChanged:(NSNotification *)notification {
    if ([YunBaService isConnected]) {
        NSLog(@"didConnect");
        NSString *prompt = [NSString stringWithFormat:@"[YunBaService] => didConnect"];
        [self addMsgToTextView:prompt alert:YES];
        _statusLabel.text = @"connected";
    } else {
        NSLog(@"didDisconnected");
        NSString *prompt = [NSString stringWithFormat:@"[YunBaService] => disconnected"];
        [self addMsgToTextView:prompt alert:YES];
        _statusLabel.text = @"disconnected";
    }
}

- (void)onMessageReceived:(NSNotification *)notification {
    YBMessage *message = [notification object];
    NSLog(@"new message, %zu bytes, topic=%@", (unsigned long)[[message data] length], [message topic]);
    NSString *payloadString = [[NSString alloc] initWithData:[message data] encoding:NSUTF8StringEncoding];
    NSLog(@"data: %@ %@", payloadString,[message data]);
    NSString *curMsg = [NSString stringWithFormat:@"[Message] %@ => %@", [message topic], payloadString];
    [self addMsgToTextView:curMsg];
}

- (void)onPresenceReceived:(NSNotification *)notification {
    YBPresenceEvent *presence = [notification object];
    NSLog(@"new presence, action=%@, topic=%@, alias=%@, time=%lf", [presence action], [presence topic], [presence alias], [presence time]);
        
    NSString *curMsg = [NSString stringWithFormat:@"[Presence] %@:%@ => %@[%@]", [presence topic], [presence alias], [presence action], [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[presence time]/1000] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];
    [self addMsgToTextView:curMsg];
}

- (void)addMsgToTextView:(NSString *)message {
    [self addMsgToTextView:message alert:NO];
}
- (void)addMsgToTextView:(NSString *)message alert:(BOOL)alert {
    UILabel *newMessageLabel = [[UILabel alloc] initWithFrame:_messageListScrollView.bounds];
    newMessageLabel.numberOfLines = 12;
    newMessageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    newMessageLabel.font = [UIFont systemFontOfSize:10.f];
    newMessageLabel.text = message;
    if (alert) {
        newMessageLabel.textColor = [UIColor redColor];
    }
    [newMessageLabel sizeToFit];
    
    //already scrolled to bottom
    BOOL shouldScrollToBottom = _messageListScrollView.contentOffset.y + _messageListScrollView.bounds.size.height >= _messageListScrollView.contentSize.height ? YES:NO;
    
#define SPACE_BETWEEN_MESSAGE_LABEL (2)
    float offset = _messageListScrollView.contentSize.height;
    if (offset > .1f) {
        offset += SPACE_BETWEEN_MESSAGE_LABEL;
    }
    newMessageLabel.frame = CGRectMake(0, offset, _messageListScrollView.bounds.size.width, newMessageLabel.bounds.size.height);
    [_messageListScrollView addSubview:newMessageLabel];
    _messageListScrollView.contentSize = CGSizeMake(_messageListScrollView.contentSize.width, newMessageLabel.frame.origin.y + newMessageLabel.bounds.size.height);
    
    if (shouldScrollToBottom) {
        float newOffset = _messageListScrollView.contentSize.height-_messageListScrollView.bounds.size.height;
        [_messageListScrollView setContentOffset:CGPointMake(0, newOffset > 0 ? newOffset:0) animated:NO];
    }
}

- (void)alertWithContent:(NSString *)contet {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"yunba-demo" message:contet delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -- keyboard appear/disappear, make view scroll
- (void)keyboardFrameChanged:(NSNotification *)notification {
    NSValue *rectValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if (rectValue) {
        CGRect scrollRect = [_yunbaScrollView frame];
        CGRect keyboardRect = [rectValue CGRectValue];
        CGRect keyboardRectInView = [self.view convertRect:keyboardRect fromView:nil];
        CGFloat upScrollHeight = scrollRect.origin.y + scrollRect.size.height - keyboardRectInView.origin.y;
        
        // anination args
        NSNumber *numDuration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *numCurve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animate to scroll up
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[numDuration doubleValue]];
        [UIView setAnimationCurve:[numCurve unsignedIntegerValue]];
        if (upScrollHeight > 0.f) {
            [_yunbaScrollView setContentOffset:CGPointMake(0, upScrollHeight)];
        } else {
            [_yunbaScrollView setContentOffset:CGPointZero];
        }
        [UIView commitAnimations];
    }
}

#pragma mark -- pubSub view
- (IBAction)onSwitchSub:(id)sender {
    if (![[_subTopicText text] length]) {
        [_subscribedSwitch setOn:![_subscribedSwitch isOn] animated:YES];
        [self alertWithContent:@"no sub topic set"];
        [_subTopicText becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    if ([_subscribedSwitch isOn]) {
        NSString *topic = [_subTopicText text];
        [YunBaService subscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe to topic(%@) succeed", topic]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe to topic(%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  subscribe topic: %@", [_subTopicText text]]];
    } else {
        NSString *topic = [_subTopicText text];
        [YunBaService unsubscribe:topic resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe to topic(%@) succeed", topic]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe to topic(%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  unsubscribe topic: %@", [_subTopicText text]]];
    }
}
- (IBAction)onSubTopicChanged:(id)sender {
    if ([_subscribedSwitch isOn]) {
        [_subscribedSwitch setOn:NO animated:YES];
    }
}
- (IBAction)onSubTopicFinshed:(id)sender {
    [_subscribedSwitch setOn:![_subscribedSwitch isOn] animated:YES];
    [self onSwitchSub:_subscribedSwitch];
}

- (IBAction)onPubButton:(id)sender {
    if (![[_pubTopicText text] length]) {
        [self alertWithContent:@"no pub topic set"];
        [_pubTopicText becomeFirstResponder];
        return;
    }

    [self hideAllKeyboard];

    NSString *topic = [_pubTopicText text];
    NSData *data = [[_pubContentText text] dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 qosLevel = [_pubQosSegment selectedSegmentIndex];
    BOOL isRetained = NO;
    [YunBaService publish:topic data:data option:[YBPublishOption optionWithQos:qosLevel retained:NO] resultBlock:^(BOOL succ, NSError *error){
        if (succ) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to topic(%@) succeed", [_pubContentText text], topic]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to topic(%@) failed: %@, recovery suggestion: %@", [_pubContentText text], topic, error,  [error localizedRecoverySuggestion]]];
        }
    }];
    
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ toTopic %@ atQos %hhu retainFlag %d", [_pubContentText text], [_pubTopicText text], qosLevel, isRetained]];
}

- (IBAction)onPubTopicFinshed:(id)sender {
    [_pubContentText becomeFirstResponder];
}
- (IBAction)onPubContentFinshed:(id)sender {
    [self onPubButton:_pubButton];
}

#pragma mark -- alias view
- (IBAction)onAliasSetButton:(id)sender {
    if (![_aliasSetText text]) {
        [self alertWithContent:@"no alias set"];
        [_aliasSetText becomeFirstResponder];
        return;
    }
    
    [self hideAllKeyboard];
    
    NSString *alias = [_aliasSetText text];
    NSString *aliasPrompt = alias.length ? [NSString stringWithFormat:@"set alias(%@)", alias] : @"unset alias";
    
    [YunBaService setAlias:alias resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] %@ succeed", aliasPrompt]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] %@ failed: %@, recovery suggestion: %@", aliasPrompt, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] %@", aliasPrompt]];
}
- (IBAction)onAliasSetFinshed:(id)sender {
    [self onAliasSetButton:_aliasSetButton];
}

- (IBAction)onAliasGetButton:(id)sender {
    [self hideAllKeyboard];
    
    [YunBaService getAlias:^(NSString *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            NSString *alias = res;
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias(%@) succeed", alias]];
            [_aliasGetText setText:alias];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias failed: %@, recovery suggestion: %@", error, [error localizedRecoverySuggestion]]];
        }
    }];
    
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get alias"]];
}

#pragma mark -- subscribe presence / publish to alias view
- (IBAction)onPresenceSubSwitch:(id)sender {
    if (![[_presenceSubText text] length]) {
        [_presenceSubSwitch setOn:![_presenceSubSwitch isOn] animated:YES];
        [self alertWithContent:@"no sub alias set"];
        [_presenceSubText becomeFirstResponder];
        return;
    }
    [self hideAllKeyboard];
    NSString *alias = [_presenceSubText text];

    if ([_presenceSubSwitch isOn]) {
        [YunBaService subscribePresence:alias resultBlock:^(BOOL succ, NSError *error) {
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe presence to alias(%@) succeed", alias]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] subscribe presence to alias(%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  subscribe presence to alias %@", alias]];
    } else {
        [YunBaService unsubscribePresence:alias resultBlock:^(BOOL succ, NSError *error) {
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe presence to alias(%@) succeed", alias]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] unsubscribe presence to alias(%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
            }
        }];
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo]  unsubscribe presence to alias %@", alias]];
    }
}
- (IBAction)onPresenceSubAliasChanged:(id)sender {
    if ([_presenceSubSwitch isOn]) {
        [_presenceSubSwitch setOn:NO animated:YES];
    }
}
- (IBAction)onPresenceSubFinshed:(id)sender {
    [_presenceSubSwitch setOn:![_presenceSubSwitch isOn] animated:YES];
    [self onPresenceSubSwitch:_presenceSubSwitch];
}

- (IBAction)onAliasPubButton:(id)sender {
    if (![[_aliasPubText text] length]) {
        [self alertWithContent:@"no alias set"];
        [_aliasPubText becomeFirstResponder];
        return;
    }
    
    [self hideAllKeyboard];
    
    NSString *alias = [_aliasPubText text];
    NSData *data = [[_aliasPubContentText text] dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 qosLevel = [_aliasPubQosSegment selectedSegmentIndex];
    BOOL isRetained = NO;
    [YunBaService publishToAlias:alias data:data option:[YBPublishOption optionWithQos:qosLevel retained:NO] resultBlock:^(BOOL succ, NSError *error){
        if (succ) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to alias(%@) succeed", [_aliasPubContentText text], alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to alias(%@) failed: %@, recovery suggestion: %@", [_aliasPubContentText text], alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ to alias %@ atQos %hhu retainFlag %d", [_aliasPubContentText text], alias, qosLevel, isRetained]];
}

- (IBAction)onAliasPubTopicFinshed:(id)sender {
    [_aliasPubContentText becomeFirstResponder];
}
- (IBAction)onAliasPubContentFinshed:(id)sender {
    [self onAliasPubButton:_aliasPubButton];
}

#pragma mark -- get topic list /get state /get alias list view
- (IBAction)onTopicListGetButton:(id)sender {
    [self hideAllKeyboard];
    
    NSString *alias = [[_getTopicListText text] length] ? [_getTopicListText text]:nil;
    [YunBaService getTopicList:alias resultBlock:^(NSArray *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list (%@) of alias (%@) succeed", res, alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get topic list of alias %@", alias]];
}

- (IBAction)onTopicListGetFinshed:(id)sender {
    [self onTopicListGetButton:_getTopicListButton];
}

- (IBAction)onStateGetButton:(id)sender {
    [self hideAllKeyboard];
    
    NSString *alias = [[_getStateText text] length] ? [_getStateText text]:nil;
    [YunBaService getState:alias resultBlock:^(NSString *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state (%@) of alias (%@) succeed", res, alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get state of alias %@", alias]];
}

- (IBAction)onStateGetFinshed:(id)sender {
    [self onStateGetButton:_getStateButton];
}

- (IBAction)onAliasListGetButton:(id)sender {
    if (![[_getAliasListText text] length]) {
        [self alertWithContent:@"no topic set"];
        [_getAliasListText becomeFirstResponder];
    }
    [self hideAllKeyboard];
    
    NSString *topic = [_getAliasListText text];
    [YunBaService getAliasList:topic resultBlock:^(NSArray *resArray, size_t resCount, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list count %u :(%@) of topic (%@) succeed", (uint)resCount, resArray, topic]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list of topic (%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get alias list of topic %@", topic]];
}

- (IBAction)onAliasListGetFinshed:(id)sender {
    [self onAliasListGetButton:_getAliasListButton];
}

#pragma mark -- pub2 view
- (IBAction)onPub2Button:(id)sender {
    if (![[_pub2TopicText text] length]) {
        [self alertWithContent:@"no pub topic/alias set"];
        [_pub2TopicText becomeFirstResponder];
        return;
    }
    
    [self hideAllKeyboard];
    
    NSString *dest = [_pub2TopicText text];
    NSData *data = [[_pub2ContentText text] dataUsingEncoding:NSUTF8StringEncoding];
    YBPublish2Option *option = [[YBPublish2Option alloc] init];
    
    NSString *alert = [[_pub2AlertText text] length] ? [_pub2AlertText text] : nil;
    NSNumber *badge = [[_pub2BadgeText text] length] ? [NSNumber numberWithInt:[[_pub2BadgeText text] intValue]] : nil;
    NSString *sound = [_pub2SoundSegment selectedSegmentIndex] != 0 ? [_pub2SoundSegment titleForSegmentAtIndex:[_pub2SoundSegment selectedSegmentIndex]] : nil;
    NSDictionary *extra = [[_pub2Key1Text text] length] ? @{[_pub2Key1Text text] : [_pub2Value1Text text]} : nil;

    if (alert || badge || sound || extra) {
        YBApnOption *apnOption = [YBApnOption optionWithAlert:alert badge:badge sound:sound contentAvailable:nil extra:extra];
        [option setApnOption:apnOption];
    }
    
    if ([_pub2TypeSegment selectedSegmentIndex] == 0) {
        [YunBaService publish2:dest data:data option:option resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish2 data(%@) to topic(%@) succeed", [_pub2ContentText text], dest]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to topic(%@) failed: %@, recovery suggestion: %@", [_pub2ContentText text], dest, error,  [error localizedRecoverySuggestion]]];
            }
        }];
        
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ toTopic %@ with ApnOption(%@|%@|%@|%@)", [_pub2ContentText text], dest, alert, badge, sound, extra]];
    } else {
        [YunBaService publish2ToAlias:dest data:data option:option resultBlock:^(BOOL succ, NSError *error){
            if (succ) {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish2 data(%@) to alias(%@) succeed", [_pub2ContentText text], dest]];
            } else {
                [self addMsgToTextView:[NSString stringWithFormat:@"[result] publish data(%@) to alias(%@) failed: %@, recovery suggestion: %@", [_pub2ContentText text], dest, error,  [error localizedRecoverySuggestion]]];
            }
        }];
        
        [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] publish data %@ toAlias %@ with ApnOption(%@|%@|%@|%@)", [_pub2ContentText text], dest, alert, badge, sound, extra]];
    }
}

- (IBAction)onPub2TopicFinshed:(id)sender {
    [_pub2ContentText becomeFirstResponder];
}
- (IBAction)onPub2ContentFinshed:(id)sender {
    [_pub2AlertText becomeFirstResponder];
}
- (IBAction)onPub2AlertFinshed:(id)sender {
    [_pub2BadgeText becomeFirstResponder];
}
- (IBAction)onPub2BadgeFinshed:(id)sender {
    [_pub2Key1Text becomeFirstResponder];
}
- (IBAction)onPub2Key1Finshed:(id)sender {
    [_pub2Value1Text becomeFirstResponder];
}
- (IBAction)onPub2Value1Finshed:(id)sender {
    [self onPub2Button:_pub2Button];
}

#pragma mark -- v2 get topic list /get state /get alias list view
- (IBAction)onTopicListV2GetButton:(id)sender {
    [self hideAllKeyboard];
    
    NSString *alias = [[_getTopicListV2Text text] length] ? [_getTopicListV2Text text]:nil;
    [YunBaService getTopicListV2:alias resultBlock:^(NSDictionary *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list v2 (%@) of alias (%@) succeed", [res objectForKey:kYBGetTopicListTopicsKey], alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get topic list v2 of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get topic list v2 of alias %@", alias]];
}

- (IBAction)onTopicListV2GetFinshed:(id)sender {
    [self onTopicListV2GetButton:_getTopicListV2Button];
}

- (IBAction)onStateV2GetButton:(id)sender {
    [self hideAllKeyboard];
    
    NSString *alias = [[_getStateV2Text text] length] ? [_getStateV2Text text]:nil;
    [YunBaService getStateV2:alias resultBlock:^(NSDictionary *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state v2 (%@) of alias (%@) succeed", [res objectForKey:kYBGetStateStateKey], alias]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get state v2 of alias (%@) failed: %@, recovery suggestion: %@", alias, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get state v2 of alias %@", alias]];
}

- (IBAction)onStateV2GetFinshed:(id)sender {
    [self onStateV2GetButton:_getStateV2Button];
}

- (IBAction)onAliasListV2GetButton:(id)sender {
    if (![[_getAliasListV2Text text] length]) {
        [self alertWithContent:@"no topic set"];
        [_getAliasListV2Text becomeFirstResponder];
    }
    [self hideAllKeyboard];
    
    NSString *topic = [_getAliasListV2Text text];
    [YunBaService getAliasListV2:topic resultBlock:^(NSDictionary *res, NSError *error) {
        if (error.code == kYBErrorNoError) {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list v2 count %@ :(%@) of topic (%@) succeed", [res objectForKey:kYBGetAliasListOccupancyKey], [res objectForKey:kYBGetAliasListAliasKey], topic]];
        } else {
            [self addMsgToTextView:[NSString stringWithFormat:@"[result] get alias list v2 of topic (%@) failed: %@, recovery suggestion: %@", topic, error, [error localizedRecoverySuggestion]]];
        }
    }];
    [self addMsgToTextView:[NSString stringWithFormat:@"[Demo] get alias list v2 of topic %@", topic]];
}

- (IBAction)onAliasListV2GetFinshed:(id)sender {
    [self onAliasListV2GetButton:_getAliasListV2Button];
}
@end

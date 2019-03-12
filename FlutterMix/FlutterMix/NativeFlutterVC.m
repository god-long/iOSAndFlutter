//
//  NativeFlutterVC.m
//  FlutterMix
//
//  Created by 许龙 on 2019/3/11.
//  Copyright © 2019 qd. All rights reserved.
//

#import "NativeFlutterVC.h"
#import <Flutter/Flutter.h>
#import "NativeSecondVC.h"

@interface NativeFlutterVC ()

@property (nonatomic, strong) FlutterMethodChannel *pushChannel;

@end

@implementation NativeFlutterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    if (self.navigationController != nil) {
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.pushChannel) {
        return;
    }
    
    __weak typeof(self) ws = self;
    self.pushChannel = [FlutterMethodChannel methodChannelWithName:@"qd.flutter.io/qd_push_main" binaryMessenger:ws];
    [self.pushChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"%@", call.method);
        NSLog(@"%@", result);
        [ws handleFlutterMethod:call result:result];
    }];
}


- (void)handleFlutterMethod:(FlutterMethodCall *)call result:(FlutterResult )result {
    if ([call.method isEqualToString:@"pushNativePage"]) {
        NativeSecondVC *secondVC = [[NativeSecondVC alloc] init];
        [self.navigationController pushViewController:secondVC animated:YES];
    }
}


- (void)gotoBack {
    if (self.navigationController != nil) {
        [self.pushChannel invokeMethod:@"goback" arguments:@{@"number": @"1"} result:^(id  _Nullable result) {
            NSLog(@"%@", result);
            if ([result isEqualToString:@"gobackError"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

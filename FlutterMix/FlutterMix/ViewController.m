//
//  ViewController.m
//  FlutterMix
//
//  Created by 许龙 on 2019/3/6.
//  Copyright © 2019 qd. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "NativeSecondVC.h"
#import "NativeFlutterVC.h"

@interface ViewController ()

@property (nonatomic, strong) FlutterViewController *flutterPresentVC;

@property (nonatomic, strong) NativeFlutterVC *flutterPushVC;

@property (nonatomic, strong) FlutterMethodChannel *pushChannel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原生";


}

- (NSString *)getDeiveName {
    UIDevice *device = UIDevice.currentDevice;
    return device.name;
}

- (IBAction)presentFlutterPage:(UIButton *)sender {
//    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    self.flutterPresentVC = [[FlutterViewController alloc] init];
    [self.flutterPresentVC setInitialRoute:@"presentPage"];
    [self presentViewController:self.flutterPresentVC animated:false completion:nil];
    
    FlutterMethodChannel *presentChannel = [FlutterMethodChannel methodChannelWithName:@"qd.flutter.io/qd_present" binaryMessenger:self.flutterPresentVC];
    __weak typeof(self) weakSelf = self;
    __weak typeof(presentChannel) wsChannel = presentChannel;

    // 注册方法等待flutter页面调用
    [presentChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"%@", call.method);
        NSLog(@"%@", result);
        
        if ([call.method isEqualToString:@"getNativeResult"]) {
            NSString *name = [weakSelf getDeiveName];
            if (name == nil) {
                FlutterError *error = [FlutterError errorWithCode:@"UNAVAILABLE" message:@"Device info unavailable" details:nil];
                result(error);
            } else {
                result(name);
            }
            // 原生调用Flutter方法，带参数, 接收回传结果
            [wsChannel invokeMethod:@"flutterMedia" arguments:@{@"key1": @"value1"} result:^(id  _Nullable result) {
                NSLog(@"%@", result);
                [weakSelf showAlert:result];
            }];
        } else if ([call.method isEqualToString:@"dismiss"]) {
            [weakSelf.flutterPresentVC dismissViewControllerAnimated:YES completion:nil];
        } else if ([call.method isEqualToString:@"presentNativeSecondPage"]) {
            NativeSecondVC *secondVC = [[NativeSecondVC alloc] init];
            [self.flutterPresentVC presentViewController:secondVC animated:YES completion:nil];
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    }];
}

- (IBAction)pushFlutterPage:(UIButton *)sender {
//    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    self.flutterPushVC = [[NativeFlutterVC alloc] init];
    [self.flutterPushVC setInitialRoute:@"pushPage"];

    [self.navigationController pushViewController:self.flutterPushVC animated:true];
}


- (IBAction)clickPage3:(UIButton *)sender {
    NativeSecondVC *secondVC = [[NativeSecondVC alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}


- (void)showAlert:(NSString *)message {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Flutter返回" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alertVC addAction:defaultAction];
    [self.flutterPresentVC presentViewController:alertVC animated:YES completion:nil];
}


@end

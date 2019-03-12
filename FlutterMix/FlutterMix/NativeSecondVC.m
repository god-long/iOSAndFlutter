//
//  NativeSecondVC.m
//  FlutterMix
//
//  Created by 许龙 on 2019/3/6.
//  Copyright © 2019 qd. All rights reserved.
//

#import "NativeSecondVC.h"

@interface NativeSecondVC ()

@end

@implementation NativeSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickSecondNative:(UIButton *)sender {
    
}


- (IBAction)clickDismiss:(UIButton *)sender {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

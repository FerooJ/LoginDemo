//
//  LoginVC.m
//  LoginDemo
//
//  Created by JFQ on 2017/11/21.
//  Copyright © 2017年 Feroo. All rights reserved.
//

#import "LoginVC.h"
@import ReactiveObjC;

#define userName    @"user"
#define passWord    @"123456"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //合并信号 -- 如果用户名长度大于0，密码长度大于等于6，返回@(1), 否则返回@(0)
    RACSignal *combineSignal = [[RACSignal combineLatest:@[self.userNameTF.rac_textSignal, self.passWordTF.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] >= 6);
    }];
    
    //登陆按钮
    RAC(self.loginBtn, enabled) = [combineSignal map:^id _Nullable(NSNumber *value) {
        self.loginBtn.backgroundColor = [value boolValue] ? [UIColor redColor] : [UIColor groupTableViewBackgroundColor];
        return [value boolValue] ? @"YES" : @"NO";
    }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.userNameTF.text isEqualToString:userName] && [self.passWordTF.text isEqualToString:passWord]) {
            NSLog(@"登录成功");
        } else {
            NSLog(@"登录失败");
        }
    }];
    
    
//    //用户名
//    RACSignal *userNameSignal = [self.userNameTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return @(value.length >= 1);
//    }];
//
//    //密码
//    RACSignal *passWordSignal = [self.passWordTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return @(value.length >= 6);
//    }];
//
//    //登陆
//    //按钮的enabled -- 当用户名和密码都有效的时候，登陆按钮enabled为YES
//    RACSignal *combineSignal = [RACSignal combineLatest:@[userNameSignal, passWordSignal] reduce:^id(NSNumber *userNameValue, NSNumber *passWordValue){
//        return @([userNameValue boolValue] && [passWordValue boolValue]);
//    }];
//    RAC(self.loginBtn, backgroundColor) = [combineSignal map:^id _Nullable(NSNumber *value) {
//        return [value boolValue] ? [UIColor redColor] : [UIColor groupTableViewBackgroundColor];
//    }];
//    RAC(self.loginBtn, enabled) = [combineSignal map:^id _Nullable(NSNumber *value) {
//        return [value boolValue] ? @"YES" : @"NO";
//    }];
//
//    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        if ([self.userNameTF.text isEqualToString:userName] && [self.passWordTF.text isEqualToString:passWord]) {
//            NSLog(@"登陆成功了");
//        }
//    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

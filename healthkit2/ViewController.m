//
//  ViewController.m
//  healthkit2
//
//  Created by 张光鹏 on 16/3/25.
//  Copyright © 2016年 张光鹏. All rights reserved.
//

#import "ViewController.h"
#import "HealthKitMannager.h"

@interface ViewController ()<HealthKitDelegate>

@end

@implementation ViewController

- (void)receiveHealthKitHeight:(double)height{
    NSLog(@"receive height = %f",height);
}

- (void)receiveHealthKitWeight:(double)weight{
    NSLog(@"receive weight = %f",weight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [HealthKitMannager healthInstance].delegate = self;
    [[HealthKitMannager healthInstance] healthRequestSetting];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 100, 100);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
}

- (void)buttonAction{
    [[HealthKitMannager healthInstance] writeDistanceCycling:10000 duration:3600];
    
    [[HealthKitMannager healthInstance] readHealthkitHeight];
    
    [[HealthKitMannager healthInstance] readHealthkitWeight];
    
    NSLog(@"性别 = %@",[[HealthKitMannager healthInstance] readHealthkitSex]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

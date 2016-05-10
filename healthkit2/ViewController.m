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
    self.view.backgroundColor = [UIColor whiteColor];
    [HealthKitMannager healthInstance].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowAction) name:UIWindowDidResignKeyNotification object:nil];
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSLog(@"array = %@,count = %lu",windows,(unsigned long)windows.count);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 100, 100);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSLog(@"array = %@,count = %lu",windows,(unsigned long)windows.count);
}

- (void)windowAction{
    NSLog(@"winodw事件");
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSLog(@"array = %@,count = %lu",windows,(unsigned long)windows.count);
    UIWindow *currentWindow = windows[2];
    currentWindow.backgroundColor = [UIColor clearColor];
}

- (void)windowDealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[HealthKitMannager healthInstance] healthRequestSetting];
    
    
}

- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
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

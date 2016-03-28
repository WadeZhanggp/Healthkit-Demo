//
//  HealthKitMannager.h
//  healthkit-1
//
//  Created by 张光鹏 on 16/3/25.
//  Copyright © 2016年 张光鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HealthKitDelegate <NSObject>

- (void)receiveHealthKitHeight:(double)height;

- (void)receiveHealthKitWeight:(double)weight;

@end

@interface HealthKitMannager : NSObject

@property (nonatomic, strong) id<HealthKitDelegate>delegate;

+ (instancetype)healthInstance;

/*!
 判断设备是否支持健康应用
 */
- (BOOL)isHealthDataAvailable;

/*!
 healthkit请求授权设置
 */
- (void)healthRequestSetting;

/*!
 读取性别
 */
- (NSString *)readHealthkitSex;

/*!
 读取身高
 */
- (void)readHealthkitHeight;

/*!
 读取体重
 */
- (void)readHealthkitWeight;

/*!
 写入骑行数据
 */
- (void)writeDistanceCycling:(NSInteger)length duration:(NSInteger)time;


@end

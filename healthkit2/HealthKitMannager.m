//
//  HealthKitMannager.m
//  healthkit-1
//
//  Created by 张光鹏 on 16/3/25.
//  Copyright © 2016年 张光鹏. All rights reserved.
//

#import "HealthKitMannager.h"
#import <HealthKit/HealthKit.h>

@interface HealthKitMannager ()

@property (nonatomic, strong) HKHealthStore *healthStore;

@end

@implementation HealthKitMannager

+ (instancetype)healthInstance{
    
    static HealthKitMannager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HealthKitMannager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([HKHealthStore isHealthDataAvailable]) {
            self.healthStore = [[HKHealthStore alloc] init];
        }
    }
    return self;
}

- (BOOL)isHealthDataAvailable{
    
    return [HKHealthStore isHealthDataAvailable];
    
}

- (void)healthRequestSetting{
    
    //一组包含要共享的数据类型
    NSSet *shareObjectTypes = [NSSet setWithObjects:
                               //[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                               //[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                               nil];
    
    //一组包含要读取的数据类型
    NSSet *readObjectTypes  = [NSSet setWithObjects:
                               //[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                               //[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                               //[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                               nil];
    
    // Request access
    [self.healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                        readTypes:readObjectTypes
                                       completion:^(BOOL success, NSError *error) {
                                           
                                           if(success == YES)
                                           {
                                               NSLog(@">>>>>授权成功");
                                           }
                                           else
                                           {
                                               NSLog(@">>>>>授权失败");
                                               NSLog(@"error = %@",error);
                                               
                                           }
                                           
                                       }];

    
}

- (void)writeDistanceCycling:(NSInteger)length duration:(NSInteger)time{
    
    NSDate *startDate, *endDate;
    endDate = [NSDate dateWithTimeIntervalSinceNow:0];
    startDate = [NSDate dateWithTimeIntervalSinceNow:-time];
    NSLog(@"startdate = %@, endDate = %@",startDate,endDate);
    NSString *unitIdentifier = HKQuantityTypeIdentifierDistanceCycling;
    HKQuantityType *quantityTypeIdentifier = [HKObjectType quantityTypeForIdentifier:unitIdentifier];
    HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit unitFromLengthFormatterUnit:11] doubleValue:length];
    HKQuantitySample *temperatureSample2 = [HKQuantitySample quantitySampleWithType:quantityTypeIdentifier quantity:quantity startDate:startDate endDate:endDate metadata:nil];
    HKHealthStore *store = [[HKHealthStore alloc] init];
    [store saveObject:temperatureSample2 withCompletion:^(BOOL success, NSError *error) {
        if (success) {
            
            NSLog(@"保存成功");
            
        }else {
            
            NSLog(@"保存失败");
            
        }
    }];
    
}

- (NSString *)readHealthkitSex{
    
    NSError *error;
    HKBiologicalSexObject *bioSex = [_healthStore biologicalSexWithError:&error];
    NSString *sexString;
    switch ((int)bioSex.biologicalSex) {
        case HKBiologicalSexNotSet:
            sexString = @"NotSet";
            break;
            
        case HKBiologicalSexFemale:
            sexString = @"Female";
            break;
            
        case HKBiologicalSexMale:
            sexString = @"Male";
            break;
            
        case HKBiologicalSexOther:
            sexString = @"Other";
            break;
            
        default:
            break;
    }
    return sexString;
}

- (void)readHealthkitHeight{
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    NSDate *startDate, *endDate;
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if (!error && results) {
            HKQuantitySample *samples = [results lastObject];
            double heightMeter = [samples.quantity doubleValueForUnit:[HKUnit meterUnit]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(receiveHealthKitHeight:)]) {
                [self.delegate receiveHealthKitHeight:heightMeter];
            }
        }
        
    }];
    
    [_healthStore executeQuery:sampleQuery];
    
}

- (void)readHealthkitWeight{
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSDate *startDate, *endDate;
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if (!error && results) {
            
            HKQuantitySample *samples = [results lastObject];
            double weightg = [samples.quantity doubleValueForUnit:[HKUnit gramUnit]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(receiveHealthKitWeight:)]) {
                [self.delegate receiveHealthKitWeight:weightg];
            }
        }
        
    }];
    
    [_healthStore executeQuery:sampleQuery];
    
}

@end

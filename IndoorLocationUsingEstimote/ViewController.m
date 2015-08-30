//
//  ViewController.m
//  IndoorLocationUsingEstimote
//
//  Created by zhaoguoqi on 15/8/30.
//  Copyright (c) 2015年 zhaoguoqi. All rights reserved.
//

#import "ViewController.h"
#import "ESTIndoorLocationManager.h"
#import "ESTIndoorLocationView.h"
#import "ESTPositionView.h"
#import "ESTLocationBuilder.h"


@interface ViewController ()<ESTIndoorLocationManagerDelegate>

@property(nonatomic, strong)ESTIndoorLocationManager *locationManager;
@property(nonatomic, strong)ESTLocation *location;
@property(nonatomic, strong)ESTPositionView *positionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"location" ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    self.location = [ESTLocationBuilder parseFromJSON:content];

    self.locationManager = [[ESTIndoorLocationManager alloc]init];
    self.locationManager.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didFailToUpdatePositionWithError:(NSError *)error{
    NSLog(@"failed to update position: %@", error);
}

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didUpdatePosition:(ESTOrientedPoint *)position withAccuracy:(ESTPositionAccuracy)positionAccuracy inLocation:(ESTLocation *)location{
    NSString *accuracy;
    switch (positionAccuracy) {
        case ESTPositionAccuracyVeryHigh:
            accuracy = @"+/- 1.00m";
            break;
        case ESTPositionAccuracyHigh:
            accuracy = @"+/- 1.62m";
            break;
        case ESTPositionAccuracyMedium:
            accuracy = @"+/- 2.62m";
            break;
        case ESTPositionAccuracyLow:
            accuracy = @"+/- 4.24m";
            break;
        case ESTPositionAccuracyVeryLow:
            accuracy = @"+/- ? : -(";
            break;
    }
    NSLog(@"x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",position.x, position.y, position.orientation, accuracy);
}

@end

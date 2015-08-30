//
//  GZIndoorLocationViewController.m
//  IndoorLocationUsingEstimote
//
//  Created by zhaoguoqi on 15/8/30.
//  Copyright (c) 2015年 zhaoguoqi. All rights reserved.
//

#import "GZIndoorLocationViewController.h"
#import "ESTLocationBuilder.h"
#import "ESTIndoorLocationView.h"
#import "ESTPositionView.h"
#import "ESTIndoorLocationManager.h"

@interface GZIndoorLocationViewController ()<ESTIndoorLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet ESTIndoorLocationView *indoorLocaitonView;
@property (nonatomic, strong)ESTLocation *location;
@property (nonatomic, strong)ESTIndoorLocationManager *locationManager;
@property (nonatomic, strong)ESTPositionView *positionView;

@end

@implementation GZIndoorLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[ESTIndoorLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"location" ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.location = [ESTLocationBuilder parseFromJSON:content];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.indoorLocaitonView.backgroundColor = [UIColor clearColor];
    self.indoorLocaitonView.showTrace = YES;
    self.indoorLocaitonView.rotateOnPositionUpdate = NO;
    self.indoorLocaitonView.showWallLengthLabels = YES;
    
    self.indoorLocaitonView.locationBorderColor = [UIColor blackColor];
    self.indoorLocaitonView.locationBorderThickness = 4;
    self.indoorLocaitonView.doorColor = [UIColor brownColor];
    self.indoorLocaitonView.doorThickness = 6;
    self.indoorLocaitonView.traceColor = [UIColor blueColor];
    self.indoorLocaitonView.traceThickness = 2;
    self.indoorLocaitonView.wallLengthLabelsColor = [UIColor blackColor];
    
    [self.indoorLocaitonView drawLocation:self.location];
    
    self.positionView = [[ESTPositionView alloc]initWithImage:[UIImage imageNamed:@"navigation_guy"] location:self.location forViewWithBounds:self.indoorLocaitonView.bounds];
    self.positionView.hidden = YES;
    self.indoorLocaitonView.positionView = self.positionView;
    
    [self.locationManager startIndoorLocation:self.location];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopIndoorLocation];
    [super viewWillDisappear:animated];
}

#pragma mark - ESTIndoorLocationManager delegate 
- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didUpdatePosition:(ESTOrientedPoint *)position withAccuracy:(ESTPositionAccuracy)positionAccuracy inLocation:(ESTLocation *)location{
    self.positionView.hidden = NO;
    [self.positionView updateAccuracy:positionAccuracy];
    [self.indoorLocaitonView updatePosition:position];
}

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didFailToUpdatePositionWithError:(NSError *)error{
    self.positionView.hidden = YES;
    NSLog(@"%@", error);
}

@end

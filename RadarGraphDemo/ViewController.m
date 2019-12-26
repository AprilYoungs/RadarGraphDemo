//
//  ViewController.m
//  RadarGraphDemo
//
//  Created by April Young on 2019/12/24.
//  Copyright © 2019 April Young. All rights reserved.
//

#import "ViewController.h"
#import "RadarGraphView.h"

@interface ViewController ()
@property(nonatomic, strong) RadarGraphView *radar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RadarGraphView *radar = [[RadarGraphView alloc] init];
    radar.backgroundColor = [UIColor whiteColor];
    radar.frame = CGRectInset(self.view.bounds, 0, 50);
    
    radar.backgroundColor = [UIColor systemTealColor];
    [self.view addSubview:radar];
    
    self.radar = radar;
}

- (void)viewDidLayoutSubviews
{
     self.radar.frame = CGRectInset(self.view.bounds, 0, 50);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.radar.values = @[@40, @50, @60, @70, @80];
}


@end
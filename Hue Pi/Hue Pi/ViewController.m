//
//  ViewController.m
//  Hue Pi
//
//  Created by Ethan Lowman on 12/21/14.
//  Copyright (c) 2014 Ethan Lowman. All rights reserved.
//

#import "ViewController.h"
#import <NKOColorPickerView.h>
#import <AFNetworking.h>

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (strong, nonatomic) IBOutlet NKOColorPickerView *colorPickerView;
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak ViewController *weakSelf = self;
    
    [self.colorPickerView setDidChangeColorBlock:^(UIColor *color){
        [weakSelf updateStatus];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)brightnessSliderChanged:(id)sender {
    [self updateStatus];
}

- (void)updateStatus {
    NSString *onOff = self.statusSwitch.isOn ? @"on" : @"off";
    
    CGFloat rFloat, gFloat,bFloat,aFloat;
    [self.colorPickerView.color getRed:&rFloat green:&gFloat blue: &bFloat alpha: &aFloat];
    int r, g, b, a;
    r = (int)(255.0 * rFloat);
    g = (int)(255.0 * gFloat);
    b = (int)(255.0 * bFloat);
    a = (int)self.brightnessSlider.value;
    
    NSString *color = [NSString stringWithFormat:@"%02x%02x%02x%02x", r, g, b, a];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"status": onOff, @"color": color};
    [manager POST:@"http://raspberrypi.home:5555/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end

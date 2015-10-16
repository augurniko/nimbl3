//
//  takeTheSurveyViewController.m
//  Nimbl3
//
//  Created by NICOLAS DEMOGUE on 15/10/2015.
//  Copyright © 2015 NICOLAS DEMOGUE. All rights reserved.
//

#import "takeTheSurveyViewController.h"

@interface takeTheSurveyViewController ()

@end

@implementation takeTheSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

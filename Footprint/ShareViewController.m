//
//  ShareViewController.m
//  Footprint
//
//  Created by Saeko Fuse on 2015/03/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui.jpg"]];
    UIImage *backgroundImage = [UIImage imageNamed:@"sky_BG4_usui.jpg"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapBackTL:(id)sender {
}
- (IBAction)tapShare:(id)sender {
}
@end

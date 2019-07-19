//
//  ViewController.m
//
//  ceshi
//
//  Created by mm on 2019/7/17.
//
//  Copyright © 2019 mm. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "YellowPeople.h"

#import "AnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag == 10) {
        //加载View的小动画
        YellowPeople *yellow = [[YellowPeople alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        yellow.transform = CGAffineTransformMakeTranslation(0.01, self.view.frame.size.height);
        
        yellow.alpha = 0.2;
        
        [UIView animateWithDuration:0.8 animations:^{
            yellow.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
            yellow.alpha = 1;
        }];
        
        [self.view addSubview:yellow];
    }else{
        //加载View的小动画
        AnimationView *animation = [[AnimationView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        animation.transform = CGAffineTransformMakeTranslation(0.01, self.view.frame.size.height);
        
        animation.alpha = 0.2;
        
        [UIView animateWithDuration:0.8 animations:^{
            animation.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
            animation.alpha = 1;
        }];
        
        [self.view addSubview:animation];
    }
}


@end

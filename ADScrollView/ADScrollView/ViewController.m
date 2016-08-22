//
//  ViewController.m
//  ADScrollView
//
//  Created by User01 on 16/8/22.
//  Copyright © 2016年 Spring. All rights reserved.
//

#import "ViewController.h"
#import "SADScrollView.h"
@interface ViewController ()<SADScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //图片数组
    NSArray * array = @[@"scrollimage",@"scrollimage",@"scrollimage",@"scrollimage"];
    SADScrollView * sadview = [[SADScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)  WithAdArray:array CardViewSize:CGSizeZero WithRepete:YES];
    [sadview setDelegate:self];
    [sadview setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:sadview];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)adEventClickIndex:(NSUInteger)index{
    NSLog(@"%ld",index);
    switch (index) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

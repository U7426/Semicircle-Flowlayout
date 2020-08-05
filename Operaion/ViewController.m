//
//  ViewController.m
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/15.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import "ViewController.h"
#import "OperationView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    OperationView *operationView = [[OperationView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:operationView];
}


@end

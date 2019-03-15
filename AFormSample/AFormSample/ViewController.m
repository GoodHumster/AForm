//
//  ViewController.m
//  AFormSample
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "ViewController.h"

#import <AForm/AFormView.h>

#import "AFormExample.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet AFormView *formView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFormExample *formEx = [AFormExample new];
    [self.formView presentForm:formEx animatable:NO];
    
    // Do any additional setup after loading the view, typically from a nib.
}


@end

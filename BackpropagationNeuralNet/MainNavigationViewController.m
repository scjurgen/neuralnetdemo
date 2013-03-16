//
//  MainNavigationViewController.m
//  tunedin.demo
//
//  Created by Jürgen Schwieteringon 3/3/13.
//  Copyright (c) 2013 Jürgen Schwietering. All rights reserved.
//

#import "MainNavigationViewController.h"

@interface MainNavigationViewController ()

@end

@implementation MainNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBar.tintColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

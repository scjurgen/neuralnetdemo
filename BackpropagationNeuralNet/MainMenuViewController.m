//
//  MainMenuViewController.m
//  tunedin.demo
//
//  Created by Jürgen Schwieteringon 3/2/13.
//  Copyright (c) 2013 Jürgen Schwietering. All rights reserved.
//

#import "MainMenuViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "MainMenuCustomCell.h"


typedef enum
{
    MI1IN1OUT=0,
    MI1IN2OUT=1,
    MI2IN1OUT=2,
    MI2IN2OUT=3,
} eMenuItemsOrder;


@interface MainMenuViewController ()
{
    CGFloat cellHeight; // if we add editing somehow
    
    NSArray * menuKeys;
    NSArray * menuIcons;
}

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    menuKeys=@[@"1 in 1 out", @"1 in 2 out", @"2 in 1 out"];
    menuIcons=@[@"1in1out",@"1in2out",@"2in1out"];
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"NN",@"NN item");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"menu",@"menu") style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    MainMenuCustomCell *cell= [[[NSBundle mainBundle] loadNibNamed:@"MainMenuCustomCell" owner:nil options:nil] lastObject];
    cellHeight=cell.bounds.size.height;
}

- (void)viewWillAppear:(BOOL)animated
{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"menu",@"menu") style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuKeys count];
}

- (MainMenuCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainMenuCustomCell";
    
    MainMenuCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MainMenuCustomCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.menuNameLabel.text=NSLocalizedString(menuKeys[indexPath.row],nil);
    cell.menuIconImage.image=[UIImage imageNamed:menuIcons[indexPath.row]];
    switch(indexPath.row)
    {
        case MI1IN1OUT:
        case MI2IN1OUT:
        case MI1IN2OUT:
        case MI2IN2OUT:
            cell.moreInfoLabel.text=nil;
            break;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        self.viewDeckController.centerController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] controllerForIndex:indexPath.row];
    }];
    
}

@end

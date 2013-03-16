//
//  MainMenuCustomCell.h
//  tunedin.demo
//
//  Created by Jürgen Schwieteringon 3/3/13.
//  Copyright (c) 2013 Jürgen Schwietering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *menuIconImage;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoLabel;

@end

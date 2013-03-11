//
//  StatsViewController.h
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"

@interface StatsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property (strong, nonatomic) IBOutlet UILabel *quizzesTakenLabel;
@property (strong, nonatomic) IBOutlet BButton *resetStatsButton;

- (IBAction)resetStats:(id)sender;

@end

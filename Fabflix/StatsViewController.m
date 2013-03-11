//
//  StatsViewController.m
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

- (void)reloadStats;

@end

@implementation StatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Stats" image:[UIImage imageNamed:@"stats.png"] tag:1];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTitle.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.resetStatsButton.color = [UIColor colorWithRed:.85 green:.22 blue:.22 alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self reloadStats];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadStats {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Show number of quizzes taken
    NSInteger quizzesTaken = [prefs integerForKey:@"quizzesTaken"];
    self.quizzesTakenLabel.text = [NSString stringWithFormat:@"Quizzes Taken: %d", quizzesTaken];
}

- (IBAction)resetStats:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setInteger:0 forKey:@"quizzesTaken"];
    [self reloadStats];
}

@end

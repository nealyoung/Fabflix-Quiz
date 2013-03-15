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
- (void)reset;

@end

@implementation StatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
    
    [self reloadStats];
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

// Reload the statistics displayed to the user
- (void)reloadStats {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Show number of quizzes taken
    NSInteger quizzesTaken = [prefs integerForKey:@"quizzesTaken"];
    self.quizzesTakenLabel.text = [NSString stringWithFormat:@"Quizzes Taken: %d", quizzesTaken];
    
    // Show time spent
    double totalTime = [prefs floatForKey:@"totalTime"];
    self.timeSpentLabel.text = [NSString stringWithFormat:@"Time Spent: %.1f seconds", totalTime];
    
    // Show average time per question
    NSInteger totalAnswers = [prefs integerForKey:@"totalAnswers"];
    
    if (totalAnswers != 0) {
        self.timePerQuestionLabel.text = [NSString stringWithFormat:@"Time per Question: %.1f seconds", (totalTime / totalAnswers)];
    } else {
        self.timePerQuestionLabel.text = [NSString stringWithFormat:@"Time per Question: 0.0 seconds"];
    }
    
    // Show total number of answers
    self.answersLabel.text = [NSString stringWithFormat:@"Answers: %d", totalAnswers];
    
    // Show number of correct answers
    NSInteger correctAnswers = [prefs integerForKey:@"correctAnswers"];
    self.correctAnswersLabel.text = [NSString stringWithFormat:@"Correct Answers: %d", correctAnswers];
    
    // Show number of incorrect answers
    NSInteger incorrectAnswers = [prefs integerForKey:@"incorrectAnswers"];
    self.incorrectAnswersLabel.text = [NSString stringWithFormat:@"Incorrect Answers: %d", incorrectAnswers];
}

// Reset button pressed
- (IBAction)resetStats:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                    message:@"Are you sure you want to reset your statistics?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Reset", nil];
    
    [alert show];
}

// Reset all statistics
- (void)reset {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"quizzesTaken"];
    [prefs removeObjectForKey:@"totalTime"];
    [prefs removeObjectForKey:@"totalAnswers"];
    [prefs removeObjectForKey:@"correctAnswers"];
    [prefs removeObjectForKey:@"incorrectAnswers"];
    
    [self reloadStats];
}

#pragma mark - UIAlertViewDelegate

// Reset stats confirmation alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self reset];
    }
}

@end

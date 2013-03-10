//
//  QuizViewController.m
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "StartQuizViewController.h"

@interface StartQuizViewController ()

@end

@implementation StartQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Quiz" image:[UIImage imageNamed:@"quiz.png"] tag:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startQuiz:(id)sender {
    QuizViewController *quizView = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:quizView];
    
    [self presentViewController:navigationController animated:YES completion:nil];    
}

@end

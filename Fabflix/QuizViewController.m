//
//  QuizViewController.m
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController () {
    NSTimer *timer;
    Quiz *quiz;
    double time;
}

@end

@implementation QuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewController)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.title = @"Movie Quiz";
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(updateTimer:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(updateTimer:)];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 invocation:invocation repeats:YES];
    quiz = [[Quiz alloc] init];
    time = 0.0;
    
    self.questionLabel.text = quiz.getQuestion;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewController {
    [timer invalidate];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTimer:(NSTimer *)fire {
    time += 0.01;
    self.timerLabel.text = [NSString stringWithFormat:@"%.2f", time];
    
    if (time >= 300.0) {
        [timer invalidate];
    }
}

- (IBAction)selectAnswer:(id)sender {
    NSInteger answer = [sender tag];
    if ([quiz submitAnswer:answer]) {
        self.answerLabel.text = @"Correct!";
    } else {
        self.answerLabel.text = @"Incorrect";
    }
}

@end

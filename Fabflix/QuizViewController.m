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

- (void)loadNextQuestion;

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
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.title = @"Movie Quiz";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quiznavbar.png"]];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(updateTimer:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(updateTimer:)];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 invocation:invocation repeats:YES];
    quiz = [[Quiz alloc] init];
    time = 0.0;
    
    [self loadNextQuestion];
    self.questionLabel.text = quiz.getQuestion;
    self.answerLabel.text = @"";
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
    self.timerLabel.text = [NSString stringWithFormat:@"%d:%.2d", (int)time / 60, (int)time % 60];
    
    if (time >= 6.0) {
        [timer invalidate];
        NSString *quizTitle = @"Quiz Finished!";
        NSString *quizMessage = [NSString stringWithFormat:@"You got %d out of %d questions correct", quiz.numCorrect, quiz.numQuestions];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:quizTitle message:quizMessage delegate:nil cancelButtonTitle:@"Neat!" otherButtonTitles:nil];
        [message show];
        
        [self dismissViewController];
    }
}

- (void)loadNextQuestion {
    [quiz nextQuestion];
    
    self.questionLabel.text = [quiz getQuestion];
    
    NSArray *answers = [quiz getAnswers];

    [self.answer0 setTitle:answers[0] forState:UIControlStateNormal];
    [self.answer1 setTitle:answers[1] forState:UIControlStateNormal];
    [self.answer2 setTitle:answers[2] forState:UIControlStateNormal];
    [self.answer3 setTitle:answers[3] forState:UIControlStateNormal];
}

- (IBAction)selectAnswer:(id)sender {
    NSInteger answer = [sender tag];
    
    if ([quiz submitAnswer:answer]) {
        self.answerLabel.textColor = [UIColor colorWithRed:0.1 green:0.65 blue:0.05 alpha:1.0];
        self.answerLabel.text = @"Correct!";
    } else {
        self.answerLabel.textColor = [UIColor redColor];
        NSString *correctAnswer = [[quiz getAnswers] objectAtIndex:[quiz getAnswerIndex]];
        self.answerLabel.text = [NSString stringWithFormat:@"Incorrect, Correct Answer: %@", correctAnswer];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", quiz.numCorrect];
    
    [self loadNextQuestion];
}

@end

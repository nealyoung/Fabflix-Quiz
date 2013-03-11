//
//  QuizViewController.h
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"
#import "BButton.h"

@interface QuizViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet BButton *answer0;
@property (strong, nonatomic) IBOutlet BButton *answer1;
@property (strong, nonatomic) IBOutlet BButton *answer2;
@property (strong, nonatomic) IBOutlet BButton *answer3;

- (IBAction)selectAnswer:(id)sender;

@end

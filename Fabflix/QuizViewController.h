//
//  QuizViewController.h
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"

@interface QuizViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;

- (IBAction)selectAnswer:(id)sender;

@end

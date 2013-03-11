//
//  StartQuizViewController.h
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizViewController.h"
#import "BButton.h"

@interface StartQuizViewController : UIViewController

@property (strong, nonatomic) IBOutlet BButton *startQuizButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;

- (IBAction)startQuiz:(id)sender;

@end

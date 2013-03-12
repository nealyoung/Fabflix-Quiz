//
//  QuestionGenerator.h
//  Fabflix
//
//  Created by Nealon Young on 3/11/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizQuestion.h"

#define QUIZ_QUESTION_DIRECTOR 0
#define QUIZ_QUESTION_YEAR 1

@interface QuestionGenerator : NSObject

- (QuizQuestion *)newQuestion;

@end

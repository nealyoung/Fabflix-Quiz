//
//  QuestionGenerator.h
//  Fabflix
//
//  Created by Nealon Young on 3/11/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizQuestion.h"
#import "sqlite3.h"

typedef enum {
    QuizQuestionTypeDirector = 0,
    QuizQuestionTypeYear,
    QuizQuestionTypeStarInMovie
} QuizQuestionType;

typedef struct {
    NSInteger id;
    char *title;
} Movie;

@interface QuestionGenerator : NSObject

- (QuizQuestion *)newQuestion;

@end

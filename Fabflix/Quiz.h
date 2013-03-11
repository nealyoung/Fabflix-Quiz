//
//  Quiz.h
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizQuestion.h"

@interface Quiz : NSObject

@property (nonatomic) NSInteger numQuestions;
@property (nonatomic) NSInteger numCorrect;

- (NSString *)getQuestion;
- (NSArray *)getAnswers;
- (NSInteger)getAnswerIndex;
- (BOOL)submitAnswer:(NSInteger)answerIndex;
- (void)nextQuestion;
- (void)finish;

@end

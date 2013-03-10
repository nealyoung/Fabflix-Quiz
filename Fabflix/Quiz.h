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

@property (readonly, nonatomic) NSInteger numQuestions;
@property (readonly, nonatomic) NSInteger numCorrect;

- (NSString*)getQuestion;
- (BOOL)submitAnswer:(NSInteger)answerIndex;

@end

//
//  Quiz.m
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "Quiz.h"

@interface Quiz () {
    QuizQuestion *currentQuestion;
}

- (void)nextQuestion;

@end

@implementation Quiz

- (id)init {
    self = [super init];
    
    if (self) {
        // Generate the first question in the quiz
        [self nextQuestion];
    }
    
    return self;
}

- (NSString*)getQuestion {
    return currentQuestion.question;
}

- (BOOL)submitAnswer:(NSInteger)answerIndex {
    // Check if the submitted answer is correct
    BOOL correctAnswer = (answerIndex == currentQuestion.answerIndex);

    // Generate the next question
    [self nextQuestion];
    
    if (correctAnswer) {
        // Increment number of correct questions
        _numCorrect++;
        return true;
    } else {
        return false;
    }
}

- (void)nextQuestion {
    // Do database stuffs here
    // Generate questions
    
    currentQuestion = [[QuizQuestion alloc] initWithQuestion:@"Sup" answers:[NSArray arrayWithObjects:@"420", @"NTMA", @"LGM", @"JOOS", nil] answerIndex:0];
    
    // Increment total number of questions
    _numQuestions++;
}

@end

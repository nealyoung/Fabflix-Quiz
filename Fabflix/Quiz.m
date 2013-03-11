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

- (NSString *)getQuestion {
    return currentQuestion.question;
}

- (NSArray *)getAnswers {
    return currentQuestion.answers;
}

- (NSInteger)getAnswerIndex {
    return currentQuestion.answerIndex;
}

- (BOOL)submitAnswer:(NSInteger)answerIndex {
    // Check if the submitted answer is correct
    BOOL correctAnswer = (answerIndex == currentQuestion.answerIndex);

    // Generate the next question
    [self nextQuestion];
    
    // Increment total number of questions
    self.numQuestions++;
    
    if (correctAnswer) {
        // Increment number of correct questions
        self.numCorrect++;
        return true;
    } else {
        return false;
    }
}

- (void)nextQuestion {
    // Do database stuffs here
    // Generate questions
    currentQuestion = [[QuizQuestion alloc] initWithQuestion:@"In what year was 'Titanic' released?" answers:[NSArray arrayWithObjects:@"1995", @"2002", @"1998", @"2006", nil] answerIndex:2];
}

@end

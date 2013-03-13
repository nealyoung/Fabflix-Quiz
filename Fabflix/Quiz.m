//
//  Quiz.m
//  Fabflix
//
//  Created by Nealon Young on 3/8/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "Quiz.h"

@interface Quiz () {
    QuestionGenerator *questionGenerator;
    QuizQuestion *currentQuestion;
    double lastQuestionAnsweredTime;
}

@end

@implementation Quiz

- (id)init {
    self = [super init];
        
    if (self) {
        // Generate the first question in the quiz
        questionGenerator = [[QuestionGenerator alloc] init];
        //currentQuestion = [questionGenerator newQuestion];
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

- (BOOL)submitAnswer:(NSInteger)answerIndex time:(double)time {
    // Check if the submitted answer is correct
    BOOL correctAnswer = (answerIndex == currentQuestion.answerIndex);
    
    // Increment total number of questions
    self.numQuestions++;
    
    lastQuestionAnsweredTime = time;

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
    
    NSLog(@"NextQuestion Called");
    currentQuestion = [questionGenerator newQuestion];
}

// Save statistics from the quiz, should be called after quiz is finshed
- (void)finish {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Update number of quizzes taken
    NSInteger quizzesTaken = [prefs integerForKey:@"quizzesTaken"];
    quizzesTaken++;
    
    [prefs setInteger:quizzesTaken forKey:@"quizzesTaken"];
    
    // Update total time spent
    double totalTime = [prefs integerForKey:@"totalTime"];
    totalTime += lastQuestionAnsweredTime;
    
    [prefs setFloat:totalTime forKey:@"totalTime"];
    
    // Update total number of answers
    NSInteger totalAnswers = [prefs integerForKey:@"totalAnswers"];
    totalAnswers += self.numQuestions;
    
    [prefs setInteger:totalAnswers forKey:@"totalAnswers"];
    
    // Update number of correct answers
    NSInteger correctAnswers = [prefs integerForKey:@"correctAnswers"];
    correctAnswers += self.numCorrect;
    
    [prefs setInteger:correctAnswers forKey:@"correctAnswers"];
    
    // Update number of incorrect answers
    NSInteger incorrectAnswers = [prefs integerForKey:@"incorrectAnswers"];
    incorrectAnswers += (self.numQuestions - self.numCorrect);
    
    [prefs setInteger:incorrectAnswers forKey:@"incorrectAnswers"];
}

@end

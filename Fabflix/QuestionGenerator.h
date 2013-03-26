//
//  QuestionGenerator.h
//  Fabflix
//
//  Created by Nealon Young on 3/13/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "QuizItem.h"
#import "QuizQuestion.h"

@interface QuestionGenerator : NSObject

- (QuizQuestion *)newQuestion;
- (QuizQuestion *)getQuestionTypeDirector;
- (QuizQuestion *)getQuestionTypeYear;
- (QuizQuestion *)getQuestionTypeStarInMovie;
- (QuizQuestion *)getQuestionTypeStarNotInMovie;
- (QuizQuestion *)getQuestionTypeStarsAppearTogether;
- (QuizQuestion *)getQuestionTypeDirectorForStar;
- (QuizQuestion *)getQuestionTypeNotDirectorForStar;
- (QuizQuestion *)getQuestionTypeStarAppearBothMovies;
- (QuizQuestion *)getQuestionTypeStarNotAppearWithStar;
- (QuizQuestion *)getQuestionTypeDirectorForStarInYear;
- (QuizQuestion *)generateQuestion:(NSString *)question withCorrectAnswer:(NSString *)correct incorrectAnswers:(NSMutableArray *)incorrect;
- (QuizItem *)randomMovie;
- (QuizItem *)randomMovieWithMinimumStars:(NSInteger)stars;

@end

//
//  QuestionGenerator.m
//  Fabflix
//
//  Created by Nealon Young on 3/11/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "QuestionGenerator.h"

@interface QuestionGenerator () {
    sqlite3 *database;
}

- (Movie)randomMovie;

@end

@implementation QuestionGenerator

- (id)init {
    self = [super init];
    
    if (self) {
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"fabflix" ofType:@"sqlite3"];
        
        if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
            NSLog(@"Error opening SQLite database");
        }
    }
    
    return self;
}

- (QuizQuestion *)newQuestion {
    sqlite3_stmt *statement;
    QuizQuestionType questionType = arc4random() % 2;
    
    // TODO
    // correct answers can be repeated
    // consolidate code
    
    if (questionType == QuizQuestionTypeDirector) {
        NSString *query = @"SELECT * FROM movies ORDER BY RANDOM() LIMIT 4;";
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *titleChars = (char *)sqlite3_column_text(statement, 1);
                NSString *title = [NSString stringWithUTF8String:titleChars];

                char *directorChars = (char *)sqlite3_column_text(statement, 3);                
                NSString *answer = [NSString stringWithUTF8String:directorChars];
                
                NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < 3; i++) {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        char *optionChars = (char *)sqlite3_column_text(statement, 3);
                        NSString *option = [NSString stringWithUTF8String:optionChars];
                        
                        [answerOptions addObject:option];
                    } else {
                        // If there are not enough movies in the database
                        [answerOptions addObject:@"ERROR"];
                    }
                }
                
                // Insert the correct answer at a random index
                NSString *question = [NSString stringWithFormat:@"Who directed '%@'?", title];
                
                int answerIndex = arc4random() % 4;
                [answerOptions insertObject:answer atIndex:answerIndex];
                
                QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question
                                                                            answers:answerOptions
                                                                        answerIndex:answerIndex];
                
                sqlite3_finalize(statement);

                return quizQuestion;
            }
        }
    } else if (questionType == QuizQuestionTypeYear) {
        NSString *query = @"SELECT * FROM movies ORDER BY RANDOM() LIMIT 4;";
                
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                // Get the title of the first movie
                char *titleChars = (char *)sqlite3_column_text(statement, 1);
                NSString *title = [NSString stringWithUTF8String:titleChars];
                 
                // Get the year from the first movie
                char *answerChars = (char *)sqlite3_column_text(statement, 2);
                NSString *answer = [NSString stringWithUTF8String:answerChars];
                
                NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < 3; i++) {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        char *optionChars = (char *)sqlite3_column_text(statement, 2);
                        NSString *option = [NSString stringWithUTF8String:optionChars];
                        
                        [answerOptions addObject:option];
                    } else {
                        // If there are not enough movies in the database
                        [answerOptions addObject:@"ERROR"];
                    }
                }
                
                // Insert the correct answer at a random index
                NSString *question = [NSString stringWithFormat:@"When was '%@' released?", title];
                
                int answerIndex = arc4random() % 4;
                [answerOptions insertObject:answer atIndex:answerIndex];
                
                QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question
                                                                            answers:answerOptions
                                                                        answerIndex:answerIndex];
                
                sqlite3_finalize(statement);
                
                return quizQuestion;
            }
        } 
    } else if (questionType == QuizQuestionTypeStarInMovie) {
        Movie movie = [self randomMovie];
        NSString *query = [NSString stringWithFormat:@"SELECT stars.first_name, stars.last_name FROM stars, stars_in_movies WHERE stars_in_movies.movie_id=%d AND stars_in_movies.star_id=stars.id ORDER BY RANDOM();", movie.id];
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                // Get the title of the first movie
                //char *titleChars = (char *)sqlite3_column_text(statement, 1);
                //NSString *title = [NSString stringWithUTF8String:titleChars];
                
                // Get the year from the first movie
                char *answerChars = (char *)sqlite3_column_text(statement, 2);
                NSString *answer = [NSString stringWithUTF8String:answerChars];
                
                NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < 3; i++) {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        char *optionChars = (char *)sqlite3_column_text(statement, 2);
                        NSString *option = [NSString stringWithUTF8String:optionChars];
                        
                        [answerOptions addObject:option];
                    } else {
                        // If there are not enough movies in the database
                        [answerOptions addObject:@"ERROR"];
                    }
                }
                
                // Insert the correct answer at a random index
                NSString *question = [NSString stringWithFormat:@"Which star was in '%s'?", movie.title];
                
                int answerIndex = arc4random() % 4;
                [answerOptions insertObject:answer atIndex:answerIndex];
                
                QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question
                                                                            answers:answerOptions
                                                                        answerIndex:answerIndex];
                
                sqlite3_finalize(statement);
                return quizQuestion;
            }
        }
    }
    
    return nil;
}

- (Movie)randomMovie {
    sqlite3_stmt *statement;
    NSString *query = @"SELECT id, title FROM movies ORDER BY RANDOM();";
    
    Movie movie;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            // Get the id and title of the first movie
            movie.id = sqlite3_column_int(statement, 0);
            movie.title = (char *)sqlite3_column_text(statement, 1);
        }
    }
    
    sqlite3_finalize(statement);
    return movie;
}

- (void)dealloc {
    sqlite3_close(database);
}

@end

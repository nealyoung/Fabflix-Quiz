//
//  QuestionGenerator.m
//  Fabflix
//
//  Created by Nealon Young on 3/11/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "QuestionGenerator.h"
#import "sqlite3.h"

@interface QuestionGenerator () {
    sqlite3 *database;
}

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
    
    int questionType = arc4random() % 2;
    
    if (questionType == QUIZ_QUESTION_DIRECTOR) {
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
    } else if (questionType == QUIZ_QUESTION_YEAR) {
        NSString *query = @"SELECT * FROM movies ORDER BY RANDOM() LIMIT 4;";
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
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
    }
    
    return nil;
}

- (void)dealloc {
    sqlite3_close(database);
}

@end

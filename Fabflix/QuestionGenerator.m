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
    
    int r = arc4random() % 1;
    
    if (r == 0) {
        NSString *query = @"SELECT * FROM movies ORDER BY RANDOM() LIMIT 4;";
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *titleChars = (char *)sqlite3_column_text(statement, 1);
                char *directorChars = (char *)sqlite3_column_text(statement, 3);
                
                NSString *title = [NSString stringWithUTF8String:titleChars];
                NSString *answer = [NSString stringWithUTF8String:directorChars];
                
                NSMutableArray *directorOptions = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < 3; i++) {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        directorChars = (char *)sqlite3_column_text(statement, 3);
                        NSString *director = [NSString stringWithUTF8String:directorChars];
                        
                        [directorOptions addObject:director];
                    } else {
                        // If there are not enough movies in the database
                        [directorOptions addObject:@"ERROR"];
                    }
                }
                
                
                // Insert the correct answer at a random index
                NSString *question = [NSString stringWithFormat:@"Who directed '%@'?", title];
                
                int answerIndex = arc4random() % 4;
                [directorOptions insertObject:answer atIndex:answerIndex];
                
                QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question
                                                                            answers:directorOptions
                                                                        answerIndex:answerIndex];
                
                sqlite3_finalize(statement);

                return quizQuestion;
            }
        }
    } else if (r == 1) {
        
    }
    
    return nil;
}

- (void)dealloc {
    sqlite3_close(database);
}

@end

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
- (Movie)randomMovieWithStars:(NSInteger)numStars;

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
    QuizQuestionType questionType = arc4random() % 4;
    
    // TODO
    // correct answers can be repeated
    // consolidate code
    
    if (questionType == QuizQuestionTypeDirector) {
        NSLog(@"Director Called");
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
        NSLog(@"Year Called");
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
        
        NSInteger movieID = movie.id;
        NSString *movieTitle = [NSString stringWithUTF8String:movie.title];
                
        // Get correct answer
        NSString *query = [NSString stringWithFormat:@"SELECT stars.first_name, stars.last_name FROM stars, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id=%d ORDER BY RANDOM() LIMIT 1;", movie.id];
        
        NSString *starFirstName, *starLastName, *answer;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                char *nameChars = (char *)sqlite3_column_text(statement, 0);
                starFirstName = [NSString stringWithUTF8String:nameChars];
                
                nameChars = (char *)sqlite3_column_text(statement, 1);
                starLastName = [NSString stringWithUTF8String:nameChars];
                
                answer = [NSString stringWithFormat:@"%@ %@", starFirstName, starLastName];
            }
        }
        
        // Get incorrect answers
        query = [NSString stringWithFormat:@"SELECT first_name, last_name FROM stars, stars_in_movies WHERE first_name!='%@' AND stars.last_name !='%@' AND stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id!=%d ORDER BY RANDOM() LIMIT 3;", starFirstName, starLastName, movieID];
        
        NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *nameChars = (char *)sqlite3_column_text(statement, 0);
                starFirstName = [NSString stringWithUTF8String:nameChars];
                
                nameChars = (char *)sqlite3_column_text(statement, 1);
                starLastName = [NSString stringWithUTF8String:nameChars];
                
                // Add the star's name to the array of answer options
                [answerOptions addObject:[NSString stringWithFormat:@"%@ %@", starFirstName, starLastName]];
            }
        }
        
        // Insert the correct answer at a random index
        NSString *question = [NSString stringWithFormat:@"Which star was in '%@'?", movieTitle];
        
        int answerIndex = arc4random() % 4;
        [answerOptions insertObject:answer atIndex:answerIndex];
        
        QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question
                                                                    answers:answerOptions
                                                                answerIndex:answerIndex];
        
        sqlite3_finalize(statement);
        return quizQuestion;
    } else if (questionType == QuizQuestionTypeStarNotInMovie) {
        Movie movie = [self randomMovieWithStars:3];
        
        NSInteger movieID = movie.id;
        NSString *movieTitle = [NSString stringWithUTF8String:movie.title];
        
        // Get correct answer
        NSString *query = [NSString stringWithFormat:@"SELECT stars.first_name, stars.last_name, stars.id AS s FROM stars, stars_in_movies WHERE NOT EXISTS (SELECT stars.id FROM stars, stars_in_movies WHERE stars_in_movies.star_id=s AND stars_in_movies.movie_id=%d) ORDER BY RANDOM() LIMIT 1;", movie.id];
        
        NSString *starFirstName, *starLastName, *answer;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                char *nameChars = (char *)sqlite3_column_text(statement, 0);
                starFirstName = [NSString stringWithUTF8String:nameChars];
                
                nameChars = (char *)sqlite3_column_text(statement, 1);
                starLastName = [NSString stringWithUTF8String:nameChars];
                
                answer = [NSString stringWithFormat:@"%@ %@", starFirstName, starLastName];
            }
        }
        
        // Get incorrect answers
        query = [NSString stringWithFormat:@"SElECT stars.first_name, stars.last_name FROM stars, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id=%d ORDER BY RANDOM() LIMIT 3;", movieID];
        
        NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *nameChars = (char *)sqlite3_column_text(statement, 0);
                starFirstName = [NSString stringWithUTF8String:nameChars];
                
                nameChars = (char *)sqlite3_column_text(statement, 1);
                starLastName = [NSString stringWithUTF8String:nameChars];
                
                // Add the star's name to the array of answer options
                [answerOptions addObject:[NSString stringWithFormat:@"%@ %@", starFirstName, starLastName]];
            }
        }
        
        // Insert the correct answer at a random index
        NSString *question = [NSString stringWithFormat:@"Which star was not in '%@'?", movieTitle];
        
        int answerIndex = arc4random() % 4;
        [answerOptions insertObject:answer atIndex:answerIndex];
        
        QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question
                                                                    answers:answerOptions
                                                                answerIndex:answerIndex];
        
        sqlite3_finalize(statement);
        return quizQuestion;
    } else if (questionType == QuizQuestionTypeStarsAppearTogether) {
        Movie movie = [self randomMovie];
        
        NSInteger movieID = movie.id;
        NSString *movieTitle = [NSString stringWithUTF8String:movie.title];
        
        // Get correct answer
        NSString *query = [NSString stringWithFormat:@"SELECT stars.first_name, stars.last_name, stars.id AS s FROM stars, stars_in_movies WHERE NOT EXISTS (SELECT stars.id FROM stars, stars_in_movies WHERE stars_in_movies.star_id=s AND stars_in_movies.movie_id=%d) ORDER BY RANDOM() LIMIT 1;", movie.id];
        
        NSString *starFirstName, *starLastName, *answer;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                char *nameChars = (char *)sqlite3_column_text(statement, 0);
                starFirstName = [NSString stringWithUTF8String:nameChars];
                
                nameChars = (char *)sqlite3_column_text(statement, 1);
                starLastName = [NSString stringWithUTF8String:nameChars];
                
                answer = [NSString stringWithFormat:@"%@ %@", starFirstName, starLastName];
            }
        }
        
        // Get incorrect answers
        query = [NSString stringWithFormat:@"SElECT stars.first_name, stars.last_name FROM stars, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id=%d ORDER BY RANDOM() LIMIT 3;", movieID];
        
        NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *nameChars = (char *)sqlite3_column_text(statement, 0);
                starFirstName = [NSString stringWithUTF8String:nameChars];
                
                nameChars = (char *)sqlite3_column_text(statement, 1);
                starLastName = [NSString stringWithUTF8String:nameChars];
                
                // Add the star's name to the array of answer options
                [answerOptions addObject:[NSString stringWithFormat:@"%@ %@", starFirstName, starLastName]];
            }
        }
        
        // Insert the correct answer at a random index
        NSString *question = [NSString stringWithFormat:@"Which star was not in '%@'?", movieTitle];
        
        int answerIndex = arc4random() % 4;
        [answerOptions insertObject:answer atIndex:answerIndex];
        
        QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question
                                                                    answers:answerOptions
                                                                answerIndex:answerIndex];
        
        sqlite3_finalize(statement);
        return quizQuestion;
    }
    
    return nil;
}

- (Movie)randomMovie {
    sqlite3_stmt *statement;
    NSString *query = @"SELECT id, title, director FROM movies ORDER BY RANDOM() LIMIT 1;";
    
    Movie movie;
        
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            // Get the id and title of the first
            movie.id = sqlite3_column_int(statement, 0);
            
            // Duplicate the return strings so they are not freed after calling sqlite3_finalize
            movie.title = strdup((char *)sqlite3_column_text(statement, 1));
            movie.director = strdup((char *)sqlite3_column_text(statement, 2));
        }
    }
        
    sqlite3_finalize(statement);
    return movie;
}

// Returns a random movie with numStars or more stars
- (Movie)randomMovieWithStars:(NSInteger)numStars {
    sqlite3_stmt *statement;
    NSString *query = [NSString stringWithFormat:@"SELECT id, title, director FROM movies, stars_in_movies WHERE (SELECT count(stars_in_movies.star_id) FROM stars_in_movies WHERE stars_in_movies.movie_id=movies.id) >= %d ORDER BY RANDOM() LIMIT 1;", numStars];
    
    Movie movie;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            // Get the id and title of the first
            movie.id = sqlite3_column_int(statement, 0);
            
            // Duplicate the return strings so they are not freed after calling sqlite3_finalize
            movie.title = strdup((char *)sqlite3_column_text(statement, 1));
            movie.director = strdup((char *)sqlite3_column_text(statement, 2));
        }
    }
    
    sqlite3_finalize(statement);
    return movie;
}

- (void)dealloc {
    sqlite3_close(database);
}

@end

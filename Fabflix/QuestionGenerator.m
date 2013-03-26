//
//  QuestionGenerator.m
//  Fabflix
//
//  Created by Nealon Young on 3/13/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "QuestionGenerator.h"

@interface QuestionGenerator() {
    FMDatabase *database;
}

@end

@implementation QuestionGenerator

- (id)init {
    self = [super init];
    
    if (self) {
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"fabflix" ofType:@"sqlite3"];
        database = [FMDatabase databaseWithPath:databasePath];
        
        [database open];
    }
    
    return self;
}

- (QuizQuestion *)newQuestion {
    QuizQuestion *currentQuestion;
    int questionType = arc4random() % 10;
    
    switch (questionType) {
        case 0:
            currentQuestion = [self getQuestionTypeDirector];
            break;
        case 1:
            currentQuestion = [self getQuestionTypeYear];
            break;
        case 2:
            currentQuestion = [self getQuestionTypeStarInMovie];
            break;
        case 3:
            currentQuestion = [self getQuestionTypeStarNotInMovie];
            break;
        case 4:
            currentQuestion = [self getQuestionTypeStarsAppearTogether];
            break;
        case 5:
            currentQuestion = [self getQuestionTypeDirectorForStar];
            break;
        case 6:
            currentQuestion = [self getQuestionTypeNotDirectorForStar];
            break;
        case 7:
            currentQuestion = [self getQuestionTypeStarAppearBothMovies];
            break;
        case 8:
            currentQuestion = [self getQuestionTypeStarNotAppearWithStar];
            break;
        case 9:
            currentQuestion = [self getQuestionTypeDirectorForStarInYear];
            break;
    }
    
    return currentQuestion;
}

- (QuizQuestion *)getQuestionTypeDirector {
    QuizItem *movie = [self randomMovie];
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT director FROM movies WHERE director!=? ORDER BY RANDOM() LIMIT 3;", movie.director];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]){
        NSString *name = [incorrect stringForColumn:@"director"];
        [answerOptions addObject:name];
    }
    
    NSString *question = [NSString stringWithFormat:@"Who directed '%@'?", movie.title];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:movie.director incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeYear {
    QuizItem *movie = [self randomMovie];
    
    FMResultSet *correct = [database executeQuery:@"SELECT year FROM movies WHERE id=?;", [NSNumber numberWithInt:movie.id]];
    NSString *answer;
    
    while ([correct next]) {
        answer = [NSString stringWithFormat:@"%d", [correct intForColumn:@"year"]];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT DISTINCT year FROM movies WHERE year!=? ORDER BY RANDOM() LIMIT 3;", answer];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        [answerOptions addObject:[NSString stringWithFormat:@"%d", [incorrect intForColumn:@"year"]]];
    }
    
    NSString *question = [NSString stringWithFormat:@"In what year was '%@' released?", movie.title];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:answer incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeStarInMovie {
    QuizItem *movie = [self randomMovie];
    
    FMResultSet *correct = [database executeQuery:@"SELECT stars.first_name, stars.last_name FROM stars, stars_in_movies WHERE stars_in_movies.movie_id=? AND stars_in_movies.star_id=stars.id ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:movie.id]];
    
    NSString *correctFirstName;
    NSString *correctLastName;
    NSString *star;
    
    if ([correct next]) {
        correctFirstName = [correct stringForColumn:@"first_name"];
        correctLastName = [correct stringForColumn:@"last_name"];
        star = [NSString stringWithFormat:@"%@ %@", correctFirstName, correctLastName];
    }
    
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT first_name, last_name FROM stars, stars_in_movies WHERE first_name!=? AND stars.last_name!=? AND stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id!=? ORDER BY RANDOM() LIMIT 3;", correctFirstName, correctLastName, [NSNumber numberWithInteger:movie.id]];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        [answerOptions addObject:[NSString stringWithFormat:@"%@ %@", [incorrect stringForColumn:@"first_name"], [incorrect stringForColumn:@"last_name"]]];
    }
    
    NSString *question = [NSString stringWithFormat:@"Which star was in '%@'?", movie.title];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:star incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeStarNotInMovie {
    QuizItem *movie = [self randomMovieWithMinimumStars:3];
    
    FMResultSet *correct = [database executeQuery:@"SELECT stars.first_name, stars.last_name, stars.id AS s FROM stars WHERE NOT EXISTS (SELECT stars.id FROM stars, stars_in_movies WHERE stars_in_movies.star_id=s AND stars_in_movies.movie_id=?) ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:movie.id]];
    
    NSString *answer;
    
    if ([correct next]) {
        answer = [NSString stringWithFormat:@"%@ %@", [correct stringForColumn:@"first_name"], [correct stringForColumn:@"last_name"]];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT stars.first_name, stars.last_name FROM stars, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id=? ORDER BY RANDOM() LIMIT 3;", [NSNumber numberWithInteger:movie.id]];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    // Add incorrect names to the list of answer options
    while ([incorrect next]) {
        [answerOptions addObject:[NSString stringWithFormat:@"%@ %@", [incorrect stringForColumn:@"first_name"], [incorrect stringForColumn:@"last_name"]]];
    }
    
    NSString *question = [NSString stringWithFormat:@"Which star was not in '%@'?", movie.title];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:answer incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeStarsAppearTogether {
    QuizItem *movie = [self randomMovieWithMinimumStars:3];
    
    FMResultSet *stars = [database executeQuery:@"SELECT stars.first_name, stars.last_name, stars.id FROM stars, stars_in_movies WHERE stars_in_movies.movie_id=? AND stars_in_movies.star_id=stars.id ORDER BY RANDOM() LIMIT 2;", [NSNumber numberWithInteger:movie.id]];
    
    NSInteger starID = 0;
    NSString *firstStar;
    NSString *secondStar;
    
    // Get info on the two stars
    if ([stars next]) {
        firstStar = [NSString stringWithFormat:@"%@ %@", [stars stringForColumn:@"first_name"], [stars stringForColumn:@"last_name"]];
        starID = [stars intForColumn:@"id"];
    }
    
    if ([stars next]) {
        secondStar = [NSString stringWithFormat:@"%@ %@", [stars stringForColumn:@"first_name"], [stars stringForColumn:@"last_name"]];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT title, movies.id AS m FROM movies WHERE NOT EXISTS(SELECT star_id FROM stars_in_movies WHERE star_id=? AND movie_id=m) ORDER BY RANDOM() LIMIT 3;", [NSNumber numberWithInteger:starID]];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        [answerOptions addObject:[incorrect stringForColumn:@"title"]];
    }
    
    NSString *question = [NSString stringWithFormat:@"In which movie did %@ and %@ appear together?", firstStar, secondStar];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:movie.title incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeDirectorForStar {
    QuizItem *movie = [self randomMovie];
    
    FMResultSet *correct = [database executeQuery:@"SELECT stars.first_name, stars.last_name, stars.id FROM stars, stars_in_movies WHERE stars_in_movies.movie_id=? AND stars_in_movies.star_id=stars.id ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:movie.id]];
    
    NSString *star;
    NSInteger starID = 0;
    
    if ([correct next]) {
        star = [NSString stringWithFormat:@"%@ %@", [correct stringForColumn:@"first_name"], [correct stringForColumn:@"last_name"]];
        starID = [correct intForColumn:@"id"];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT director, movies.id AS m FROM movies WHERE NOT EXISTS(SELECT star_id FROM stars_in_movies WHERE star_id=? AND movie_id=m) ORDER BY RANDOM() LIMIT 3;", [NSNumber numberWithInteger:starID]];
    
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        [answerOptions addObject:[incorrect stringForColumn:@"director"]];
    }
    
    NSString *question = [NSString stringWithFormat:@"Who directed the star %@?", star];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:movie.director incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeNotDirectorForStar {
    FMResultSet *details = [database executeQuery:@"SELECT first_name, last_name, id FROM stars WHERE (SELECT COUNT(DISTINCT director) FROM stars_in_movies AS s, movies AS m WHERE stars.id=s.star_id AND m.id=s.movie_id) >= 3 ORDER BY RANDOM() LIMIT 1;"];
    
    NSString *star;
    NSInteger starID = 0;
    
    if ([details next]) {
        star = [NSString stringWithFormat:@"%@ %@", [details stringForColumn:@"first_name"], [details stringForColumn:@"last_name"]];
        starID = [details intForColumn:@"id"];
    }
    
    FMResultSet *correct = [database executeQuery:@"SELECT director FROM movies AS m, stars_in_movies AS s WHERE NOT EXISTS (SELECT stars_in_movies.movie_id FROM stars_in_movies WHERE stars_in_movies.movie_id=m.id AND stars_in_movies.star_id=?) ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:starID]];
    
    NSString *answer;
    
    if ([correct next]) {
        answer = [correct stringForColumn:@"director"];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT DISTINCT director FROM movies NATURAL JOIN stars_in_movies WHERE stars_in_movies.star_id=? AND stars_in_movies.movie_id=id ORDER BY RANDOM() LIMIT 3;", [NSNumber numberWithInteger:starID]];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        NSString *director = [incorrect stringForColumn:@"director"];
        [answerOptions addObject:director];
    }
    
    NSString *question = [NSString stringWithFormat:@"Who did not direct %@?", star];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:answer incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeStarAppearBothMovies {
    FMResultSet *star = [database executeQuery:@"SELECT stars.id, stars.first_name, stars.last_name from stars, stars_in_movies as s, stars_in_movies as m WHERE m.star_id = stars.id AND s.star_id = stars.id AND m.movie_id != s.movie_id ORDER BY RANDOM() LIMIT 1;"];
    
    NSString *answer;
    NSInteger starID = 0;
    
    if ([star next]) {
        answer = [NSString stringWithFormat:@"%@ %@", [star stringForColumn:@"first_name"], [star stringForColumn:@"last_name"]];
        starID = [star intForColumn:@"id"];
    }
    
    FMResultSet *movies = [database executeQuery:@"SELECT movies.title, movies.id from movies, stars_in_movies WHERE stars_in_movies.star_id=? AND stars_in_movies.movie_id = movies.id ORDER BY RANDOM() LIMIT 2;", [NSNumber numberWithInteger:starID]];
    NSMutableArray *movieNames = [[NSMutableArray alloc] init];
    NSMutableArray *movieIds = [[NSMutableArray alloc] init];
    NSNumber *movieID;
    
    while ([movies next]) {
        movieID = [NSNumber numberWithInteger:[movies intForColumn:@"id"]];
        
        [movieNames addObject:[movies stringForColumn:@"title"]];
        [movieIds addObject:movieID];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT stars.first_name, stars.last_name from stars, stars_in_movies WHERE stars_in_movies.star_id = stars.id AND stars_in_movies.movie_id != ? ORDER BY RANDOM() LIMIT 3;", movieID];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        [answerOptions addObject:[NSString stringWithFormat:@"%@ %@", [incorrect stringForColumn:@"first_name"], [incorrect stringForColumn:@"last_name"]]];
    }
    
    NSString *question = [NSString stringWithFormat:@"Which star appears in both '%@' and '%@'?", [movieNames objectAtIndex:0], [movieNames objectAtIndex:1]];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:answer incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeStarNotAppearWithStar {
    FMResultSet *movies = [database executeQuery:@"SELECT movies.id from movies, stars_in_movies WHERE (SELECT count (distinct stars.last_name) from stars, stars_in_movies WHERE stars_in_movies.movie_id=movies.id and stars_in_movies.star_id = stars.id) >= 4 ORDER BY RANDOM() LIMIT 1;"];
    
    NSInteger movieID = 0;
    
    if ([movies next]) {
        movieID = [movies intForColumn:@"id"];
    }
    NSLog(@"%d", movieID);
    FMResultSet *results = [database executeQuery:@"SELECT stars.first_name, stars.last_name from stars, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id = ? ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:movieID]];
    
    NSString *star;
    NSString *starFirstName;
    NSString *starLastName;
    
    while ([results next]){
        starFirstName = [results stringForColumn:@"first_name"];
        starLastName = [results stringForColumn:@"last_name"];
        
        star = [NSString stringWithFormat:@"%@ %@", starFirstName, starLastName];
    }
    
    FMResultSet *correct = [database executeQuery:@"SELECT stars.first_name, stars.last_name FROM stars, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id!=? ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:movieID]];
    
    NSString *answer;
    
    if ([correct next]) {
        answer = [NSString stringWithFormat:@"%@ %@", [correct stringForColumn:@"first_name"], [correct stringForColumn:@"last_name"]];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT distinct stars.first_name, stars.last_name from stars, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id=? AND stars.first_Name != ? AND stars.last_name != ?ORDER BY RANDOM() LIMIT 3;", [NSNumber numberWithInteger:movieID], starFirstName, starLastName];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        [answerOptions addObject:[NSString stringWithFormat:@"%@ %@", [incorrect stringForColumn:@"first_name"], [incorrect stringForColumn:@"last_name"]]];
    }
    
    NSString *question = [NSString stringWithFormat:@"Which star did not appear in the same movie with %@?", star];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:answer incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

- (QuizQuestion *)getQuestionTypeDirectorForStarInYear {
    QuizItem *movie = [self randomMovie];
    
    FMResultSet *details = [database executeQuery:@"SELECT stars.first_name, stars.last_name, stars.id, movies.year, movies.id from stars, movies, stars_in_movies WHERE stars_in_movies.star_id=stars.id AND stars_in_movies.movie_id= ? AND movies.id= ? ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:movie.id], [NSNumber numberWithInteger:movie.id]];
    
    NSString *star;
    NSInteger year, starID;
    
    while([details next]) {
        star = [NSString stringWithFormat:@"%@ %@", [details stringForColumn:@"first_name"], [details stringForColumn:@"last_name"]];
        year = [details intForColumn:@"year"];
        starID = [details intForColumn:@"id"];
    }
    
    FMResultSet *incorrect = [database executeQuery:@"SELECT movies.director from movies, stars_in_movies WHERE stars_in_movies.movie_id=movies.id AND stars_in_movies.star_id!=? ORDER BY RANDOM() LIMIT 3;", [NSNumber numberWithInteger:starID]];
    NSMutableArray *answerOptions = [[NSMutableArray alloc] init];
    
    while ([incorrect next]) {
        [answerOptions addObject:[incorrect stringForColumn:@"director"]];
    }
    
    NSString *question = [NSString stringWithFormat:@"Who directed %@ in %d?", star, year];
    QuizQuestion *quizQuestion = [self generateQuestion:question withCorrectAnswer:movie.director incorrectAnswers:answerOptions];
    
    return quizQuestion;
}

//Helper method that returns a random movie
- (QuizItem *)randomMovie {
    FMResultSet *result = [database executeQuery:@"SELECT id, title, director from movies WHERE (SELECT count(stars_in_movies.star_id) from stars_in_movies WHERE stars_in_movies.movie_id=movies.id) >= 1 ORDER BY RANDOM() LIMIT 1;"];
    
    NSInteger identifier;
    NSString *title, *director;
    
    while ([result next]) {
        identifier = [result intForColumn:@"id"];
        title = [result stringForColumn:@"title"];
        director = [result stringForColumn:@"director"];
    }
    
    QuizItem *item = [[QuizItem alloc] initWithInfo:title id:identifier director:director];
    
    return item;
}

//Helper method that returns a random movie at least the specified minimum number of stars.
- (QuizItem *)randomMovieWithMinimumStars:(NSInteger)stars {
    FMResultSet *result = [database executeQuery:@"SELECT id, title, director from movies, stars_in_movies WHERE (SELECT count(stars_in_movies.star_id) from stars_in_movies WHERE stars_in_movies.movie_id=movies.id) >= ? ORDER BY RANDOM() LIMIT 1;", [NSNumber numberWithInteger:stars]];
    
    NSInteger identifier;
    NSString *title, *director;
    
    while ([result next]) {
        identifier = [result intForColumn:@"id"];
        title = [result stringForColumn:@"title"];
        director = [result stringForColumn:@"director"];
    }
    
    QuizItem *item = [[QuizItem alloc] initWithInfo:title id:identifier director:director];
    
    return item;
}

//Helper Method that takes a the question in string format, the answer, and an array of incorrect answers.
- (QuizQuestion *)generateQuestion:(NSString *)question withCorrectAnswer:(NSString *)answer incorrectAnswers:(NSMutableArray *)answers {
    int answerIndex = arc4random() % 4;
    [answers insertObject:answer atIndex:answerIndex];
    
    QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithQuestion:question answers:answers answerIndex:answerIndex];
    return quizQuestion;
}

@end

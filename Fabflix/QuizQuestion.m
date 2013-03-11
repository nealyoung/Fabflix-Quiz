//
//  QuizQuestion.m
//  Fabflix
//
//  Created by Nealon Young on 3/10/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "QuizQuestion.h"

@implementation QuizQuestion

- (id)initWithQuestion:(NSString *)question answers:(NSArray *)answers answerIndex:(NSInteger)answerIndex {
    self = [super init];
    
    if (self) {
        _question = question;
        _answers = answers;
        _answerIndex = answerIndex;
    }
    
    return self;
}

@end

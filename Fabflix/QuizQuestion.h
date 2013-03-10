//
//  QuizQuestion.h
//  Fabflix
//
//  Created by Nealon Young on 3/10/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizQuestion : NSObject

@property NSString *question;
@property NSArray *answers;
@property NSInteger answerIndex;

- (id)initWithQuestion:(NSString *)question answers:(NSArray *)answers answerIndex:(NSInteger)answerIndex;

@end

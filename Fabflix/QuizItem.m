//
//  QuizItem.m
//  Fabflix
//
//  Created by Alex Lipsett on 3/11/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import "QuizItem.h"

@implementation QuizItem

-(id)initWithInfo:(NSString *)title id:(NSInteger)id director:(NSString *)director {
    self = [super init];
    
    if (self) {
        _id = id;
        _title = title;
        _director = director;
    }
    
    return self;
}

@end

//
//  QuizItem.h
//  Fabflix
//
//  Created by Alex Lipsett on 3/11/13.
//  Copyright (c) 2013 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizItem : NSObject

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *director;

-(id)initWithInfo:(NSString *)title id:(NSInteger)id director:(NSString*)director;

@end

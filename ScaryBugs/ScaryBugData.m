//
//  ScaryBugData.m
//  ScaryBugs
//
//  Created by Brian Crider on 1/11/13.
//  Copyright (c) 2013 Brian Crider. All rights reserved.
//

#import "ScaryBugData.h"

@implementation ScaryBugData

- (id)initWithTitle:(NSString*)title rating:(float)rating
{
    if ((self = [super init]))
    {
        self.title = title;
        self.rating = rating;
    }
    return self;
}

@end



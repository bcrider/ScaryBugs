//
//  ScaryBugData.h
//  ScaryBugs
//
//  Created by Brian Crider on 1/11/13.
//  Copyright (c) 2013 Brian Crider. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugData : NSObject

@property (strong) NSString *title;
@property (assign) float rating;

- (id)initWithTitle:(NSString*)title rating:(float)rating;

@end
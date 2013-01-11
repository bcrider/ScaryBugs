//
//  DetailViewController.h
//  ScaryBugs
//
//  Created by Brian Crider on 1/11/13.
//  Copyright (c) 2013 Brian Crider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

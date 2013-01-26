//
//  DetailViewController.m
//  ScaryBugs
//
//  Created by Brian Crider on 1/11/13.
//  Copyright (c) 2013 Brian Crider. All rights reserved.
//

#pragma mark Brian Crider is learning...

#import "DetailViewController.h"
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import "UIImageExtras.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

/////////////////////////////////////////////////////////////////
#pragma mark - Managing the detail item
/////////////////////////////////////////////////////////////////

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

/////////////////////////////////////////////////////////////////
- (void)configureView
{
    // Update the user interface for the detail item.
    self.rateView.notSelectedImage = [UIImage imageNamed:@"shockedface2_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"shockedface2_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"shockedface2_full.png"];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    // Set up the initial UI State
    if (self.detailItem)
    {
        self.titleField.text = self.detailItem.data.title;
        self.rateView.rating = self.detailItem.data.rating;
        self.imageView.image = self.detailItem.fullImage;
    }

}

/////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

/////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////////////////////////////////
// Before running this on a thread along with a progress dialog
/////////////////////////////////////////////////////////////////
//- (IBAction)addPictureTapped:(id)sender
//{
//    if (self.picker == nil)
//    {
//        self.picker = [[UIImagePickerController alloc] init];
//        self.picker.delegate = self;
//        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        self.picker.allowsEditing = NO;
//    }
//    [self.navigationController presentModalViewController:_picker animated:YES];
//}

/////////////////////////////////////////////////////////////////
// AFTER running this on a thread along with a progress dialog
/////////////////////////////////////////////////////////////////
- (IBAction)addPictureTapped:(id)sender
{
    if (self.picker == nil)
    {
        
        // 1) Show status
        [SVProgressHUD showWithStatus:@"Loading picker..."];
        
        // 2) Get a concurrent queue form the system
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // 3) Load picker in background
        dispatch_async(concurrentQueue, ^{
            
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.allowsEditing = NO;
            
            // 4) Present picker in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController presentModalViewController:_picker animated:YES];
                [SVProgressHUD dismiss];
            });
            
        });
        
    }
    else
    {
        [self.navigationController presentModalViewController:_picker animated:YES];
    }
}

/////////////////////////////////////////////////////////////////
- (IBAction)titleFieldTextChanged:(id)sender
{
    self.detailItem.data.title = self.titleField.text;
}

/////////////////////////////////////////////////////////////////
#pragma mark UITextFieldDelegate
/////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/////////////////////////////////////////////////////////////////
#pragma mark RateViewDelegate
/////////////////////////////////////////////////////////////////

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating
{
    self.detailItem.data.rating = rating;
}

/////////////////////////////////////////////////////////////////
#pragma mark UIImagePickerControllerDelegate
/////////////////////////////////////////////////////////////////

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

/////////////////////////////////////////////////////////////////
// Before running this on a thread along with a progress dialog
/////////////////////////////////////////////////////////////////
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    [self dismissModalViewControllerAnimated:YES];
//    
//    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
//    self.detailItem.fullImage = fullImage;
//    self.detailItem.thumbImage = thumbImage;
//    self.imageView.image = fullImage;
//}

/////////////////////////////////////////////////////////////////
// AFTER running this on a thread along with a progress dialog
/////////////////////////////////////////////////////////////////
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 1) Show status
    [SVProgressHUD showWithStatus:@"Resizing image..."];
    
    // 2) Get a concurrent queue form the system
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 3) Resize image in background
    dispatch_async(concurrentQueue, ^{
        
        UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        
        // 4) Present image in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailItem.fullImage = fullImage;
            self.detailItem.thumbImage = thumbImage;
            self.imageView.image = fullImage;
            [SVProgressHUD dismiss];
        });
        
    });
    
}
@end

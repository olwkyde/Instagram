//
//  PhotoMapViewController.h
//  Instagram
//
//  Created by Isaac Oluwakuyide on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol PhotoMapViewControllerDelegate
- (void)didPost:(Post *) post;
@end

NS_ASSUME_NONNULL_BEGIN

@interface PhotoMapViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (nonatomic, weak) id <PhotoMapViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

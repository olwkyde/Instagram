//
//  PhotoMapViewController.m
//  Instagram
//
//  Created by Isaac Oluwakuyide on 7/6/21.
//

#import "PhotoMapViewController.h"
#import "FeedViewController.h"
#import "Post.h"

@interface PhotoMapViewController ()
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set default text and text color
    self.captionTextView.text = @"Write Caption Here";
    self.captionTextView.textColor = UIColor.lightGrayColor;
    
    self.captionTextView.delegate = self;

}

- (void) fetchPosts {
    
}



- (IBAction)imageButtonPressed:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];

}
- (IBAction)cancelButtonPressed:(id)sender {
    FeedViewController *feedViewController = [[UIViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)shareButtonPressed:(id)sender {
    if (![self.selectPhotoButton.titleLabel.text  isEqual: @""])  {
        //create a UIAlertController
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"  message:@"You did not select an image" preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // handle response here.
            }];
        //add the OK
        [alert addAction:okAction];
        
        //present the alert controller
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    } else if (([self.selectPhotoButton.titleLabel.text  isEqual: @""] &&
         ([self.captionTextView.text isEqualToString:@""])) || [self.captionTextView.text isEqualToString:@"Write Caption Here"] )   {
        //create a UIAlertController
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"  message:@"Do you want to post without a caption?" preferredStyle:(UIAlertControllerStyleAlert)];
        
        
        // create a CANCEL action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
        //add the CANCEL action to the alert
        [alert addAction:cancelAction];
        
        // create a YES action
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //dismiss the control if YES is selected and set the text to empty string
            self.captionTextView.text = @"";

            
            //create instance of Post
            Post *post = [[Post alloc] init];
            
            UIImage *image = self.selectPhotoButton.imageView.image;
            
            //resize post
            UIImage *finalPost = [post resizeImage:image withSize:CGSizeMake(image.size.width, image.size.height)];
            
            //post it to Parse database
            [Post postUserImage:finalPost withCaption:self.captionTextView.text withCompletion:nil];
            //dismissViewController
            [self dismissViewControllerAnimated:YES completion:nil];
            }];
        //add the YES action to the alert
        [alert addAction:yesAction];
        
        // present the alert controller
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
        
    }
    else    {
        //create instance of Post
        Post *post = [[Post alloc] init];
        
        UIImage *image = self.selectPhotoButton.imageView.image;
        
        //resize post
        UIImage *finalPost = [post resizeImage:image withSize:CGSizeMake(image.size.width, image.size.height)];
        
        //post it to Parse database
        [Post postUserImage:finalPost withCaption:self.captionTextView.text withCompletion:nil];
        
        //dismiss the controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    [self.selectPhotoButton setImage:editedImage forState:UIControlStateNormal];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.selectPhotoButton setTitle:@"" forState:UIControlStateNormal];
    self.selectPhotoButton.titleLabel.text = @"";
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.captionTextView.textColor == UIColor.lightGrayColor)   {
        self.captionTextView.text = nil;
        self.captionTextView.textColor = UIColor.blackColor;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.captionTextView.text isEqualToString:@"" ])   {
        self.captionTextView.text = @"Write Caption Here";
        self.captionTextView.textColor = UIColor.lightGrayColor;
    }
}


@end

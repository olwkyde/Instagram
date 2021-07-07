//
//  PhotoMapViewController.m
//  Instagram
//
//  Created by Isaac Oluwakuyide on 7/6/21.
//

#import "PhotoMapViewController.h"
#import "FeedViewController.h"

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
    
    [self captionDidBeginEditing];
    [self captionDidFinishEditing];

}

//check if caption is being edited
- (void) captionDidBeginEditing    {
    if (self.captionTextView.textColor == UIColor.lightGrayColor)   {
        self.captionTextView.text = nil;
        self.captionTextView.textColor = UIColor.blackColor;
    }
}

//check if caption is done being edited
- (void) captionDidFinishEditing    {
    if ([self.captionTextView.text isEqualToString:@"" ])   {
        self.captionTextView.text = @"Write Caption Here";
        self.captionTextView.textColor = UIColor.lightGrayColor;
    }
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
    [self.selectPhotoButton setTitle:@"" forState:UIControlStateNormal];
    [self.selectPhotoButton setImage:editedImage forState:UIControlStateNormal];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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

//
//  DetailViewController.m
//  Instagram
//
//  Created by Isaac Oluwakuyide on 7/8/21.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set the view controller attributes
    self.captionLabel.text = self.post.caption;
    self.commentCountLabel.text = [[NSString stringWithFormat:@"%@",self.post.commentCount] stringByAppendingString:@" likes"];
    self.likeCountLabel.text = [[NSString stringWithFormat:@"%@",self.post.likeCount] stringByAppendingString:@" likes"];
    self.postImageView.image = [UIImage imageWithData:[self.post.image getData]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

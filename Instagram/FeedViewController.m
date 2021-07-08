//
//  FeedViewController.m
//  Instagram
//
//  Created by Isaac Oluwakuyide on 7/6/21.
//

#import "FeedViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PostCell.h"
#import <Parse/Parse.h>
#import "DetailViewController.h"
#import "PhotoMapViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMessages) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchMessages];
}


-(void) fetchMessages   {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"DetailSegue"]) {
        //assign the tappedCell to a new PostCell
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        Post *post = self.posts[indexPath.row];
        
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = post;
    }   else{
//        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
}

- (IBAction)logoutButtonPressed:(id)sender {
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // initialize cell
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    //initialize post and set it to the post in the array that is chosen
    Post *post = [[Post alloc] init];
    post = self.posts[indexPath.row];
    
    //set the cell attributes
    cell.captionLabel.text = post.caption;
    cell.postImageView.image = [UIImage imageWithData:[post.image getData]];
    
    PFUser *user = self.posts[indexPath.row][@"author"];
    if (user != nil)    {
        cell.usernameLabel.text = user.username;
    }
    
    int LC = [post.likeCount intValue];
    cell.likeCountLabel.text = [[NSString stringWithFormat:@"%d",LC] stringByAppendingString:@" likes"];
    
    int CC = [post.commentCount intValue];
    cell.commentCountLabel.text = [[NSString stringWithFormat:@"%d",CC] stringByAppendingString:@" comments"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


@end

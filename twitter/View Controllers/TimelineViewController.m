//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "LoginViewController.h"
#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweetsArray;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@end
//


@implementation TimelineViewController

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
//    [UIApplication sharedApplication].delegate;
    [[APIManager shared] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
////  Get timeline
//    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
//        if (tweets) {
//            NSLog(@"text😎😎😎 Successfully loaded home timeline");
//            for (Tweet *tweet in tweets) {
//                NSString *text = tweet.text;
//                NSLog(@"%@", text);
//            }
//            self.tweetsArray = (NSMutableArray *)tweets;
//            [self.tableView reloadData];
//        } else {
//            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
//        }
//    }];
    [self fetchTweets];
        self.refreshControl = [[UIRefreshControl alloc] init];//connects refreshcontrol to self
        [self.refreshControl addTarget:self action: @selector(fetchTweets) forControlEvents:UIControlEventValueChanged];//when beginning of refresh control is triggered it reruns fetchMovies
        self.tableView.refreshControl = self.refreshControl;//end of refreshControl
}

-(void)fetchTweets{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"text😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.tweetsArray = (NSMutableArray *)tweets;
            [self.tableView reloadData];
            [self.tableView.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweetsArray[indexPath.row];
//    cell.profilePicture.image=TweetCell
    cell.tweet = tweet;
    
    cell.tweetTextLabel.text=tweet.text;
    cell.userLabel.text=tweet.user.name;
    cell.usernameLabel.text=tweet.user.screenName;
    
    NSString* retweetString = [[NSString alloc] initWithFormat:@"%d", tweet.retweetCount];
    NSString* likeString = [[NSString alloc] initWithFormat:@"%d", tweet.favoriteCount];
    
    [cell.retweetBotton setTitle:retweetString forState:UIControlStateNormal];
    [cell.favoriteButton setTitle:likeString forState:UIControlStateNormal];
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profilePictureImageView.image= [UIImage imageWithData:urlData];
    
    cell.dateLabel.text = tweet.createdAtString;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweetsArray count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     // Handle scroll behavior here
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    //  Get timeline
        [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
            if (tweets) {
                NSLog(@"😎😎😎 Successfully loaded home timeline");
                for (Tweet *tweet in tweets) {
                    NSString *text = tweet.text;
                    NSLog(@"%@", text);
                }
                self.tweetsArray = (NSMutableArray *)tweets;
                [self.tableView reloadData];
            } else {
                NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            }
            // Reload the tableView now that there is new data
             [self.tableView reloadData];

            // Tell the refreshControl to stop spinning
             [refreshControl endRefreshing];
        }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ComposeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
            composeController.delegate = self;
            NSLog(@"This is the compose segue");
    } else if ([[segue identifier] isEqualToString:@"DetailsSegue"]) {
        NSLog(@"This is the detail segue");
        TweetCell *cell = (TweetCell *)sender;
        Tweet *tweet = cell.tweet;
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.tweet = tweet;
        
    }
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweetsArray insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

@end

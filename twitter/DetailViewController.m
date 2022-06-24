//
//  DetailViewController.m
//  twitter
//
//  Created by Oluwanifemi Kolawole on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "DateTools.h"


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBotton;
@property (weak, nonatomic) IBOutlet UIButton *retweetBotton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end


@implementation DetailViewController

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -=1;
        //todo : update fav text
        [self.favoriteBotton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        
        NSString *favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                [self.favoriteBotton setTitle:favoriteCount forState:UIControlStateNormal];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        
    }
        else
        {
            self.tweet.favorited = YES;
            self.tweet.favoriteCount +=1;
            //todo : update fav text
            [self.favoriteBotton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
            
            NSString *favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                    [self.favoriteBotton setTitle:favoriteCount forState:UIControlStateNormal];
            
            [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
                if(error){
                     NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
                }
                else{
                    NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                }
            }];
            
        }
    }
    
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted){
        self.tweet.retweeted=NO;
        self.tweet.retweetCount -=1;
        [self.retweetBotton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        
        NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                [self.retweetBotton setTitle:retweetCount forState:UIControlStateNormal];
    }
    else{
        self.tweet.retweeted=YES;
        self.tweet.retweetCount +=1;
        [self.retweetBotton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        
        NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                [self.retweetBotton setTitle:retweetCount forState:UIControlStateNormal];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.userLabel.text = self.tweet.user.name;
     self.tweetTextLabel.text = self.tweet.text;
     NSString *userName = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
     self.usernameLabel.text = userName;
     
     NSString *URLString = self.tweet.user.profilePicture;
     NSURL *url = [NSURL URLWithString:URLString];
    NSString* retweetString = [[NSString alloc] initWithFormat:@"%d", self.tweet.retweetCount];
    NSString* likeString = [[NSString alloc] initWithFormat:@"%d", self.tweet.favoriteCount];
    
    [self.retweetBotton setTitle:retweetString forState:UIControlStateNormal];
    [self.favoriteBotton setTitle:likeString forState:UIControlStateNormal];
     self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.height / 2;
     self.profilePictureImageView.layer.masksToBounds = YES;
     self.profilePictureImageView.layer.borderWidth = 0;
     [self.profilePictureImageView setImageWithURL: url];
    self.dateLabel.text = self.tweet.createdAtString;
     NSLog(@"%@", self.tweet);
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

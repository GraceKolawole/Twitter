//
//  TweetCell.m
//  twitter
//
//  Created by Oluwanifemi Kolawole on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell
- (IBAction)didTapRetweet:(id)sender{
    if (self.tweet.retweeted){
        self.tweet.retweeted =NO;
        self.tweet.retweetCount -=1;
        [self.retweetBotton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        
        NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                [self.retweetBotton setTitle:retweetCount forState:UIControlStateNormal];

    }
    else{
        self.tweet.retweeted =YES;
        self.tweet.retweetCount +=1;
        [self.retweetBotton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        
        NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                [self.retweetBotton setTitle:retweetCount forState:UIControlStateNormal];
    }
    
}
- (IBAction)didTapFavorite:(id)sender {
    
    if (self.tweet.favorited){
        self.tweet.favorited =NO;
        self.tweet.favoriteCount -=1;
        //todo : update fav text
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        
        NSString *favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                [self.favoriteButton setTitle:favoriteCount forState:UIControlStateNormal];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    else{
        self.tweet.favorited =YES;
        self.tweet.favoriteCount +=1;
        //todo : update fav text
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        
        NSString *favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                [self.favoriteButton setTitle:favoriteCount forState:UIControlStateNormal];
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
    


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

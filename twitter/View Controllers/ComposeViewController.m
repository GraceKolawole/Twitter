//
//  ComposeViewController.m
//  twitter
//
//  Created by Oluwanifemi Kolawole on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController
- (IBAction)closeBotton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetBotton:(id)sender {
    [[APIManager shared]postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
          if(error){
              NSLog(@"Error composing Tweet: %@", error.localizedDescription);
          }
          else{
              [self.delegate didTweet:tweet];
              NSLog(@"Compose Tweet Success!");
              //[self.navigationController popViewControllerAnimated:YES];
              [self dismissViewControllerAnimated:true completion:nil];
          }
      }];
}
//- (IBAction)tweetBotton:(id)sender {
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

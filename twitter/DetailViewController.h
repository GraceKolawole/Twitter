//
//  DetailViewController.h
//  twitter
//
//  Created by Oluwanifemi Kolawole on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END

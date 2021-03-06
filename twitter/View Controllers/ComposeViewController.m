//
//  ComposeViewController.m
//  twitter
//
//  Created by Jacob Franz on 6/30/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tweetTextView setDelegate:self];
    
    if (self.replying) {
        self.tweetTextView.text = [NSString stringWithFormat:@"@%@", self.inReplyTo.user.screenName];
    } else {
        self.tweetTextView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textColor == [UIColor lightGrayColor]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tweetButton:(id)sender {
    if (!self.replying) {
        [[APIManager shared] postStatusWithText:self.tweetTextView.text completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully composed tweet!");
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }];
    } else {
        [[APIManager shared] postStatusAsReply:self.tweetTextView.text inReplyTo:self.inReplyTo completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully composed tweet!");
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
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

@end

//
//  SocialViewController.h
//  SocialDemo
//
//  Created by Cygnus Infomedia on 11/18/14.
//  Copyright (c) 2014 cygnusinfomedia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LINKEDIN_CLIENT_KEY @"781uwf0retox5k"
#define LINKEDIN_CLIENT_SECRET @"pn2LZHc4jg6XWNVO"

#define TWITTER_CLIENT_KEY @"Gu0LAGiLrrCVWSq8oQlGIS4Ox"
#define TWITTER_CLIENT_SECRET @"mSQuk3GNvM8MbyjWfPDOBzTHwqZSoiMcq1mpvPxsKKrJBcWzNU"

@interface SocialViewController : UIViewController<FBLoginViewDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIView *mainContainer;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfileView;
@property (weak, nonatomic) IBOutlet UILabel *fbHeader;
@property (weak, nonatomic) IBOutlet UILabel *fbNameLabel;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *fbLogoutButton;
- (IBAction)fbLoginClick:(id)sender;
- (IBAction)fbLogoutClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *twitterButtonLabel;
- (IBAction)twitterClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *twProfileView;
@property (weak, nonatomic) IBOutlet UIButton *twLogoutButton;
- (IBAction)twLogoutClick:(id)sender;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;


@property (weak, nonatomic) IBOutlet UIButton *linkedinLoginButton;
- (IBAction)linkedinLoginClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *linkedinLogoutButton;
- (IBAction)LinkedinLogoutClick:(id)sender;

@end

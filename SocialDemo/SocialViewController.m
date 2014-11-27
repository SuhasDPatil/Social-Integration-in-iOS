//
//  SocialViewController.m
//  SocialDemo
//
//  Created by Cygnus Infomedia on 11/18/14.
//  Copyright (c) 2014 cygnusinfomedia. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SocialViewController.h"
#import "SocialAppDelegate.h"
#import "STTwitter.h"

#import "AFLinkedInOAuth1Client.h"
#import "AFXMLRequestOperation.h"


@interface SocialViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end

@implementation SocialViewController
FBLoginView *fbLoginView;
CGSize size;
NSUserDefaults *UserDetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background3.png"]];
    [self.view insertSubview:backgroundView atIndex:0];
    
    UserDetails = [NSUserDefaults standardUserDefaults];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    /*FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];*/
    
    self.twLogoutButton.hidden=YES;
    self.fbProfileView.hidden=YES;
    
    size = self.mainContainer.bounds.size;
    //NSInteger width = size.width;
    //NSInteger height = size.height;
    
    //NSLog(@"%ld",(long)width/2);
    //NSLog(@"%ld",(long)height/2);
    
    fbLoginView=[[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    fbLoginView.delegate = self;
    fbLoginView.frame = CGRectMake(1, 1, 0, 0);
    
    for (id obj in fbLoginView.subviews)
    {
        
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Log in with Facebook";
            loginLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16.0];
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.textAlignment = NSTextAlignmentLeft;
            //loginLabel.textColor=[UIColor colorWithRed: 78.0/255.0f green:113.0/255.0f blue:168.0/255.0f alpha:1.0];
            //loginLabel.backgroundColor=[UIColor colorWithRed: 78.0/255.0f green:113.0/255.0f blue:168.0/255.0f alpha:1.0];
            loginLabel.frame = CGRectMake(1, 1, 0, 0);
        }
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"fblogin.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        
        
    }
    
    fbLoginView.hidden=YES;
    [self.view addSubview:fbLoginView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    
    for (id obj in fbLoginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"fblogout.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Log out from Facebook";
            loginLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16.0];
            loginLabel.textAlignment = NSTextAlignmentCenter;
            //loginLabel.textAlignment = NSTextAlignmentLeft;
            //loginLabel.textColor=[UIColor colorWithRed: 78.0/255.0f green:113.0/255.0f blue:168.0/255.0f alpha:1.0];
            //loginLabel.backgroundColor=[UIColor colorWithRed: 78.0/255.0f green:113.0/255.0f blue:168.0/255.0f alpha:1.0];
            loginLabel.frame = CGRectMake(1, 1, 0, 0);
        }
    }
    fbLoginView.hidden=YES;
    [self.view addSubview:fbLoginView];
    
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    
    self.fbHeader.hidden=NO;
    self.fbHeader.text=@"My Facebook";
    self.fbNameLabel.hidden=NO;
    self.fbNameLabel.text = [NSString stringWithFormat:@"Welcome %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    self.fbProfileView.hidden=NO;
    self.fbProfileView.profileID = user.objectID;
    self.loggedInUser = user;
    self.fbLoginButton.hidden=YES;
    self.fbLogoutButton.hidden=NO;
    
    
    [self.twitterButtonLabel setEnabled:NO];
    self.twitterButtonLabel.userInteractionEnabled = NO;
    [self.linkedinLoginButton setEnabled:NO];
    self.linkedinLoginButton.userInteractionEnabled = NO;

}



- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.fbProfileView.profileID = nil;
    self.fbNameLabel.text = nil;
    self.loggedInUser = nil;
    
    self.fbHeader.hidden=YES;
    self.fbNameLabel.hidden=YES;
    self.fbProfileView.hidden=YES;
    
    [self.twitterButtonLabel setEnabled:YES];
    self.twitterButtonLabel.userInteractionEnabled = YES;
    [self.linkedinLoginButton setEnabled:YES];
    self.linkedinLoginButton.userInteractionEnabled = YES;
    
    
    /*if (FBSession.activeSession.isOpen)
        NSLog(@"logged in");
        else
            NSLog(@"not logged in");*/
    
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (IBAction)fbLoginClick:(id)sender {
    
    [fbLoginView.subviews[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}


- (IBAction)fbLogoutClick:(id)sender {
    
    [fbLoginView.subviews[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    self.fbProfileView.profileID = nil;
    self.fbNameLabel.text = nil;
    self.loggedInUser = nil;
    
    self.fbHeader.hidden=YES;
    self.fbNameLabel.hidden=YES;
    self.fbProfileView.hidden=YES;
    
    self.fbLoginButton.hidden=NO;
    self.fbLogoutButton.hidden=YES;
}


- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    // in case the user has just authenticated through WebViewVC
    [self dismissViewControllerAnimated:YES completion:^{

    }];
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        //NSLog(@"-- UserID: %@", userID);
        self.twitterButtonLabel.hidden=YES;
        self.twLogoutButton.hidden=NO;
        
        self.fbHeader.hidden=NO;
        self.fbHeader.text=@"My Twitter";
        self.fbHeader.textColor=[UIColor colorWithRed: 78.0/255.0f green:113.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        [self.twitter getUsersShowForUserID:userID orScreenName:screenName includeEntities:nil successBlock:^(NSDictionary *user) {
                        
            //NSLog(@"%@",user);
            
            NSString *fullName = [user objectForKey:@"name"];
            self.fbNameLabel.hidden=NO;
            self.fbNameLabel.text = fullName;
            
            [UserDetails setValue:fullName forKey:@"LoggedinAs"];
            [UserDetails setValue:userID forKey:@"twitterUserID"];
            [UserDetails setValue:screenName forKey:@"twitterUserName"];
            [UserDetails setValue:oauthToken forKey:@"twitteroauthToken"];
            [UserDetails setValue:oauthTokenSecret forKey:@"twitteroauthTokenSecret"];
            [UserDetails synchronize];
            
            [self.fbLoginButton setEnabled:NO];
            self.fbLoginButton.userInteractionEnabled = NO;
            [self.linkedinLoginButton setEnabled:NO];
            self.linkedinLoginButton.userInteractionEnabled = NO;
            
        }errorBlock:^(NSError *error) {
            
            //self.fbNameLabel.text = [error localizedDescription];
            NSLog(@"-- %@", [error localizedDescription]);
        }];
        
        
        
        [_twitter profileImageFor:screenName successBlock:^(id image) {
            
            //NSLog(@"Image: %@",image);
            
            self.twProfileView.hidden=NO;
            [_twProfileView setImage:image];
            //code
         } errorBlock:^(NSError *error) {
            
            //self.fbNameLabel.text = [error localizedDescription];
            NSLog(@"-- %@", [error localizedDescription]);
         }];
        
        /*
         At this point, the user can use the API and you can read his access tokens with:
         
         _twitter.oauthAccessToken;
         _twitter.oauthAccessTokenSecret;
         
         You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
         
         Next time, just instanciate STTwitter with the class method:
         
         +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
         
         Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
         */
        
    } errorBlock:^(NSError *error) {
        
        self.fbNameLabel.text = [error localizedDescription];
        NSLog(@"-- %@", [error localizedDescription]);
    }];
    
}


- (IBAction)twitterClick:(id)sender {
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CLIENT_KEY
                                                 consumerSecret:TWITTER_CLIENT_SECRET];
    
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        //NSLog(@"-- url: %@", url);
       // NSLog(@"-- oauthToken: %@", oauthToken);
        
        
        [[UIApplication sharedApplication] openURL:url];
        
    } authenticateInsteadOfAuthorize:NO
                    forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:@"myapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                        self.fbNameLabel.text = [error localizedDescription];
                    }];
    
    
}


- (IBAction)twLogoutClick:(id)sender {

    NSString *actionSheetTitle =[@"Logged in as " stringByAppendingString:[UserDetails stringForKey:@"LoggedinAs"]]; //Action Sheet Title
    //NSString *destructiveTitle = @"Cancel"; //Action Sheet Button Titles
    NSString *Logout = @"Log Out";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheetTwitter = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:Logout, nil];
    actionSheetTwitter.tag = 1;
    
    [actionSheetTwitter showInView:self.view];
}


- (IBAction)linkedinLoginClick:(id)sender {
    
    
    AFLinkedInOAuth1Client *oauthClient = [[AFLinkedInOAuth1Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.linkedin.com/"]
                                                                                      key:LINKEDIN_CLIENT_KEY
                                                                                   secret:LINKEDIN_CLIENT_SECRET];
    
    [oauthClient authorizeUsingOAuthWithRequestTokenPath:@"uas/oauth/requestToken"
                                   userAuthorizationPath:@"uas/oauth/authorize"
                                             callbackURL:[NSURL URLWithString:@"linkedintest://success"]
                                         accessTokenPath:@"uas/oauth/accessToken"
                                            accessMethod:@"POST"
                                                   scope:nil
                                                 success:^(AFOAuth1Token *accessToken, id responseObject) {
                                                     
                                                     [oauthClient getPath:@"v1/people/~:(id,email-address,pictureUrl,formatted-name)" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                         
                                                         //NSLog(@"JSON RESPONSE: %@", responseObject);
                                                         //NSLog(@"Access Token: %@", accessToken.key);
                                                         //NSLog(@"Access Secret: %@", accessToken.secret);
                                                         
                                                         
                                                         self.linkedinLoginButton.hidden=YES;
                                                         self.linkedinLogoutButton.hidden=NO;
                                                         
                                                         self.fbHeader.hidden=NO;
                                                         self.fbHeader.text=@"My LinkedIn";
                                                         self.fbHeader.textColor=[UIColor colorWithRed: 78.0/255.0f green:113.0/255.0f blue:168.0/255.0f alpha:1.0];
                                                         
                                                         self.fbNameLabel.hidden=NO;
                                                         NSString *FullName = [responseObject objectForKey:@"formattedName"];
                                                         self.fbNameLabel.text=FullName;
                                                         
                                                         self.twProfileView.hidden=NO;
                                                         NSString *linkedInProfileUrl=[responseObject objectForKey:@"pictureUrl"];
                                                         NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:linkedInProfileUrl]];
                                                         self.twProfileView.image = [UIImage imageWithData:imageData];
                                                         
                                                         NSString *linkedinID = [responseObject objectForKey:@"id"];
                                                         NSString *linkedinUser = [responseObject objectForKey:@"emailAddress"];
                                                         
                                                         [UserDetails setValue:FullName forKey:@"LoggedinAs"];
                                                         [UserDetails setValue:linkedinID forKey:@"linkedinUserID"];
                                                         [UserDetails setValue:linkedinUser forKey:@"linkedinUserName"];
                                                         [UserDetails setValue:accessToken.key forKey:@"linkedinoauthToken"];
                                                         [UserDetails setValue:accessToken.secret forKey:@"linkedinoauthTokenSecret"];
                                                         [UserDetails synchronize];
                                                         
                                                         [self.fbLoginButton setEnabled:NO];
                                                         self.fbLoginButton.userInteractionEnabled = NO;
                                                         [self.twitterButtonLabel setEnabled:NO];
                                                         self.twitterButtonLabel.userInteractionEnabled = NO;
                                                         
                                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                         NSLog(@"ERROR: %@", error);
                                                     }];
                                                     
                                                     
                                                 } failure:^(NSError *error) {
                                                     NSLog(@"Error: %@", error);
                                                 }];
    
    
}

- (IBAction)LinkedinLogoutClick:(id)sender {
    

    NSString *actionSheetTitle =[@"Logged in as " stringByAppendingString:[UserDetails stringForKey:@"LoggedinAs"]]; //Action Sheet Title
    //NSString *destructiveTitle = @"Cancel"; //Action Sheet Button Titles
    NSString *Logout = @"Log Out";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheetLinkedIn = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:Logout, nil];
     actionSheetLinkedIn.tag = 2;
    
    [actionSheetLinkedIn showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==1)
    {
        if (buttonIndex == 0)
        {
            self.twProfileView.hidden=YES;
            self.fbHeader.text=@"";
            self.fbHeader.hidden=YES;
            self.fbNameLabel.hidden=YES;
            self.fbNameLabel.text = @"";
            self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:nil
                                                         consumerSecret:nil];
            
            [UserDetails setValue:@"" forKey:@"LoggedinAs"];
            [UserDetails setValue:@"" forKey:@"twitterUserID"];
            [UserDetails setValue:@"" forKey:@"twitterUserName"];
            [UserDetails setValue:@"" forKey:@"twitteroauthToken"];
            [UserDetails setValue:@"" forKey:@"twitteroauthTokenSecret"];
            [UserDetails synchronize];
            
            self.twLogoutButton.hidden=YES;
            self.twitterButtonLabel.hidden=NO;
            
            [self.fbLoginButton setEnabled:YES];
            self.fbLoginButton.userInteractionEnabled = YES;
            [self.linkedinLoginButton setEnabled:YES];
            self.linkedinLoginButton.userInteractionEnabled = YES;
            
            [self.view setNeedsDisplay];
        }
        
        if (buttonIndex == 1)
        {
            //Cancel
            //NSLog(@"%ld",(long)buttonIndex);
        }
    }
    
    else if(actionSheet.tag==2)
    {
        if (buttonIndex == 0)
        {
            self.linkedinLoginButton.hidden=NO;
            self.linkedinLogoutButton.hidden=YES;
            
            self.fbHeader.hidden=YES;
            self.fbHeader.text=@"";
            
            self.fbNameLabel.hidden=YES;
            self.twProfileView.image=nil;
            self.twProfileView.hidden=YES;
            
            [UserDetails setValue:@"" forKey:@"LoggedinAs"];
            [UserDetails setValue:@"" forKey:@"linkedinUserID"];
            [UserDetails setValue:@"" forKey:@"linkedinUserName"];
            [UserDetails setValue:@"" forKey:@"linkedinoauthToken"];
            [UserDetails setValue:@"" forKey:@"linkedinoauthTokenSecret"];
            [UserDetails synchronize];
            
            [self.fbLoginButton setEnabled:YES];
            self.fbLoginButton.userInteractionEnabled = YES;
            [self.twitterButtonLabel setEnabled:YES];
            self.twitterButtonLabel.userInteractionEnabled = YES;
            [self.view setNeedsDisplay];
        }
        
        if (buttonIndex == 1)
        {
            //Cancel
            //NSLog(@"%ld",(long)buttonIndex);
            
        }
    }
    
    
    
}

@end

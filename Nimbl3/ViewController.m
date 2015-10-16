//
//  ViewController.m
//  Nimbl3
//
//  Created by NICOLAS DEMOGUE on 15/10/2015.
//  Copyright © 2015 NICOLAS DEMOGUE. All rights reserved.
//

#import "ViewController.h"
#import "takeTheSurveyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[networkSingleton sharedNetwork] setDelegate:self];
    [self loadRefreshDataSurveys];
    
    // Rotate pageController
    myPageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    // Set color and shape button Take the survey
    myButtonSurvey.layer.cornerRadius 	= myButtonSurvey.frame.size.height / 2;
    myButtonSurvey.layer.borderWidth 	= 1;
    myButtonSurvey.layer.backgroundColor= [UIColor colorWithRed:189.f/255.f green:9.f/255.f blue:35.f/255.f alpha:1.f].CGColor;
    myButtonSurvey.layer.borderColor 	= [UIColor colorWithRed:189.f/255.f green:9.f/255.f blue:35.f/255.f alpha:1.f].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- REFRESH / LOAD DATA --
-(void)loadRefreshDataSurveys
{
    // Reset scrollView position & contents
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    NSArray* subviews = [[NSArray alloc] initWithArray:myScrollView.subviews];
    for (UIView* view in subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    myScrollView.hidden = myPageControl.hidden	= YES;
    
    myTitleSurvey.hidden = myDescriptionSurvey.hidden = myButtonSurvey.hidden = YES;
    
    [myActivityIndicator startAnimating];
    [[networkSingleton sharedNetwork] openURL];
}

#pragma mark -- SET SURVEY DATA --
-(void)setDataForSurvey:(int)pos
{
    surveysData	*survey 		= [[[networkSingleton sharedNetwork] jsonSurveys] objectAtIndex:pos];
    myTitleSurvey.text			= survey.titleSurvey;
    myDescriptionSurvey.text 	= survey.descriptionSurvey;
    myPageControl.currentPage	= pos;

    [self fadeIn:myTitleSurvey];
    [self fadeIn:myDescriptionSurvey];
    [self fadeIn:myButtonSurvey];
}

-(void)fadeIn:(id)sender
{
    // Fade in effect
    [UIView animateWithDuration:0.5f animations:^{
        [sender setAlpha:1.0f];
    }
    completion:^(BOOL finished)
    {
        
    }];
}

#pragma mark -- NETWORKCLIENT DELEGATE --
-(void)isDownloaded:(networkSingleton*)network
{
    NSLog(@"load json ok");
    [myActivityIndicator stopAnimating];
    
    myScrollView.hidden  = myPageControl.hidden	= NO;
    myTitleSurvey.hidden = myDescriptionSurvey.hidden = myButtonSurvey.hidden = NO;
    
    CGRect mainFrame 			= self.view.frame;
    
    // Update pageController count & size
    NSArray *tempSurveys 		= [[networkSingleton sharedNetwork] jsonSurveys];
    int countSurvey 			= [tempSurveys count];
    myPageControl.numberOfPages = countSurvey;
    myPageControl.currentPage 	= 0;
    currentPageSurvey			= 0;
    
    [self setDataForSurvey:currentPageSurvey];

    // Populate scrollView
    for (int nbSurvey = 0;nbSurvey < countSurvey;nbSurvey ++)
    {
        CGRect imageViewFrame 	= CGRectMake(mainFrame.origin.x + (nbSurvey * mainFrame.size.width),
                                             mainFrame.origin.y,
                                             mainFrame.size.width,
                                             mainFrame.size.height-44);
        UIImageView *imageView 	= [[UIImageView alloc] initWithFrame:imageViewFrame];
        imageView.contentMode 	= UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        imageView.tag			= nbSurvey;

        if ([[tempSurveys objectAtIndex:nbSurvey] backgroundSurvey] != nil)
        {
	        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[tempSurveys objectAtIndex:nbSurvey] backgroundSurvey]]]];
                        
                if(image)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageView *tempImageView 	= (UIImageView *)[myScrollView viewWithTag:nbSurvey];
                        tempImageView.image 		= image;
                    });
                }
            });
        }
        [myScrollView addSubview:imageView];
        myScrollView.contentSize = CGSizeMake(mainFrame.size.width * countSurvey,
                                              mainFrame.size.height - 44);
        myScrollView.delegate 	 = self;
    }
}

-(void)isError:(networkSingleton*)network error:(NSError*)error
{
    [myActivityIndicator stopAnimating];

    myDescriptionSurvey.hidden 		= NO;
    myDescriptionSurvey.text		= @"Error";
    myDescriptionSurvey.textColor	= [UIColor whiteColor];
}

#pragma mark -- SCROLLVIEW DELEGATE --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float myAlpha = fabs(scrollView.contentOffset.x - (currentPageSurvey * scrollView.frame.size.width));
    myAlpha *= 180.f / scrollView.frame.size.width;
    myTitleSurvey.alpha = myDescriptionSurvey.alpha = myButtonSurvey.alpha = cos(myAlpha * M_PI / 180.0f);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page != currentPageSurvey)
    {
        currentPageSurvey = page;
	    [self setDataForSurvey:currentPageSurvey];
    }
}

#pragma mark	-- IBACTION --
-(IBAction)takeTheSurveys:(id)sender
{
    NSLog(@"Take the survey :%@", [[[[networkSingleton sharedNetwork] jsonSurveys] objectAtIndex:currentPageSurvey] titleSurvey]);
    takeTheSurveyViewController *vc = [takeTheSurveyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)refreshSurveys:(id)sender
{
    [self loadRefreshDataSurveys];
}

@end

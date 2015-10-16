//
//  ViewController.h
//  Nimbl3
//
//  Created by NICOLAS DEMOGUE on 15/10/2015.
//  Copyright © 2015 NICOLAS DEMOGUE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "networkSingleton.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, networkSingletonDelegate>
{
    IBOutlet		UIActivityIndicatorView	*myActivityIndicator;
    
	IBOutlet		UIScrollView			*myScrollView;
	IBOutlet 		UIPageControl			*myPageControl;

    IBOutlet		UILabel					*myTitleSurvey;
    IBOutlet		UILabel					*myDescriptionSurvey;
    IBOutlet		UIButton				*myButtonSurvey;
    
    int				currentPageSurvey;
}

-(IBAction)takeTheSurveys:(id)sender;
-(IBAction)refreshSurveys:(id)sender;

@end


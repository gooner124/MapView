//
//  WebPageViewController.h
//  MapView2
//
//  Created by Matthew Paravati on 1/28/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebPageViewController : UIViewController <WKNavigationDelegate>

@property (nonatomic, strong) NSString *annotationURl;

@end

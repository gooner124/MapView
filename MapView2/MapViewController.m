//
//  ViewController.m
//  MapView2
//
//  Created by Matthew Paravati on 1/27/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "MapViewController.h"
#import "DataAccessObject.h"
#import "WebPageViewController.h"

@class WebPageViewController;

@interface MapViewController () {
    
}

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, retain)IBOutlet MKMapView *mapView;
@property(nonatomic, strong) MKPointAnnotation *turnToTechAnnotation;
@property(nonatomic, strong) MKAnnotationView *turnToTechAnnotationView;
@property(nonatomic, strong) WebPageViewController *webPageViewController;

@end

@implementation MapViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    return self;
}

#pragma mark - Set Different type of map
-(IBAction)setMap:(id)sender
{
    [[DataAccessObject sharedDAO] setMap:sender mapView:self.mapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mapView.showsUserLocation = YES;
    [self addTTTAnnotationToMap];
    self.turnToTechAnnotationView = [self mapView:self.mapView
                                viewForAnnotation:self.turnToTechAnnotation];
    [self addRestaurantPins];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Update user location
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark add TTT annotation
-(void)addTTTAnnotationToMap {
    
    self.turnToTechAnnotation = [[DataAccessObject sharedDAO] addTTTAnnotationToMap:self.mapView];
    
}

#pragma mark set up annotation views
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    return [[DataAccessObject sharedDAO] mapView:mapView viewForAnnotation:annotation];
}

#pragma mark add Restaurant pins
-(void)addRestaurantPins {
    NSMutableArray *restaurantPins = [[DataAccessObject sharedDAO] restaurantPins];
    [self.mapView addAnnotations:restaurantPins];

}

#pragma mark call web view controller

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
     self.webPageViewController = [[WebPageViewController alloc] initWithNibName:@"WebPageViewController" bundle:nil];
    
    self.webPageViewController.title = view.annotation.title;
    NSString *title = view.annotation.title;
    if ([title isEqualToString:@"TurnToTech"]) {
       self.webPageViewController.annotationURl = @"http://turntotech.io/";
        
    } else if ([title isEqualToString:@"Birreria"]) {
        self.webPageViewController.annotationURl = @"https://www.eataly.com/us_en/stores/new-york/nyc-la-birreria/";

    } else if ([title isEqualToString:@"Indikitch"]) {
        self.webPageViewController.annotationURl = @"http://indikitch.com/";
        
    } else {
        self.webPageViewController.annotationURl = @"https://www.seamless.com/menu/eisenbergs-sandwich-shop-inc-174-5th-ave-new-york-/292071";

    }
    
    [self.navigationController pushViewController:self.webPageViewController animated:YES];
}

@end

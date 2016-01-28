//
//  ViewController.m
//  MapView2
//
//  Created by Matthew Paravati on 1/27/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "MapViewController.h"
#import "DataAccessObject.h"

@interface MapViewController () {
    
}

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic, strong) MKPointAnnotation *turnToTechAnnotation;
@property(nonatomic, strong) MKAnnotationView *turnToTechAnnotationView;
@property(nonatomic, strong) MKAnnotationView *restaurantAnnotationView;

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


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
}

-(void)addTTTAnnotationToMap {
    
    self.turnToTechAnnotation = [[DataAccessObject sharedDAO] addTTTAnnotationToMap:self.mapView];
    
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    return [[DataAccessObject sharedDAO] mapView:mapView viewForAnnotation:annotation];
}

-(void)addRestaurantPins {
    NSMutableArray *restaurantPins = [[DataAccessObject sharedDAO] restaurantPins];
    MKAnnotationView *annotationView = [MKAnnotationView new];
    [self.mapView addAnnotations:restaurantPins];
    for (MKPointAnnotation *pointAnnotation in restaurantPins) {
        annotationView = [self mapView:self.mapView
                     viewForAnnotation:pointAnnotation];
    }

}

@end

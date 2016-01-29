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
@property(nonatomic, strong) NSMutableArray *mapItems;
@property(nonatomic, strong) NSMutableArray *restaurantSearchPins;
@property(nonatomic, strong) NSMutableArray *localSearchArray;

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
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search";
    self.navigationItem.titleView = searchBar;
    
    self.mapView.showsUserLocation = YES;
    [self addTTTAnnotationToMap];
    self.turnToTechAnnotationView = [self mapView:self.mapView
                                viewForAnnotation:self.turnToTechAnnotation];
    [self addRestaurantPins];
    [self createRestaurantSearch];
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
    NSURL *url;
    if ([title isEqualToString:@"TurnToTech"]) {
        url = [[NSURL alloc] initWithString:@"http://turntotech.io/"];
        self.webPageViewController.annotationURl =  url;
        
    } else if ([title isEqualToString:@"Birreria"]) {
        url = [[NSURL alloc] initWithString:@"https://www.eataly.com/us_en/stores/new-york/nyc-la-birreria/"];
        self.webPageViewController.annotationURl = url;

    } else if ([title isEqualToString:@"Indikitch"]) {
        url = [[NSURL alloc] initWithString:@"http://indikitch.com/"];
        self.webPageViewController.annotationURl = url;
        
    } else if([title isEqualToString:@"Eisenberg's Sandwich Shop"]){
        url = [[NSURL alloc] initWithString:@"https://www.seamless.com/menu/eisenbergs-sandwich-shop-inc-174-5th-ave-new-york-/292071"];
        self.webPageViewController.annotationURl = url;

    }else {
        for (MKMapItem *item in self.mapItems) {
            if ([item.name isEqualToString:view.annotation.title]) {
                self.webPageViewController.annotationURl = item.url;
            }
        }
    }
    
    [self.navigationController pushViewController:self.webPageViewController animated:YES];
}

#pragma mark use MKLocalSearch 

-(void)createRestaurantSearch {
    // Create and initialize a search request object.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Restaurant";
    request.region = self.mapView.region;
    
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
    {
        NSMutableArray *placemarks = [NSMutableArray array];
        self.mapItems = [[NSMutableArray alloc] init];
        if (!error) {
            for (MKMapItem *item in response.mapItems) {
                [placemarks addObject:item.placemark];
                [self.mapItems addObject:item];
            }
        } else {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Network Connection" message:@"Sorry, no network connection." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        self.restaurantSearchPins = [[NSMutableArray alloc] init];
        self.restaurantSearchPins = [[DataAccessObject sharedDAO] addLocalSearchRestaurants:self.mapItems];
        [self.mapView setRegion:response.boundingRegion];
        [self.mapView showAnnotations:self.restaurantSearchPins animated:NO];
    }];
}

#pragma mark Search button clicked
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    NSMutableArray *mapItems = [NSMutableArray new];
    self.localSearchArray = [NSMutableArray new];
    
    // Create and initialize a search request object.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    request.region = self.mapView.region;
    
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         if (!error) {
             for (MKMapItem *item in response.mapItems) {
                 [mapItems addObject:item];
             }
         } else {
             NSLog(@"Search Request Error: %@", [error localizedDescription]);
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Network Connection" message:@"Sorry, no network connection." preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
             [alertController addAction:actionOk];
             [self presentViewController:alertController animated:YES completion:nil];
         }
         
         
         self.localSearchArray = [[NSMutableArray alloc] initWithArray:
                                  [[DataAccessObject sharedDAO] addLocalSearchRestaurants:mapItems]];
         
         [self.mapView setRegion:response.boundingRegion];
         [self.mapView showAnnotations:self.localSearchArray animated:NO];
     }];
    
}

#pragma mark Cancel button clicked
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

#pragma mark should begin editing text
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES];
    return YES;
}

#pragma mark should end editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {
        [searchBar setShowsCancelButton:NO];
        return YES;
    } else {
        return NO;
    }
}

@end




















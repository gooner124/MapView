//
//  DataAccessObject.m
//  MapView2
//
//  Created by Matthew Paravati on 1/28/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "DataAccessObject.h"
#import "MapViewController.h"

@interface DataAccessObject () {
    
}

@property (nonatomic, strong) NSMutableArray *restaurantSearchPins;

@end

@implementation DataAccessObject

+ (id)sharedDAO {
    static DataAccessObject *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}

#pragma mark Create Pin Annotation Views
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    UIImage *image = [UIImage new];
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Try to dequeue an existing pin view first.
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView
                                                          dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotationView"];
    
    if (!pinView){
        
        // If an existing pin view was not available, create one.
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:@"PinAnnotationView"];
        
        pinView.pinTintColor = [UIColor redColor];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:
                                     CGRectMake(0, 0, pinView.frame.size.height, pinView.frame.size.height)];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:
                                CGRectMake(0, 0, pinView.frame.size.height, pinView.frame.size.height)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [viewLeftAccessory addSubview:imageView];
        
        pinView.leftCalloutAccessoryView=viewLeftAccessory;
        
        if ([[annotation title] isEqualToString:@"TurnToTech"]) {
            imageView.image = [UIImage imageNamed:@"turntotech.png"];
            pinView.leftCalloutAccessoryView = imageView;
        }else if ([[annotation title] isEqualToString:@"Birreria"]){
            imageView.image = [UIImage imageNamed:@"birerria.jpeg"];
            pinView.leftCalloutAccessoryView = imageView;
        }else if ([[annotation title] isEqualToString:@"Indikitch"]) {
            imageView.image = [UIImage imageNamed:@"indikitch.jpg"];
            pinView.leftCalloutAccessoryView = imageView;
        }else if([[annotation title] isEqualToString:@"Eisenberg's Sandwich Shop"]){
            imageView.image = [UIImage imageNamed:@"eisenbergs.jpg"];
            pinView.leftCalloutAccessoryView = imageView;
        }else {
            imageView.image = [UIImage imageNamed:@"default_logo.jpeg"];
            pinView.leftCalloutAccessoryView = imageView;
        }
        
        // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //[rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
    }
    else {
        pinView.annotation = annotation;
        
    }
    
    return pinView;

}

#pragma mark Add the TTT Pin
-(MKPointAnnotation *)addTTTAnnotationToMap:(MKMapView *)mapView {
    
    CLLocationCoordinate2D turnToTechCoord = CLLocationCoordinate2DMake(40.741454, -73.989898);
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    
    pointAnnotation.coordinate = turnToTechCoord;
    pointAnnotation.title = @"TurnToTech";
    pointAnnotation.subtitle = @"Mobile Development Bootcamp";
    [mapView addAnnotation:pointAnnotation];
    
    NSLog(@"Location: %f, %f",
          pointAnnotation.coordinate.latitude,
          pointAnnotation.coordinate.longitude);
    
    MKCoordinateRegion TTTRegion = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 250, 250);
    [mapView setRegion:TTTRegion animated:YES];
    
    return pointAnnotation;
}

#pragma mark Set the type of map
-(void)setMap:(id)sender mapView:(MKMapView *)mapView {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

#pragma mark add hard coded restaurant pins

-(NSMutableArray *) restaurantPins {
    NSMutableArray *restaurantPins = [NSMutableArray new];
    
    CLLocationCoordinate2D birreriaCoord = CLLocationCoordinate2DMake(40.741938, -73.989957);
    MKPointAnnotation *birreriaAnnotation = [MKPointAnnotation new];
    birreriaAnnotation.coordinate = birreriaCoord;
    birreriaAnnotation.title = @"Birreria";
    birreriaAnnotation.subtitle = @"Refined Italian gastropub with a view";
    
    CLLocationCoordinate2D indikitchCoord = CLLocationCoordinate2DMake(40.742166, -73.990475);
    MKPointAnnotation *indikitchAnnotation = [MKPointAnnotation new];
    indikitchAnnotation.coordinate = indikitchCoord;
    indikitchAnnotation.title = @"Indikitch";
    indikitchAnnotation.subtitle = @"Simple Indian fast-food eatery";
    
    CLLocationCoordinate2D eisenbergsCoord = CLLocationCoordinate2DMake(40.741102, -73.990132);
    MKPointAnnotation *eisenbergsAnnotation = [MKPointAnnotation new];
    eisenbergsAnnotation.coordinate = eisenbergsCoord;
    eisenbergsAnnotation.title = @"Eisenberg's Sandwich Shop";
    eisenbergsAnnotation.subtitle = @"Casual stalwart, open since 1929";
    
    [restaurantPins addObject:birreriaAnnotation];
    [restaurantPins addObject:indikitchAnnotation];
    [restaurantPins addObject:eisenbergsAnnotation];
    
    return restaurantPins;
}

#pragma mark add mklocalsearch restaurants
-(NSMutableArray *) addLocalSearchRestaurants:(NSMutableArray *) mapItems {

    self.restaurantSearchPins = [[NSMutableArray alloc] init];
    for (MKMapItem *item in mapItems) {
        MKPointAnnotation *restaurantPin = [MKPointAnnotation new];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(item.placemark.coordinate.latitude,
                                                                  item.placemark.coordinate.longitude);
        restaurantPin.coordinate = coordinates;
        restaurantPin.title = item.name;
        restaurantPin.subtitle = item.phoneNumber;
        [self.restaurantSearchPins addObject:restaurantPin];

    }
    
    return self.restaurantSearchPins;
}

#pragma mark create local search from search bar entry
-(NSMutableArray *) localSearch:(NSMutableArray *)searchArray {
    NSMutableArray * mapItems = [[NSMutableArray alloc] init];
    for (MKMapItem *item in searchArray) {
        MKPointAnnotation *searchPin = [MKPointAnnotation new];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(item.placemark.coordinate.latitude,
                                                                        item.placemark.coordinate.longitude);
        searchPin.coordinate = coordinates;
        searchPin.title = item.name;
        searchPin.subtitle = item.phoneNumber;
        [mapItems addObject:searchPin];
    }
        
    


    return mapItems;
}

@end











//
//  DataAccessObject.m
//  MapView2
//
//  Created by Matthew Paravati on 1/28/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "DataAccessObject.h"


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

@end

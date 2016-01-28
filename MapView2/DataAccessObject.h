//
//  DataAccessObject.h
//  MapView2
//
//  Created by Matthew Paravati on 1/28/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataAccessObject : NSObject

//Create singleton for DAO
+ (id)sharedDAO;
//Set up annotation views for the map
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;
//create and add TTT point annotation to the map
-(MKPointAnnotation *)addTTTAnnotationToMap:(MKMapView *)mapView;
//Set different type of map
-(void)setMap:(id)sender mapView:(MKMapView *)mapView;
@end

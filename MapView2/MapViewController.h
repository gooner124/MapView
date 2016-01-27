//
//  ViewController.h
//  MapView2
//
//  Created by Matthew Paravati on 1/27/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,retain)IBOutlet MKMapView *mapView;


#pragma mark - IBAction method
-(IBAction)setMap:(id)sender;


@end


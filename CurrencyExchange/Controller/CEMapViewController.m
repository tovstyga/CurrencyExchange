//
//  CEMapViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/17/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@implementation CEMapViewController {
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currency.latitude
                                                            longitude:self.currency.longitude
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.currency.latitude, self.currency.longitude);
    marker.title = self.currency.departamentName;
    marker.snippet = self.currency.departamentAdress;
    marker.map = mapView_;
}

@end

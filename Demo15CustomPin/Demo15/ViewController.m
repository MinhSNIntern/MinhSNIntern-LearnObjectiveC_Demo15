//
//  ViewController.m
//  Demo15
//
//  Created by vfa on 8/25/22.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnotation.h"

@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,strong) CLGeocoder *geocoder1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *address = @"224A Điện Biên Phủ, Phường 6, Quận 3, Thành phố Hồ Chí Minh, Việt Nam";
    
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:10.78198 longitude:106.68862];
    
    
    
    
    
    self.geocoder = [[CLGeocoder alloc] init];
    self.geocoder1 = [[CLGeocoder alloc] init];
    
    //convert location to meaningful address
    [self.geocoder1 reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil && placemarks.count > 0){
            CLPlacemark *placemark = placemarks[0];
            NSLog(@"Country = %@",placemark.country);
            NSLog(@"Postal Code = %@", placemark.postalCode);
            NSLog(@"Locality = %@",placemark.locality);
        }else if(error != nil || placemarks.count == 0){
            NSLog(@"No result");
        }else{
            NSLog(@"Error: %@",error);
        }
    }];
//    //convert address to location
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count >0 && error == nil){
            NSLog(@"Found %lu placemarks",placemarks.count);
            CLPlacemark *firstPlacemark = placemarks[0];

            NSLog(@"placemark(s) longitude = %f",firstPlacemark.location.coordinate.longitude);
            NSLog(@"placemark(s) latitude = %f",firstPlacemark.location.coordinate.latitude);
        }else if(placemarks.count == 0 && error == nil){
            NSLog(@"Not found any placemark");
        } else{

            NSLog(@"Error: %@", error);
        }
    }];
    
    self.view.backgroundColor = UIColor.whiteColor;

    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];

    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];

    //display pins on map
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(10.782045, 106.686431);
    
    MyAnotation *anotation = [[MyAnotation alloc] initWithCoordinates:location title:@"My Title" subTitle:@"My Sub Title"];
    
    anotation.color = MKPinAnnotationColorPurple;
    
    [self.mapView addAnnotation:anotation];
    
    if([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }else{
        
        NSLog(@"Location services are not enabled");
    }
    
   
    [self performSelector:@selector(direction) withObject:nil afterDelay:10.0];
    
    
    // Do any additional setup after loading the view.
}

-(void) direction{
    MKDirectionsRequest *directionRequest = [[MKDirectionsRequest alloc] init];
    directionRequest.source = [MKMapItem mapItemForCurrentLocation];
    
    CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake(+37.78666117, -122.40963578);
    MKPlacemark *destination = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate];
    directionRequest.destination = [[MKMapItem alloc] initWithPlacemark:destination];
    
    directionRequest.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *direction = [[MKDirections alloc] initWithRequest:directionRequest];
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        [MKMapItem openMapsWithItems:@[response.source,response.destination] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    }];
    
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Could not get the user's location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurants";
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    request.region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        for (MKMapItem *item in response.mapItems) {
//            NSLog(@"Item name: %@", item.name);
//            NSLog(@"Item phone number: %@",item.phoneNumber);
//            NSLog(@"Item url: %@",item.url);
//            NSLog(@"Item location: %@",item.placemark.location);
            
            CLLocationCoordinate2D searchLocation = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);
            
            MyAnotation *seachAnnotation = [[MyAnotation alloc] initWithCoordinates:searchLocation title:item.name subTitle:item.phoneNumber];
            
            [self.mapView addAnnotation:seachAnnotation];
        }
    }];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *result = nil;
    
    if([annotation isKindOfClass:[MyAnotation class]]==NO){
        return result;
    }
    
    if([mapView isEqual:self.mapView] == NO){
    
        return result;}
    
    MyAnotation *senderAnnotation = (MyAnotation *)annotation;
    
    NSString *pinReusableIdentifier = [MyAnotation reusableIdentifierforPinColor:senderAnnotation.color];
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    
    if(annotationView ==nil){
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIdentifier];
        [annotationView setCanShowCallout:YES];
    }
    
    UIImage *pinImage = [UIImage imageNamed:@"pinImage"];
    if(pinImage != nil){
        
        annotationView.image = pinImage;
    }
    annotationView.frame = CGRectMake(0, 0, 30, 40);
    annotationView.contentMode = UIViewContentModeScaleAspectFit;
    result = annotationView;
    
    return  result;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = [locations lastObject];
    if(newLocation.horizontalAccuracy >0){
        
       // [self.locationManager stopUpdatingLocation];
    NSLog(@"lattitude = %f",newLocation.coordinate.latitude);
        NSLog(@"longitude =.%f",newLocation.coordinate.longitude);
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}
@end

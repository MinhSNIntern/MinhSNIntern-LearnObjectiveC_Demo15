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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;

    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];

    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

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
    
    // Do any additional setup after loading the view.
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
    annotationView.pinColor = senderAnnotation.color;
    
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

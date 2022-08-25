//
//  MyAnotation.m
//  Demo15
//
//  Created by vfa on 8/25/22.
//

#import "MyAnotation.h"
NSString *const kReusablePinRed = @"Red";
NSString *const kReusablePinGreen = @"Green";
NSString *const kReusablePinPurple = @"Purple";
@implementation MyAnotation

+(NSString *) reusableIdentifierforPinColor:(MKPinAnnotationColor) color{
    
    NSString *result = nil;
    
    switch (color) {
        case MKPinAnnotationColorRed:
            result = kReusablePinRed;
            break;
        case MKPinAnnotationColorGreen:
            result = kReusablePinGreen;
            break;
        case MKPinAnnotationColorPurple:
            result = kReusablePinPurple;
            break;
        default:
            break;
    }
    return  result;
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinates title:(NSString *)title subTitle:(NSString *)subTitle{
    self = [super init];
    
    if(self != nil){
        _coordinate = coordinates;
        _title = title;
        _subTitle = subTitle;
        _color = MKPinAnnotationColorGreen;
    }
    return self;
}
@end

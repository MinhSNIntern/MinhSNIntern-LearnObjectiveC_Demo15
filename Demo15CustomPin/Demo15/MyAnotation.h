//
//  MyAnotation.h
//  Demo15
//
//  Created by vfa on 8/25/22.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyAnotation : NSObject<MKAnnotation>
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy,readonly) NSString *title;
@property (nonatomic,copy,readonly) NSString *subTitle;
@property (nonatomic,unsafe_unretained) MKPinAnnotationColor color;
+(NSString *) reusableIdentifierforPinColor:(MKPinAnnotationColor) color;
-(instancetype) initWithCoordinates:(CLLocationCoordinate2D) coordinates
                      title:(NSString *) title subTitle:(NSString *) subTitle;
@end

NS_ASSUME_NONNULL_END

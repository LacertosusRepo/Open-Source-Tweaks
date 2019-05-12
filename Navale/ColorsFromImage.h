@interface Color : NSObject
@property int r, g, b, d;
@end

@interface ColorsFromImage : NSObject
+(id)sharedInstance;
-(id)init;
-(NSDictionary *)colorsFromImage:(UIImage *)image fromEdge:(int)edge;
-(float)contrastValueFor:(Color *)a andB:(Color *)b;
-(float)colorDistance:(Color *)a andB:(Color *)b;
@end

#import "ColorsFromImage.h"

  /*
   * Credit goes to Johnny Rockex
   * https://stackoverflow.com/questions/15962893/determine-primary-and-secondary-colors-of-a-uiimage
   */

@implementation Color
@end

@implementation ColorsFromImage
+(id)sharedInstance {
  static ColorsFromImage *sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

-(id)init {
  if(self = [super init]) {
    NSLog(@"ColorsFromImage || Initalized");
  }
  return self;
}

-(NSDictionary *)colorsFromImage:(UIImage *)image fromEdge:(int)edge {
  float dimension = 20;

  CGImageRef imageRef = [image CGImage];
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  unsigned char *rawData = (unsigned char*) calloc(dimension * dimension * 4, sizeof(unsigned char));
  NSUInteger bytesPerPixel = 4;
  NSUInteger bytesPerRow = bytesPerPixel * dimension;
  NSUInteger bitsPerComponent = 8;
  CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);

  NSMutableArray *colors = [NSMutableArray new];
  float x = 0, y = 0;
  float eR = 0, eG = 0, eB = 0;
  for(int n = 0; n<(dimension * dimension); n++) {
    Color *c = [Color new];
    int i = (bytesPerRow * y) + x * bytesPerPixel;
    c.r = rawData[i];
    c.g = rawData[i +1];
    c.b = rawData[i +2];
    [colors addObject:c];

    if((edge == 0 && y == 0) || (edge == 1 && x ==0) || (edge = 2 && y == dimension-1) || (edge = 3 && dimension-1)) {
      eR += c.r;
      eG += c.g;
      eB += c.b;
    }

    x = (x == dimension -1) ? 0 : x+1;
    y = (x == 0) ? y+1 : y;
  }
  free(rawData);

  Color *e = [Color new];
  e.r = eR/dimension;
  e.g = eG/dimension;
  e.b = eB/dimension;

  NSMutableArray *accents = [NSMutableArray new];

  float minContrast = 1.1;
  while(accents.count < 3) {
    for(Color *a in colors) {
      if([self contrastValueFor:a andB:e] < minContrast) {
        continue;
      }

      for(Color *b in colors) {
        a.d += [self contrastValueFor:a andB:b];
      }

      [accents addObject:a];
    }

    minContrast -= 0.1f;
  }

  NSArray *sorted = [[NSArray arrayWithArray:accents] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"d" ascending:YES]]];

  Color *p = sorted[0];
  float high = 0.0;
  int index = 0;
  for(int n = 1; n < sorted.count; n++) {
    Color *c = sorted[n];
    float contrast = [self contrastValueFor:c andB:p];

    if(contrast > high) {
      high = contrast;
      index = n;
    }
  }

  Color *s = sorted[index];
  NSMutableDictionary *result = [NSMutableDictionary new];
  [result setValue:[UIColor colorWithRed:e.r/255.0f green:e.g/255.0f blue:e.b/255.0f alpha:1.0f] forKey:@"background"];
  [result setValue:[UIColor colorWithRed:p.r/255.0f green:p.g/255.0f blue:p.b/255.0f alpha:1.0f] forKey:@"primary"];
  [result setValue:[UIColor colorWithRed:s.r/255.0f green:s.g/255.0f blue:s.b/255.0f alpha:1.0f] forKey:@"secondary"];

  return result;
}

-(float)contrastValueFor:(Color *)a andB:(Color *)b {
  float aL = 0.2126 * a.r + 0.7152 * a.g + 0.0722 * a.b;
  float bL = 0.2126 * b.r + 0.7152 * b.g + 0.0722 * b.b;
  return (aL > bL) ? (aL + 0.05) / (bL + 0.05) : (bL + 0.05) / (aL + 0.05);
}

-(float)colorDistance:(Color *)a andB:(Color *)b {
  return abs(a.r - b.r) + abs(a.g - b.g) + abs(a.b - b.b);
}
@end

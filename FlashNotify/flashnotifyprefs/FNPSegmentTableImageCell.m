#import "FNPSegmentTableImageCell.h"

@implementation FNPSegmentTableImageCell
  -(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    NSArray *values = [specifier performSelector:@selector(values)];
    NSDictionary *titles = [specifier titleDictionary];
    for(id value in values) {
      UIImage *image = [[UIImage imageWithContentsOfFile:titles[value]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      if(image) {
        [(UISegmentControl *)self.control setImage:image forSegmentAtIndex:[values indexOfObject:value]];
      } else {
        [(UISegmentControl *)self.control setTitle:@"No Image Found" forSegmentAtIndex:[values indexOfObject:value]];
      }
    }
  }
@end

#import "FNPSegmentTableImageCell.h"

@implementation FNPSegmentTableImageCell {
  NSBundle *_bundle;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
      [specifier setProperty:@60 forKey:@"height"];

      _bundle = [specifier.target bundle];
    }

    return self;
  }

  -(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    NSArray *values = [specifier performSelector:@selector(values)];
    NSDictionary *titles = [specifier titleDictionary];
    for(id value in values) {
      UIImage *image = [[UIImage imageNamed:titles[value] inBundle:_bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      if(image) {
        [(UISegmentControl *)self.control setImage:image forSegmentAtIndex:[values indexOfObject:value]];
      } else {
        [(UISegmentControl *)self.control setTitle:@"No Image Found" forSegmentAtIndex:[values indexOfObject:value]];
      }
    }
  }
@end

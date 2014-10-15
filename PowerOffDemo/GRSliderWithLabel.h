//
//  GRSliderWithLabel.h
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/14/14.
//
//

#import "GRSlider.h"

//  http://stackoverflow.com/a/5710097/202064
@interface UILabel (FSHighlightAnimationAdditions)
- (void)setTextWithChangeAnimation:(NSString*)text;
@end


@interface GRSliderWithLabel : GRSlider
@property(nonatomic, strong) UILabel *textLabel;
@end

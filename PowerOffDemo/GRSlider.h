//
//  GRSlider.h
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/14/14.
//
//

#import <UIKit/UIKit.h>

@interface GRSlider : UIControl
@property(nonatomic, strong) UIImageView *backgroundImageView;
@property(nonatomic, strong) UISlider *slider;
- (CGRect)thumbRect;
- (CGFloat)value;
@end

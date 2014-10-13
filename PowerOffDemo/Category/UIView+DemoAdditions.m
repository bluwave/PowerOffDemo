//
//  UIView+DemoAdditions.m
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/13/14.
//
//

#import "UIView+DemoAdditions.h"


@implementation UIView (DemoAdditions)

-(void) debugBorder
{
    self.layer.borderColor = UIColor.redColor.CGColor;
    self.layer.borderWidth = 1.0;
}

- (NSArray *)addVflContrstraints:(NSString *)vfl {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        NSDictionary *bindings = @{@"self" : self, @"superview" : self.superview};
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}


@end

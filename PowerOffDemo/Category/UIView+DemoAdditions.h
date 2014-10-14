//
//  UIView+DemoAdditions.h
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/13/14.
//
//

#import <UIKit/UIKit.h>


@interface UIView (DemoAdditions)

-(void) debugBorder;
- (NSArray *)addVflContrstraints:(NSString *)vfl;
- (NSArray *)pinViewToAllSidesOfSuperView;
@end

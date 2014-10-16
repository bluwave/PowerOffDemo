//
//  ViewController.m
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/13/14.
//
//

#import "ViewController.h"
#import "UIView+DemoAdditions.h"
#import "GRSlider.h"
#import "GRSliderWithLabel.h"

static const CGFloat kRadius = 60.0;
static const CGFloat kSliderPad = 15.0;
static const CGFloat kMargin =  50.0;
static const CGFloat kSliderVerticalOffsetFromTop = 100.0;

@interface ViewController ()
@property(nonatomic, strong) IBOutlet UIImageView *bgImage;
@property(nonatomic, strong) UIView *blurredOverlay;
@property(nonatomic, strong) UIView *darkOverlay;
@property(nonatomic, strong) GRSliderWithLabel *slider;
@property(nonatomic, strong) IBOutlet UIView *cancelButtonContainer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSlider];
    [self configureDarkOverlay];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark - CONFIGURE
- (void)configureBgImageInSliderWithRect:(CGRect)dstRect {
    UIImage *lgImg = [self snapshotOfView:self.bgImage WithScale:1];
    UIImage *img = [self imageWithImage:lgImg cropInRect:dstRect];
    self.slider.backgroundImageView.image = img;
}

- (void)configureSlider {
    self.slider = [[GRSliderWithLabel alloc] initWithFrame:CGRectMake(kMargin, kSliderVerticalOffsetFromTop, kRadius + kSliderPad, kRadius + kSliderPad)];
    [self.slider addTarget:self action:@selector(actionValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider setHidden:YES];
    [self.view addSubview:self.slider];
}

- (void)configureDarkOverlay {
    self.darkOverlay = [[UIView alloc] initWithFrame:CGRectZero];
    self.darkOverlay.backgroundColor = UIColor.blackColor;
    self.darkOverlay.alpha = 0;
    [self.darkOverlay setUserInteractionEnabled:NO];
    [self.view addSubview:self.darkOverlay];
    [self.darkOverlay addVflContrstraints:@"H:|[self]|"];
    [self.darkOverlay addVflContrstraints:@"V:|[self]|"];
}

#pragma mark - ACTIONS

- (IBAction)actionPoweroff:(id)sender {
    [self toggleBlurOverlay:YES withCompletionHandler:^{
        [self.slider setHidden:NO];
        CGRect dstRect = CGRectMake(kMargin, kSliderVerticalOffsetFromTop, self.view.bounds.size.width - (2 * kMargin), kRadius + kSliderPad);
        [self configureBgImageInSliderWithRect:(CGRect) {0, dstRect.origin.y, dstRect.size}];
        [self animateSliderToRect:dstRect WithCompletionHandler:nil];
        [self.cancelButtonContainer setHidden:NO];
        [self.view bringSubviewToFront:self.cancelButtonContainer];
        [self.view bringSubviewToFront:self.darkOverlay];
    }];
}

- (void)actionValueChanged:(GRSlider *)sender {
    [self toggleDarkOverlayWithAlpha:self.slider.value];
}

- (IBAction)actionCancel:(id)sender {
    [self.slider setHidden:YES];
    [self.cancelButtonContainer setHidden:YES];
    //  FIXME: duplicate code here on the frame
    [self.slider setFrame:CGRectMake(kMargin, kSliderVerticalOffsetFromTop, kRadius + kSliderPad, kRadius + kSliderPad)];
    [self toggleBlurOverlay:NO withCompletionHandler:nil];
}

#pragma mark - HELPERS

- (void)animateSliderToRect:(CGRect)dstRect WithCompletionHandler:(void (^)())handler {
    //  FIXME - this needs some cleanup / refinement
    [UIView animateWithDuration:0.35 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.slider.frame = dstRect;
    } completion:^(BOOL finished) {
        [self.slider.textLabel setTextWithChangeAnimation:@"hello world"];
        if (handler) handler();
    }];
}

- (void)toggleDarkOverlayWithAlpha:(CGFloat)alpha {
    if (alpha < 0.75)
        self.darkOverlay.alpha = alpha;
}

- (void)toggleBlurOverlay:(BOOL)show withCompletionHandler:(void (^)())completionHandler {
    if (show) {
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle: UIBlurEffectStyleDark];
        self.blurredOverlay = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.blurredOverlay.alpha = 0;
        [self.view insertSubview:self.blurredOverlay belowSubview:self.slider];
        [self.blurredOverlay addVflContrstraints:@"H:|[self]|"];
        [self.blurredOverlay addVflContrstraints:@"V:|[self]|"];

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.blurredOverlay.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (completionHandler)
                completionHandler();
        }];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            self.blurredOverlay.alpha = 0;
        } completion:^(BOOL finished) {
            [self.blurredOverlay removeFromSuperview];
            if (completionHandler)
                completionHandler();
        }];
    }
}

- (UIImage *)snapshotOfView:(UIView *)view WithScale:(CGFloat)scale {
    UIImage *snapshot = nil;
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, scale);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return snapshot;
}

- (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect {
    NSParameterAssert(image != nil);
    if (CGPointEqualToPoint(CGPointZero, rect.origin) && CGSizeEqualToSize(rect.size, image.size)) {
        return image;
    }

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    [image drawAtPoint:(CGPoint){-rect.origin.x, -rect.origin.y}];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

@end

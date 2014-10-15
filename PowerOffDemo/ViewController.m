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
static const CGFloat kMargin = 20.0;
static const CGFloat kSliderVerticalOffsetFromTop = 100.0;

@interface ViewController ()
@property(nonatomic, strong) IBOutlet UIImageView *bgImage;
@property(nonatomic, strong) UIView *blurredOverlay;
@property(nonatomic, strong) UIView *sliderContainer;
@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UIImageView *sliderImage;
@property(nonatomic, strong) UIView *darkOverlay;
@property(nonatomic, strong) GRSliderWithLabel *grSlider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSliderContainer];
    [self configureSlider];
    [self configureDarkOverlay];

    [self configureGRSlider];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIView *v in self.slider.subviews) {
        if ([v isKindOfClass:[UIImageView class]])
            self.sliderImage = (UIImageView *) v;
    }
    [self toggleBlurOverlay:YES withCompletionHandler:nil];

    __weak __typeof__(self) weakself = self;
    [self animateSliderWithCompletionHandler:^{
        if(weakself) {
            UIImage * lgImg = [weakself snapshotOfView:self.bgImage WithScale:1];
            UIImage * img =  [weakself imageWithImage:lgImg cropInRect:weakself.grSlider.frame];
            weakself.grSlider.backgroundImageView.image = img;
        }
    }];


}

#pragma mark - CONFIGURE

- (void)configureGRSlider {
    GRSliderWithLabel * s = [[GRSliderWithLabel alloc] initWithFrame:CGRectMake(kMargin, 240, kRadius+kSliderPad, kRadius + kSliderPad)];
    self.grSlider = s;

//    s.backgroundImageView.image =

//    self.grSlider = [[GRSlider alloc] initWithFrame:CGRectMake(kMargin, 240, kRadius+kSliderPad, kRadius + kSliderPad)];
    [self.view addSubview:self.grSlider];
}

- (void)configureSliderContainer {
    //  FIXME - need to grab lighter blur from background
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    self.sliderContainer.frame = CGRectMake(kMargin, kSliderVerticalOffsetFromTop, self.view.bounds.size.width - (2 * kMargin), kRadius + kSliderPad);
    self.sliderContainer = [[UIImageView alloc] initWithImage:self.bgImage.image];
    self.sliderContainer.frame = CGRectMake(kMargin, kSliderVerticalOffsetFromTop, self.view.bounds.size.width - (2 * kMargin), kRadius + kSliderPad);
    [self.sliderContainer setContentMode:UIViewContentModeScaleAspectFill];
    [self.sliderContainer addSubview:blurEffectView];
    [blurEffectView addVflContrstraints:@"H:|[self]|"];
    [blurEffectView addVflContrstraints:@"V:|[self]|"];

//    self.sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kSliderVerticalOffsetFromTop, self.view.bounds.size.width - (2 * kMargin), kRadius + kSliderPad)];
//    [self.sliderContainer setBackgroundColor:[UIColor orangeColor]];
    self.sliderContainer.layer.cornerRadius = (kRadius + kSliderPad) / 2;
    [self.sliderContainer.layer setMasksToBounds:YES];
    [self.view addSubview:self.sliderContainer];
}

- (void)configureSlider {
    UISlider *slider = self.slider = [[UISlider alloc] initWithFrame:CGRectMake(kMargin + (kSliderPad / 2), kSliderVerticalOffsetFromTop + kSliderPad / 2, (self.view.bounds.size.width - (2 * kMargin)) - kSliderPad, kRadius)];
    [slider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setValue:0];
    [slider setContinuous:YES];
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(slidingDidFinish:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(slidingStarted:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:slider];
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

- (void)valueChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    [self toggleDarkOverlayWithAlpha:slider.value];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [slider setValue:slider.value animated:NO];
    } completion:nil];
    [self syncScrollViewLeftSideToSlider];

}

- (void)slidingDidFinish:(id)sender {
    UISlider *slider = (UISlider *) sender;
    NSUInteger index = (NSUInteger) (slider.value + 0.25);
    [UIView animateWithDuration:0.27 delay:0.03 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [slider setValue:index animated:YES];
        [self syncScrollViewLeftSideToSlider];
        [self toggleDarkOverlayWithAlpha:self.slider.value];
    } completion:^(BOOL finished) {
        [self toggleDarkOverlayWithAlpha:self.slider.value];
    }];

}

- (void)slidingStarted:(id)sender {

}

- (void)syncScrollViewLeftSideToSlider {
    CGRect r = [self.view convertRect:self.sliderImage.frame fromView:self.sliderImage.superview];
    CGRect f = self.sliderContainer.frame;
    f.origin.x = r.origin.x - (kSliderPad / 2);
    f.size.width = (self.view.bounds.size.width - kMargin) - f.origin.x;
    self.sliderContainer.frame = f;
}

#pragma mark - HELPERS

- (void)animateSliderWithCompletionHandler:(void(^)()) handler {
    //  FIXME - this needs some cleanup / refinement
    CGRect dstRect = CGRectMake(kMargin, 240, self.view.bounds.size.width - (2 * kMargin), kRadius + kSliderPad);
    [UIView animateWithDuration:0.35 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.grSlider.frame = dstRect;
    } completion:^(BOOL finished) {
        [self.grSlider.textLabel setTextWithChangeAnimation:@"hello world"];
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
        [self.view insertSubview:self.blurredOverlay belowSubview:self.sliderContainer];
        [self.blurredOverlay addVflContrstraints:@"H:|[self]|"];
        [self.blurredOverlay addVflContrstraints:@"V:|[self]|"];

        [UIView animateWithDuration:0.2 animations:^{
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

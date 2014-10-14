//
//  ViewController.m
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/13/14.
//
//

#import "ViewController.h"
#import "UIView+DemoAdditions.h"

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


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSliderContainer];
    [self configureSlider];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIView *v in self.slider.subviews) {
        if ([v isKindOfClass:[UIImageView class]])
            self.sliderImage = (UIImageView *) v;
    }
}


#pragma mark - CONFIGURE
- (void)configureSliderContainer {
    self.sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kSliderVerticalOffsetFromTop, self.view.bounds.size.width - (2 * kMargin), kRadius + kSliderPad)];
    [self.sliderContainer setBackgroundColor:[UIColor orangeColor]];
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
    [slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:slider];
}



#pragma mark - ACTIONS

- (void)valueChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [slider setValue:slider.value animated:NO];
    } completion:nil];
    [self syncScrollViewLeftSideToSlider];

}

- (void)sliderUp:(id)sender {
    UISlider *slider = (UISlider *) sender;
    NSUInteger index = (NSUInteger) (slider.value + 0.25);
    [UIView animateWithDuration:0.27 delay:0.03 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [slider setValue:index animated:YES];
        [self syncScrollViewLeftSideToSlider];
    } completion:^(BOOL finished) {

    }];

}

- (void)syncScrollViewLeftSideToSlider {

    CGRect r = [self.view convertRect:self.sliderImage.frame fromView:self.sliderImage.superview];

//    NSLog(@"%s x: %f", __func__, r.origin.x);
    CGRect f =  self.sliderContainer.frame;
    f.origin.x = r.origin.x - (kSliderPad/2);
    f.size.width = (self.view.bounds.size.width-kMargin)-f.origin.x;
//
////    NSLog(@"%s f: %@", __func__, NSStringFromCGRect(f));
    self.sliderContainer.frame = f;
}

- (IBAction)actionPowerOff:(id)sender {
    [self toggleOverlay:YES withCompletionHandler:nil];
}

#pragma mark - HELPERS
- (void)toggleOverlay:(BOOL)show withCompletionHandler:(void (^)())completionHandler {
    if (show) {

        UIBlurEffect * blur = [UIBlurEffect effectWithStyle: UIBlurEffectStyleDark];
        self.blurredOverlay = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.blurredOverlay.alpha = 0;
        [self.view addSubview:self.blurredOverlay];
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
@end

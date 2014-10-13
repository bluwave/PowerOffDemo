//
//  ViewController.m
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/13/14.
//
//

#import "ViewController.h"
#import "UIView+DemoAdditions.h"

@interface ViewController ()
@property(nonatomic, strong) IBOutlet UIImageView *bgImage;
@property(nonatomic, strong) UIView *blurredOverlay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bgImage debugBorder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)actionPowerOff:(id)sender {
    [self toggleOverlay:YES withCompletionHandler:nil];
}

- (void)toggleOverlay:(BOOL)show withCompletionHandler:(void (^)())completionHandler {
    if (show) {
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle: UIBlurEffectStyleDark];
        self.blurredOverlay = [[UIVisualEffectView alloc] initWithEffect:blur];
        [self.view addSubview:self.blurredOverlay];
        self.blurredOverlay.alpha = 0;
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

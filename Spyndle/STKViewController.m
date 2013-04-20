//
//  STKViewController.m
//  Spyndle
//
//  Created by Joe Conway on 4/19/13.
//

#import "STKViewController.h"
#import "STKSpinnerView.h"

@interface STKViewController ()

@property (weak, nonatomic) IBOutlet STKSpinnerView *spinnerView;

@end

@implementation STKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self spinnerView] setImage:[UIImage imageNamed:@"jc.png"]];

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(spinit:) userInfo:nil repeats:YES];

}
- (void)spinit:(NSTimer *)timer
{
    static float prog = 0.0;
    prog += 0.03;
    if(prog >= 1.0) {
        prog = 1.0;
        [timer invalidate];
    }
    [[self spinnerView] setProgress:prog animated:YES];
}

@end

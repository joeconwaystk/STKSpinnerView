//
//  STKSpinnerView.h
//  Spyndle
//
//  Created by Joe Conway on 4/19/13.
//

#import <UIKit/UIKit.h>

@interface STKSpinnerView : UIView

@property (nonatomic) float progress;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) float wellThickness;
@property (nonatomic, strong) UIColor *color;

- (void)setProgress:(float)progress animated:(BOOL)animated;


@end

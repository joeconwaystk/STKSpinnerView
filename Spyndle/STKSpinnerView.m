//
//  STKSpinnerView.m
//  Spyndle
//
//  Created by Joe Conway on 4/19/13.
//

#import "STKSpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@interface STKSpinnerView ()
@property (nonatomic, assign) CALayer *imageLayer;
@property (nonatomic, assign) CALayer *maskLayer;
@property (nonatomic, assign) CAShapeLayer *wellLayer;
@property (nonatomic, assign) CAShapeLayer *spinLayer;
@end

@implementation STKSpinnerView
@dynamic image;

- (void)_commonInit
{
    CALayer *l = [CALayer layer];
    [[self layer] addSublayer:l];
    [self setImageLayer:l];
    
    CALayer *m = [CALayer layer];
    [[self imageLayer] setMask:m];
    [self setMaskLayer:m];
    
    CAShapeLayer *w = [CAShapeLayer layer];
    [[self layer] addSublayer:w];
    [w setStrokeColor:[[UIColor grayColor] CGColor]];
    [w setFillColor:[[UIColor clearColor] CGColor]];
    [w setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [w setShadowRadius:2];
    [w setShadowOpacity:1];
    [w setShadowOffset:CGSizeZero];
    [self setWellLayer:w];

    CAShapeLayer *s = [CAShapeLayer layer];
    [s setStrokeColor:[[UIColor blueColor] CGColor]];
    [s setFillColor:[[UIColor clearColor] CGColor]];
    [[self layer] addSublayer:s];
    [self setSpinLayer:s];

    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setWellThickness:8.0];
    [self setColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:1]];
    [self setProgress:0.0];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    [[self imageLayer] setContents:(id)[image CGImage]];
}

- (UIImage *)image
{
    return [UIImage imageWithCGImage:(CGImageRef)[[self imageLayer] contents]];
}

- (void)setWellThickness:(float)wellThickness
{
    _wellThickness = wellThickness;
    [[self spinLayer] setLineWidth:_wellThickness];
    [[self wellLayer] setLineWidth:_wellThickness];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [[self spinLayer] setStrokeColor:[_color CGColor]];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    float currentProgress = _progress;
    _progress = progress;
    
    [CATransaction begin];
    if(animated) {
        float delta = fabs(_progress - currentProgress);
        [CATransaction setAnimationDuration:MAX(0.2, delta * 1.0)];
    } else {
        [CATransaction setDisableActions:YES];
    }
    [[self spinLayer] setStrokeEnd:_progress];
    [CATransaction commit];
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (float)radius
{
    CGRect r = CGRectInset([self bounds], [self wellThickness] / 2.0, [self wellThickness] / 2.0);
    float w = r.size.width;
    float h = r.size.height;
    if(w > h)
        return h / 2.0;
    
    return w / 2.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    float wt = [self wellThickness];
    CGRect outer = CGRectInset([self bounds], wt / 2.0, wt / 2.0);
    CGRect inner = CGRectInset([self bounds], wt, wt);
    
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:inner];
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer))
                                                             radius:[self radius]
                                                         startAngle:-M_PI_2 endAngle:(2.0 * M_PI - M_PI_2) clockwise:YES];
    [[self wellLayer] setPath:[outerPath CGPath]];
    [[self spinLayer] setPath:[outerPath CGPath]];
        
    [[self imageLayer] setFrame:bounds];
    [[self maskLayer] setFrame:bounds];
    [[self spinLayer] setFrame:bounds];

    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [[UIScreen mainScreen] scale]);
    [innerPath fill];
    [[self maskLayer] setContents:(id)[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    UIGraphicsEndImageContext();
}


@end

//
//  ViewController.m
//  ShoppingCar
//
//  Created by Apple on 2017/1/20.
//  Copyright © 2017年 XRH. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define UIColor(x,y,z,r) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:r]
#define UIImage(string) [UIImage imageNamed:string]

@interface ViewController ()<CAAnimationDelegate>

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) CALayer      *layer;
@property (strong, nonatomic) UILabel      *cntLabel;
@property (assign, nonatomic) NSInteger    cnt;
@property (strong, nonatomic) UIImageView  *imageView;
@property (strong, nonatomic) UIButton     *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cnt = 0;
    [self setViewUI];
}

- (void)setViewUI {
    [self initCntLabel];
    [self initButton];
    [self initImageView];
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }

    if (!_path) {
        _path = [UIBezierPath bezierPath];
        [_path moveToPoint:CGPointMake(50, 150)];
        [_path addQuadCurveToPoint:CGPointMake(270, 300) controlPoint:CGPointMake(150, 20)];
    }
}


- (void)initButton {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(59, SCREEN_HEIGHT * 0.7 , 100, 30);
        [_button setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_button setBackgroundImage:UIImage(@"ButtonRedLarge") forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
}


- (void)initImageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imageView.image = UIImage(@"TabCartSelected@2x.png");
        _imageView.center = CGPointMake(270, 320);
        [self.view addSubview:_imageView];
    }
}

- (void)initCntLabel {
    
    if (!_cntLabel) {
        _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 295, 20, 20)];
        _cntLabel.textColor = UIColor(237, 20, 91, 1.0f);
        _cntLabel.textAlignment = NSTextAlignmentCenter;
        _cntLabel.font = [UIFont boldSystemFontOfSize:13];
        _cntLabel.backgroundColor = [UIColor whiteColor];
        _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
        _cntLabel.layer.masksToBounds = YES;
        _cntLabel.layer.borderWidth = 1.0f;
        _cntLabel.layer.borderColor = UIColor(237, 20, 91, 1.0f).CGColor;
        [self.view addSubview:_cntLabel];
    }
}

- (void)startAnimation {
    if (!_layer) {
        _button.enabled = NO;
        _layer = [CALayer layer];
        _layer.contents = (__bridge id)[UIImage imageNamed:@"test01.jpg"].CGImage;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = CGRectMake(0, 0, 50, 50);
        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
        _layer.masksToBounds = YES;
        _layer.position =CGPointMake(50, 150);
        [self.view.layer addSublayer:_layer];
    }
    [self groupAnimation];
}

- (void)groupAnimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration  = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue   = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration  = 1.5f;
    narrowAnimation.toValue   = [NSNumber numberWithFloat:0.5f];
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    

    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration   = 2.0f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [self.layer addAnimation:groups forKey:@"group"];
}

#pragma mark -- CAAnimationGroupDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.layer animationForKey:@"group"]) {
        _button.enabled = YES;
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        _cnt++;
        if (_cnt) {
            _cntLabel.hidden = NO;
        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        self.cntLabel.text = [NSString stringWithFormat:@"%ld",(long)_cnt];
        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration  = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue   = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [_imageView.layer addAnimation:shakeAnimation forKey:nil];
    }
}

@end

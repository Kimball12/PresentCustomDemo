//
//  KBTranslation.m
//  PresentCustomDemo
//
//  Created by 韩金波 on 15/10/30.
//  Copyright © 2015年 Psylife. All rights reserved.
//

#import "KBTranslation.h"
#define kRotationAnimation @"RotationAnimation"
#define ScreenSize [UIScreen mainScreen].bounds.size
@implementation KBTranslation
{
    UIView *_btnView;
    CGRect _originRect;
    UIView *_animationView;
    
    id _context;
    UIView *_containerView;
    CGFloat _radius;
    CAShapeLayer *_shapeLayer;
    
}

-(instancetype)initWithView:(UIView *)btnview
{
    if (self=[super init]) {
        NSAssert(btnview, @"btnView 不能为空");
        _btnView=btnview;
        _originRect=btnview.frame;
    }
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
    
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _context=transitionContext;
    _containerView=[_context containerView];
    if (_reverse) {
        CGFloat size= MAX(ScreenSize.width, ScreenSize.height);
        CATransform3D fina3D=CATransform3DMakeScale((_btnView.frame.size.width/size)*1.4, (_btnView.frame.size.height/size) *1.4,1 );
        UIViewController *toVC=[_context viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.frame=[UIScreen mainScreen].bounds;
        toVC.view.alpha=0;
        _animationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(ScreenSize.width, ScreenSize.height)*1.8, MAX(ScreenSize.width, ScreenSize.height)*1.8)];
        _animationView.center=_btnView.center;
        _animationView.layer.cornerRadius=MAX(ScreenSize.width, ScreenSize.height)*0.9;
        _animationView.layer.masksToBounds=YES;
        
        [_containerView addSubview:toVC.view];
        
        [_containerView addSubview:_animationView];
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]*0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
             toVC.view.alpha = 1;
            _animationView.backgroundColor=_btnView.backgroundColor;
            _animationView.layer.transform=fina3D;
        }completion:^(BOOL finished){
             _animationView.layer.cornerRadius = 0;
        }];
        [UIView animateWithDuration:[self transitionDuration:transitionContext]*0.3 delay:[self transitionDuration:transitionContext]*0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _animationView.frame=_originRect;
        }completion:^(BOOL finishde){
            _btnView.hidden=NO;
            [_animationView removeFromSuperview];
            //[_containerView addSubview:toVC.view];
            [_context completeTransition:YES];
        }];
        
    }else{
        _animationView=[[UIView alloc] initWithFrame:_btnView.frame];
        _animationView.layer.cornerRadius=4;
        _animationView.backgroundColor=_btnView.backgroundColor;
        _btnView.hidden=YES;
        [_containerView addSubview:_animationView];
        
        CGPoint centerPoint=[_btnView center];
        _radius=MIN(_btnView.frame.size.width, _btnView.frame.size.height);
        [UIView animateWithDuration:[self transitionDuration:transitionContext]*0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
            _animationView.frame= CGRectMake(0, 0, _radius, _radius);
            _animationView.center=centerPoint;
            _animationView.layer.cornerRadius=_radius/2.0;
            
        }completion:^(BOOL Finished){
            UIBezierPath *path=[[UIBezierPath alloc] init];
            [path addArcWithCenter:CGPointMake(_radius/2.0, _radius/2.0) radius:(_radius/2.0-5) startAngle:0 endAngle:M_PI clockwise:YES];
            _shapeLayer=[[CAShapeLayer alloc] init];
            _shapeLayer.lineWidth=2;
            _shapeLayer.strokeColor=[UIColor whiteColor].CGColor;
            _shapeLayer.fillColor=_btnView.backgroundColor.CGColor;
            _shapeLayer.frame=CGRectMake(0, 0, _radius/2.0, _radius/2.0);
            _shapeLayer.path=path.CGPath;
            [_animationView.layer addSublayer:_shapeLayer];
            CABasicAnimation *baseAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            baseAnimation.duration=0.4;
            baseAnimation.fromValue=@(0);
            baseAnimation.toValue=@(2*M_PI);
            baseAnimation.repeatCount=MAXFLOAT;
            [_animationView.layer addAnimation:baseAnimation forKey:kRotationAnimation];
            
        }];
        
    }
}
-(void)stopAnimation
{
    UIViewController *toVC=[_context viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame=CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
    [_containerView addSubview:toVC.view];
    toVC.view.alpha=0;
    _animationView.layer.transform=CATransform3DIdentity;
            [_shapeLayer removeFromSuperlayer];
    [_animationView.layer removeAllAnimations];
    CGFloat size=MAX(toVC.view.frame.size.width,toVC.view.frame.size.height)*1.6;
    CATransform3D fina3D=CATransform3DMakeScale(size/_radius, size/_radius, 1);
    [UIView animateWithDuration:0.5 animations:^{
        _animationView.layer.transform=fina3D;
        toVC.view.alpha=1;
    }completion:^(BOOL finished){
        [_animationView removeFromSuperview];
        [_context completeTransition:YES];
    }];
}
@end

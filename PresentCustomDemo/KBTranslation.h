//
//  KBTranslation.h
//  PresentCustomDemo
//
//  Created by 韩金波 on 15/10/30.
//  Copyright © 2015年 Psylife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KBTranslation : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) BOOL reverse;
-(instancetype)initWithView:(UIView *)btnview;
-(void)stopAnimation;
@end

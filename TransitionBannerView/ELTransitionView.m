//
//  ELTransitionView.m
//  demo111
//
//  Created by 费宇超 on 2018/2/2.
//  Copyright © 2018年 费宇超. All rights reserved.
//

#import "ELTransitionView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNaviHeight ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height)

//比例 按照UI标注换算
#define iPhone4 (kScreenHeight == 480)
#define iPhone4_NOT (kScreenHeight != 480)
#define iPhone5 (kScreenHeight == 568)
#define iPhone6 (kScreenHeight == 667)
#define iPhone6Plus (kScreenHeight == 736)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kSizeWidth(_X_) (_X_ * (kScreenWidth/375.0))
#define kSizeHeight(_X_) (_X_ * (iPhone4_NOT*(kScreenHeight/667.0) + iPhone4*(568.0/667.0)))

#define  ToRad(ang)  ((M_PI *(ang)) / 180)//度数转化为弧度
#define  ToAng(rad)  ( (180.0 * (rad)) / M_PI )//弧度转化为度数


@implementation ELTransitionView

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGMutablePathRef curvePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(curvePath, NULL, 60, 0);
    CGPathAddLineToPoint(curvePath, NULL, width-60, 0);
    CGPathAddQuadCurveToPoint(curvePath, NULL, width-10, height/2, width-60, height);
    CGPathAddLineToPoint(curvePath, NULL, 60, height);
    CGPathAddQuadCurveToPoint(curvePath, NULL,10, height/2, 60, 0);
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = curvePath;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.strokeColor = [UIColor clearColor].CGColor;
    maskLayer.frame = CGRectMake(0, 0, width, height);
    self.layer.mask = maskLayer;
    CGPathRelease(curvePath);
}

@end

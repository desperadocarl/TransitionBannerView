//
//  ELTransitionBannerView.h
//  demo111
//
//  Created by 费宇超 on 2018/2/2.
//  Copyright © 2018年 费宇超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELTransitionBannerView;
@protocol ELTransitionBannerViewDelegate <NSObject>

@optional
/**
 点击banner图片回调方法
 
 @param bannerView 当前banner视图
 @param index 点击的下标
 */
- (void)bannerView:(ELTransitionBannerView *)bannerView didClickAtIndex:(NSUInteger)index;

@end


@interface ELTransitionBannerView : UIView

/**
 pageControl的颜色
 */
@property (nonatomic, strong) UIColor * pageControlColor;

/**
 所有图片URLs
 */
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;

@property (nonatomic, weak) id<ELTransitionBannerViewDelegate> delegate;

/**
 自动滚动间隔，默认为5s
 */
@property (nonatomic, assign) NSTimeInterval rollInterval;

@property (nonatomic, strong) UIImage *placeholderImage;

- (void)elBannerStartRolling;
- (void)resetRolling;
- (void)elBannerStopRolling;
/**
 根据锚点摇摆起来吧
 */
- (void)shakeAim;

@end


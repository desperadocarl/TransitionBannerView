//
//  ELTransitionBannerView.m
//  demo111
//
//  Created by 费宇超 on 2018/2/2.
//  Copyright © 2018年 费宇超. All rights reserved.
//

#import "ELTransitionBannerView.h"
#import "ELTransitionView.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/UIImageView+WebCache.h>

//判断方向  区别于velocity瞬时速度的方向
typedef NS_ENUM(NSInteger, ELTransitionBannerViewDirection) {
    ELTransitionBannerViewDirectionUnknow,
    ELTransitionBannerViewDirectionLeft,
    ELTransitionBannerViewDirectionRight
};

@interface ELTransitionBannerView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView * vImageBottom;
@property (nonatomic, strong) UIView * vClipView;
@property (nonatomic, strong) UIImageView * vImageTop;
@property (nonatomic, strong) UIView * vMask;
@property (nonatomic, strong) ELTransitionView * vTransitionLeft;
@property (nonatomic, strong) ELTransitionView * vTransitionRight;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

/** 滚动方向 */
@property (nonatomic, assign) ELTransitionBannerViewDirection direction;
@property (nonatomic, assign) BOOL isResetDirection;
@property (nonatomic, assign) CGFloat firstPoint;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger TotalPage;
@property (nonatomic, strong) NSTimer *timer;

//配饰
@property (nonatomic, strong) UIImageView * vFragranceTop1;
@property (nonatomic, strong) UIImageView * vFragranceTop2;
@property (nonatomic, strong) UIImageView * vFragranceBottom;

//banner的高度不包括配饰
@property (nonatomic, assign) CGFloat bannerHeight;
@property (nonatomic, assign) CGFloat bannerWidth;


@end

@implementation ELTransitionBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bannerHeight = frame.size.height - 36;
        self.bannerWidth = frame.size.width - 10;
//        self.placeholderImage = [UIImage imageFromBundle:@"learning_background_placeholder"];
        [self setUI];
        [self setNotifications];
    }
    return self;
}


- (void)setNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(elBannerStartRolling) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(elBannerStopRolling) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUI{
    self.rollInterval = 5;
    self.isResetDirection = YES;
    
    [self addSubview:self.vClipView];
    [self.vClipView addSubview:self.vImageBottom];
    [self.vClipView addSubview:self.vImageTop];
    
    [self addSubview:self.vFragranceTop1];
    [self addSubview:self.vFragranceBottom];
    
    //把top的交互事件关闭 所有的pan和点击都交给下一个视图
    self.vImageTop.userInteractionEnabled = NO;
    self.vImageBottom.userInteractionEnabled = YES;
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPageView)];
    
    [self.vImageBottom addGestureRecognizer:self.panGesture];
    [self.vImageBottom addGestureRecognizer:self.tap];
    self.vImageTop.maskView = self.vMask;
}

#pragma mark - UIPanDelegate Methods
- (void)panOnBanner:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translatedPoint = [recognizer translationInView:self];
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        [self elBannerStopRolling];
        self.firstPoint = translatedPoint.x;
    }else if ([recognizer state] == UIGestureRecognizerStateChanged){
        [self elBannerStopRolling];
        if (self.isResetDirection == YES) {
            if (translatedPoint.x > self.firstPoint) {
                self.direction  = ELTransitionBannerViewDirectionRight;
                self.isResetDirection = NO;
            }else if (translatedPoint.x < self.firstPoint) {
                self.direction  = ELTransitionBannerViewDirectionLeft;
                self.isResetDirection = NO;
            }
        }else{
            //
        }
        switch (self.direction) {
            case ELTransitionBannerViewDirectionRight:
                
            {
                NSInteger LastPage;
                if (self.currentPage == 0) {
                    LastPage = self.TotalPage;
                }else{
                    LastPage = self.currentPage - 1;
                }
                [self.vImageTop  sd_setImageWithURL:[NSURL URLWithString:[self.imageURLs objectAtIndex:LastPage]] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        self.vImageTop.image = image;
                    }else{
                        self.vImageTop.image = self.placeholderImage;
                    }
                }];
                
            }
                if (fabs(translatedPoint.x)>10) {
                    CGRect rect = self.vImageBottom.frame;
                    rect.origin.x = fabs(translatedPoint.x/self.bannerWidth)*50;
                    self.vImageBottom.frame =rect;
                }
                self.vTransitionLeft.frame = CGRectMake(fabs(translatedPoint.x *1.3)+-self.bannerWidth-120, 0, self.bannerWidth + 120, self.bannerHeight);
                break;
            case ELTransitionBannerViewDirectionLeft:
                
            {
                NSInteger nextPage;
                if (self.currentPage == self.TotalPage) {
                    nextPage = 0;
                }else{
                    nextPage = self.currentPage + 1;
                }
                
                [self.vImageTop  sd_setImageWithURL:[NSURL URLWithString:[self.imageURLs objectAtIndex:nextPage]] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        self.vImageTop.image = image;
                    }else{
                        self.vImageTop.image = self.placeholderImage;
                    }
                }];
            }
                self.vTransitionRight.frame = CGRectMake(self.bannerWidth + translatedPoint.x *1.3, 0, self.bannerWidth + 120, self.bannerHeight);
                if (fabs(translatedPoint.x)>10) {
                    CGRect rect = self.vImageBottom.frame;
                    rect.origin.x = - fabs(translatedPoint.x/self.bannerWidth)*50;
                    self.vImageBottom.frame =rect;
                }
                
                break;
            default:
                break;
        }
    }else if ([recognizer state] == UIGestureRecognizerStateEnded){
        //偏移量不足翻页  根据速度判断是否要翻页
        if (fabs(translatedPoint.x-self.firstPoint) < self.bannerWidth/2) {
            CGPoint speed = [recognizer velocityInView:recognizer.view];
            if (fabs(speed.x) > 800) {
                switch (self.direction) {
                    case ELTransitionBannerViewDirectionLeft:
                    {
                        if (speed.x<0) {
                            [self TransitionTwoImageViewWithDirection:self.vTransitionRight WithInterVal:0.3];
                        }else{
                            [self resetMaskViewFrame];
                        }
                        
                    }
                        break;
                    case ELTransitionBannerViewDirectionRight:
                    {
                        if (speed.x>0) {
                            [self TransitionTwoImageViewWithDirection:self.vTransitionLeft WithInterVal:0.3];
                        }else{
                            [self resetMaskViewFrame];
                        }
                        
                        break;
                    }
                    default:
                        break;
                }
            }else{
                [self resetMaskViewFrame];
            }
        }else{
            if (self.direction == ELTransitionBannerViewDirectionRight) {
                [self TransitionTwoImageViewWithDirection:self.vTransitionLeft WithInterVal:0.5];
            }else if (self.direction == ELTransitionBannerViewDirectionLeft){
                [self TransitionTwoImageViewWithDirection:self.vTransitionRight WithInterVal:0.5];
            }
        }
        [self elBannerStartRolling];
        self.isResetDirection = YES;
        
    }else if ([recognizer state] == UIGestureRecognizerStateCancelled){
        
    }
}

- (void)tapPageView{
    if ([self.delegate respondsToSelector:@selector(bannerView:didClickAtIndex:)]) {
        [self.delegate bannerView:self didClickAtIndex:self.currentPage];
        NSLog(@"里面点击的是哪一个呢++%ld",(long)self.currentPage);
    }
}

#pragma mark -  Public Methods
- (void)elBannerStopRolling{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)resetRolling {
    [self elBannerStopRolling];
    [self elBannerStartRolling];
}

- (void)elBannerStartRolling{
    if (self.imageURLs.count <= 1) {
        return;
    }
    [self.timer setFireDate:[NSDate dateWithTimeInterval:self.rollInterval sinceDate:[NSDate date]]];
}

// 参数要细调
- (void)shakeAim{
    self.hidden = NO;
    self.alpha = 1;
}

#pragma mark - private Methods
- (void)prefetchImageWithURLs:(NSArray<NSString *> *)URLs {
    NSMutableArray<NSURL *> *marrURL = [NSMutableArray arrayWithCapacity:URLs.count];
    for (NSString *URLStr in URLs) {
        NSURL *slimURL = [NSURL URLWithString:URLStr];
        if (slimURL) {
            [marrURL addObject:slimURL];
        }
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:marrURL];
}


- (void)reloadData {
    // 预加载图片
    self.currentPage = 0;
    [self prefetchImageWithURLs:self.imageURLs];
    if (!self.superview) {
        return;
    }
    [self configureImages];
    [self configureTimer];
}

- (void)configureImages {
    [self.vImageBottom  sd_setImageWithURL:[NSURL URLWithString:self.imageURLs.firstObject] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.vImageBottom.image = image;
        }else{
            self.vImageBottom.image = self.placeholderImage;
        }
        
    }];
    
    if (self.imageURLs.count <= 1) {
        self.vImageTop.frame = CGRectZero;
    } else {
        [self.vImageTop  sd_setImageWithURL: [NSURL URLWithString:[self.imageURLs objectAtIndex:1]] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                self.vImageTop.image = image;
            }else{
                self.vImageTop.image = self.placeholderImage;
            }
        }];
    }
}

- (void)configureTimer {
    if (self.imageURLs.count <= 1) {
        [self elBannerStopRolling];
    } else {
        [self resetRolling];
    }
}

- (void)resetMaskViewFrame{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.vTransitionRight.frame = CGRectMake(self.frame.size.width,0, self.frame.size.width + 120, self.bannerHeight);
        self.vTransitionLeft.frame = CGRectMake(-self.frame.size.width-120, 0, self.frame.size.width+120, self.bannerHeight);
        self.vImageBottom.frame = CGRectMake(0, 0, self.bannerWidth,self.bannerHeight);
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)doRolling{
    [self TransitionTwoImageViewWithDirection:self.vTransitionRight WithInterVal:1];
}

- (void)TransitionTwoImageViewWithDirection:(ELTransitionView *)view WithInterVal:(NSTimeInterval )time{
    if ([view isEqual:self.vTransitionLeft]){
        NSInteger LastPage;
        if (self.currentPage == 0) {
            LastPage = self.TotalPage;
        }else{
            LastPage = self.currentPage - 1;
        }
        [self.vImageTop  sd_setImageWithURL:[NSURL URLWithString:[self.imageURLs objectAtIndex:LastPage]] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                self.vImageTop.image = image;
            }else{
                self.vImageTop.image = self.placeholderImage;
            }
        }];
    }else if ([view isEqual:self.vTransitionRight]) {
        NSInteger nextPage;
        if (self.currentPage == self.TotalPage) {
            nextPage = 0;
        }else{
            nextPage = self.currentPage + 1;
        }
        [self.vImageTop  sd_setImageWithURL:[NSURL URLWithString:[self.imageURLs objectAtIndex:nextPage]] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                self.vImageTop.image = image;
            }else{
                self.vImageTop.image = self.placeholderImage;
            }
        }];
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        if ([view isEqual:self.vTransitionRight]){
            CGRect rect = self.vImageBottom.frame;
            rect.origin.x = -50;
            self.vImageBottom.frame = rect;
        }else{
            CGRect rect = self.vImageBottom.frame;
            rect.origin.x = + 50;
            self.vImageBottom.frame = rect;
        }
        
        view.frame = CGRectMake(-60, 0, self.frame.size.width + 120, self.bannerHeight);
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        if ([view isEqual:self.vTransitionRight]) {
            view.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width+120, self.bannerHeight);
            if (self.currentPage == self.TotalPage) {
                self.currentPage = 0;
            }else{
                self.currentPage = self.currentPage + 1;
            }
        }else if ([view isEqual:self.vTransitionLeft]){
            if (self.currentPage == 0) {
                self.currentPage = self.TotalPage;
            }else{
                self.currentPage = self.currentPage - 1;
            }
            view.frame = CGRectMake(-self.frame.size.width-120, 0, self.frame.size.width+120, self.bannerHeight);
        }
        if (self.vImageTop.maskView) {
            //删除已经出现的视图的mask
            self.vImageTop.maskView = nil;
            [self.vImageTop.maskView removeFromSuperview];
            
            //交换指针 使得top永远叫top
            UIImageView * vTemp = self.vImageTop;
            self.vImageTop = self.vImageBottom;
            self.vImageBottom = vTemp;
            
            self.vImageTop.frame = CGRectMake(0, 0, self.bannerWidth, self.bannerHeight);
            //将下面的图移到上面来
            [self.vImageTop removeFromSuperview];
            [self.vClipView addSubview:self.vImageTop];
            
            //给上面的视图添加mask
            self.vImageTop.maskView = self.vMask;
            
            //把top的交互事件关闭 所有的pan和点击都交给下一个视图
            self.userInteractionEnabled = YES;
            self.vImageTop.userInteractionEnabled = NO;
            [self.vImageTop removeGestureRecognizer:self.panGesture];
            [self.vImageTop removeGestureRecognizer:self.tap];
            
            self.vImageBottom.userInteractionEnabled = YES;
            [self.vImageBottom addGestureRecognizer:self.panGesture];
            [self.vImageBottom addGestureRecognizer:self.tap];
            
            [self bringSubviewToFront:self.vFragranceBottom];
        }
    }];
}


#pragma mark - Setter Methods

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.rollInterval target:self selector:@selector(doRolling) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (UIImageView *)vImageBottom{
    if (!_vImageBottom) {
        _vImageBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bannerWidth, self.bannerHeight)];
//        _vImageBottom.image  = [UIImage imageFromBundle:@"learning_background_placeholder"];
        _vImageBottom.backgroundColor = [UIColor grayColor];
        _vImageBottom.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _vImageBottom;
}

- (UIImageView *)vImageTop{
    if (!_vImageTop) {
        _vImageTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bannerWidth, self.bannerHeight)];
//        _vImageTop.image  = [UIImage imageFromBundle:@"learning_background_placeholder"];
        _vImageTop.backgroundColor = [UIColor grayColor];
        _vImageTop.contentMode  = UIViewContentModeScaleAspectFill;
    }
    return _vImageTop;
}

- (UIImageView *)vFragranceTop1{
    if (!_vFragranceTop1) {
        _vFragranceTop1 = [[UIImageView alloc]initWithFrame:CGRectMake(-9, 0, self.frame.size.width + 18, 28+10+5)];
        _vFragranceTop1.contentMode = UIViewContentModeScaleAspectFit;
        _vFragranceTop1.image = [UIImage imageNamed:@"el_banner_Top"];
    }
    return _vFragranceTop1;
}


- (UIImageView *)vFragranceBottom{
    if (!_vFragranceBottom) {
        _vFragranceBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height -10, self.frame.size.width, 8)];
        _vFragranceBottom.contentMode = UIViewContentModeScaleToFill;
        _vFragranceBottom.image = [UIImage imageNamed:@"el_banner_Bottom"];
    }
    return _vFragranceBottom;
}

- (UIView *)vMask{
    if (!_vMask) {
        _vMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.bannerHeight)];
        [_vMask addSubview:self.vTransitionLeft];
        [_vMask addSubview:self.vTransitionRight];
    }
    return _vMask;
}

- (UIView *)vClipView{
    if (!_vClipView) {
        _vClipView = [[UIView alloc] initWithFrame:CGRectMake(5, 28, self.bannerWidth, self.bannerHeight)];
        _vClipView.clipsToBounds = YES;
        _vClipView.backgroundColor = [UIColor clearColor];
    }
    return _vClipView;
}


- (ELTransitionView *)vTransitionLeft{
    if (!_vTransitionLeft) {
        _vTransitionLeft = [[ELTransitionView alloc] initWithFrame:CGRectMake(-self.frame.size.width-120, 0, self.frame.size.width+120, self.bannerHeight)];
    }
    return _vTransitionLeft;
}

- (ELTransitionView *)vTransitionRight{
    if (!_vTransitionRight) {
        _vTransitionRight = [[ELTransitionView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width+120, self.bannerHeight)];
    }
    return _vTransitionRight;
}

- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnBanner:)];
        _panGesture.delegate = self;
        [_panGesture setMaximumNumberOfTouches:1];
        [_panGesture setDelaysTouchesBegan:YES];
        [_panGesture setDelaysTouchesEnded:YES];
        [_panGesture setCancelsTouchesInView:YES];
    }
    return _panGesture;
}

- (void)setImageURLs:(NSArray<NSString *> *)imageURLs {
    if (imageURLs.count > 1) {
        self.TotalPage = imageURLs.count - 1;
        _imageURLs = [imageURLs copy];
        [self reloadData];
    }else if (imageURLs.count == 0 || imageURLs.count == 1){
        _imageURLs = [imageURLs copy];
        [self.vImageBottom removeGestureRecognizer:self.panGesture];
        [self reloadData];
    }
}

@end


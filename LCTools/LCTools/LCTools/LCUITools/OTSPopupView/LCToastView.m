//
//  LCToastView.m
//  OTSUITool
//
//  Created by Luca on 2019/3/13.
//  Copyright © 2019 Luca. All rights reserved.
//

#import "LCToastView.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger, LCToastStyle) {
    LCToastStyleNormal,//通用
    LCToastStyleTitle,//带标题
    LCToastStyleImage,//带图片
    LCToastStyleTitleAndImage,//标题和图片
};

#define LCRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define LCScreenW [UIScreen mainScreen].bounds.size.width
#define LCScreenH [UIScreen mainScreen].bounds.size.height

@interface LCToastView()
//类型
@property (nonatomic, assign) LCToastStyle style;
//位置
@property (nonatomic, assign) LCToastShowPosition position;
//主视图
@property (nonatomic, strong) UIView *mainView;
//内容lab
@property (nonatomic, strong) UILabel *contentLab;
//标题lab
@property (nonatomic, strong) UILabel *titleLab;


@end
@implementation LCToastView

//只有msg
-(instancetype)initNormalToastWithMsg:(NSString *)msg{
    
    if (self = [super init]) {
        
        self.style = LCToastStyleNormal;
        [self initView];
        
        //显示的lab
        [self.mainView addSubview:self.contentLab];
        self.contentLab.text = msg;
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(self.mainView);
            make.width.lessThanOrEqualTo(@(LCScreenW-160));
            make.height.lessThanOrEqualTo(@(LCScreenH-160));
        }];
    }
    return self;
}
//title 和 msg
-(instancetype)initTitleToastWithMsg:(NSString *)msg
                               title:(NSString *)title
                            interval:(CGFloat)interval{
    
    if (self = [super init]) {
        self.style = LCToastStyleTitle;
        [self initView];
        
        [self.mainView addSubview:self.titleLab];
        self.titleLab.text = title;
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.mas_equalTo(self.mainView);
        }];
        
        [self.mainView addSubview:self.contentLab];
        self.contentLab.text = msg;
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(interval);
            make.left.bottom.right.mas_equalTo(self.mainView);
            make.width.lessThanOrEqualTo(@(LCScreenW-160));
            make.height.lessThanOrEqualTo(@(LCScreenH-160));
        }];
    }
    return self;
}
- (void)initView{
    
    self.hidden = YES;
    self.backgroundColor = LCRGBA(0x04031D, 0.9);
    self.layer.cornerRadius = 10.f;
    self.clipsToBounds = YES;
    
    UIWindow *window = [self keywindow];
    [window addSubview:self];
    
    //内容视图
    [self addSubview:self.mainView];
    
    self.edgeInsets =  UIEdgeInsetsMake(15, 20, 15, 20);
}
/**
 显示
 
 @param duration 时长
 @param position 显示位置
 @param showLevel 只有iscover=NO时生效
 */
- (void)showWithDuration:(CGFloat)duration
            showPosition:(LCToastShowPosition)position
               showLevel:(LCToastShowLevel)showLevel{
    
    if (position == LCToastShowPositionTop) {
        
        [self showWithDuration:duration referencePoint:ReferencePointTop distanceY:30 showLevel:showLevel];
    }else if (position == LCToastShowPositionMiddle){
        [self showWithDuration:duration referencePoint:ReferencePointCenter distanceY:0 showLevel:showLevel];
    }else if (position == LCToastShowPositionBottom){
        [self showWithDuration:duration referencePoint:ReferencePointBottom distanceY:-30 showLevel:showLevel];
    }
}
/**
 自定义高度
 
 @param duration 显示时长
 @param referencePoint 参考点
 @param distanceY 距离
 @param showLevel 只有iscover=NO时生效
 */
- (void)showWithDuration:(CGFloat)duration
          referencePoint:(ReferencePoint)referencePoint
               distanceY:(CGFloat)distanceY
               showLevel:(LCToastShowLevel)showLevel{
    
    BOOL iscover = YES;
    if (showLevel==LCToastShowLeveLow || showLevel==LCToastShowLevelMiddle || showLevel==LCToastShowLevelHigh) {
        iscover = NO;
    }
    
    BOOL hasMoreHigh = NO;
    for (UIView *subView in self.keywindow.subviews) {
        
        if ([subView isKindOfClass:[LCToastView class]]) {
            
            if (subView.tag<=showLevel) {
                if (!iscover && subView != self) {
                    [subView removeFromSuperview];
                }
            }else{
                hasMoreHigh = YES;
            }
        }
    }
    if (hasMoreHigh) {
        //有正在显示的更高等级的则不显示当前toast
        [self removeFromSuperview];
        return;
    }
    
    if (iscover) {
        self.tag = KCoverStyleTag;
    }else{
        self.tag = showLevel;
    }
    //显示位置
    if (referencePoint == ReferencePointTop) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.keywindow.mas_centerX).offset(0);
            make.top.mas_equalTo(self.keywindow.mas_top).offset(distanceY);
        }];
    }else if (referencePoint == ReferencePointCenter){
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.keywindow.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.keywindow.mas_centerY).offset(distanceY);
        }];
    }else if (referencePoint == ReferencePointBottom){
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.keywindow.mas_centerX).offset(0);
            make.bottom.mas_equalTo(self.keywindow.mas_bottom).offset(distanceY);
        }];
    }
    self.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.hidden = YES;
        [self removeFromSuperview];
    });
}

#pragma mark - set/get
//设置整体内容内边距
-(void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    
    _edgeInsets = edgeInsets;
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(edgeInsets.left);
        make.top.mas_equalTo(self.mas_top).offset(edgeInsets.top);
        make.right.mas_equalTo(self.mas_right).offset(-edgeInsets.right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-edgeInsets.bottom);
    }];
}
- (UIWindow *)keywindow{
    
    return [UIApplication sharedApplication].delegate.window;
}

-(void)setBgColor:(UIColor *)bgColor{
    
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}
-(void)setContentColor:(UIColor *)contentColor{
    
    _contentColor = contentColor;
    self.contentLab.textColor = _contentColor;
}
-(void)setContentFont:(UIFont *)contentFont{
    
    _contentFont = contentFont;
    self.contentLab.font = contentFont;
}
-(void)setMaxWidth:(CGFloat)maxWidth{
    
    _maxWidth = maxWidth;
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.lessThanOrEqualTo(@(maxWidth));
    }];
}
-(void)setMaxHeight:(CGFloat)maxHeight{
    
    _maxHeight = maxHeight;
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.lessThanOrEqualTo(@(maxHeight));
    }];
}
-(UILabel *)titleLab{
    
    if (!_titleLab) {
        
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
-(UILabel *)contentLab{
    
    if (!_contentLab) {
        
        _contentLab = [[UILabel alloc]init];
        _contentLab.numberOfLines = 0;
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = [UIColor whiteColor];
    }
    return _contentLab;
}
-(UIView *)mainView{
    
    if (!_mainView) {
        
        _mainView = [[UIView alloc]init];
        _mainView.backgroundColor = [UIColor clearColor];
    }
    return _mainView;
}
@end

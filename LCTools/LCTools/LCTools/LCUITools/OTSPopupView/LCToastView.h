//
//  LCToastView.h
//  OTSUITool
//
//  Created by Luca on 2019/3/13.
//  Copyright © 2019 Luca. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KCoverStyleTag 73364664

typedef NS_ENUM(NSInteger, LCToastShowPosition) {
    LCToastShowPositionMiddle,//中间
    LCToastShowPositionTop,//顶部
    LCToastShowPositionBottom,//底部
};
typedef NS_ENUM(NSInteger, LCToastImagePosition) {
    LCToastImagePositionTop,//图片在顶部
    LCToastImagePositionBottom,//图片在底部
    LCToastImagePositionLeft,//图片在左边
    LCToastImagePositionRight,//图片在右边
};
/**
 替换规则:同等级时后出的会把先出的替换，只显示最高等级的最后一条

 - LCToastShowLeveLow: 显示优先级
 */
typedef NS_ENUM(NSInteger, LCToastShowLevel) {
    LCToastShowLeveCover = KCoverStyleTag,//可以覆盖，可以同时显示多个toast
    LCToastShowLeveLow,//低等级
    LCToastShowLevelMiddle,//中级
    LCToastShowLevelHigh,//高级
};
typedef NS_ENUM(NSInteger, ReferencePoint) {
    ReferencePointTop,//相对顶部
    ReferencePointCenter,//相对中心
    ReferencePointBottom,//相对底部
};

NS_ASSUME_NONNULL_BEGIN

@interface LCToastView : UIView
//背景颜色
@property (nonatomic, strong) UIColor *bgColor;
//整个内容区的内边距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
//圆角
@property (nonatomic, assign) CGFloat cornerRadius;
//内容文字颜色
@property (nonatomic, strong) UIColor *contentColor;
//内容字体大小
@property (nonatomic, strong) UIFont *contentFont;
//内容文字最大长、高(注意是文字不是内容视图)
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

//只有msg
-(instancetype)initNormalToastWithMsg:(NSString *)msg;
//title 和 msg
-(instancetype)initTitleToastWithMsg:(NSString *)msg
                               title:(NSString *)title
                            interval:(CGFloat)interval;

//有需要可以继续添加样式
////图片和msg 图片位置，图片距离title间距
//-(instancetype)initImageToastWithMsg:(NSString *)msg
//                               image:(UIImage *)image
//                       imagePosition:(LCToastImagePosition)imagePosition
//                            interval:(CGFloat)interval;
////图片、title和msg
//-(instancetype)initTitleAndImageToastWithMsg:(NSString *)msg
//                                       title:(NSString *)title
//                                       image:(UIImage *)image;

/**
 显示

 @param duration 时长
 @param position 显示位置
 @param showLevel 只有iscover=NO时生效
 */
- (void)showWithDuration:(CGFloat)duration
            showPosition:(LCToastShowPosition)position
               showLevel:(LCToastShowLevel)showLevel;

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
               showLevel:(LCToastShowLevel)showLevel;
@end

NS_ASSUME_NONNULL_END

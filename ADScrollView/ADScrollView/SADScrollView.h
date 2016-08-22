//
//  SADScrollView.h
//  ADScrollView
//
//  Created by User01 on 16/8/22.
//  Copyright © 2016年 Spring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SADScrollViewDelegate <NSObject>

- (void)adEventClickIndex:(NSUInteger)index;

@end


@interface SADScrollView : UIView
///**
// *  创建scrol view
// *
// *  @param frame    frame
// *  @param adArray  ad数据
// *  @param isRepete 是否循环滚动
// *
// *  @return self
// */
//- (instancetype)initWithFrame:(CGRect)frame WithAdArray:(NSArray*)adArray WithRepete:(BOOL)isRepete;

/**
 *  创建scrol view
 *
 *  @param frame    frame
 *  @param adArray  ad数据
 *  @param isRepete 是否循环滚动
 *  @param cardSize 中间显示框的大小(可以不设置->CGSizeZero 默认为宽高各减80) 
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame WithAdArray:(NSArray*)adArray CardViewSize:(CGSize)cardSize WithRepete:(BOOL)isRepete;

@property (assign, nonatomic) id<SADScrollViewDelegate> delegate;

@end

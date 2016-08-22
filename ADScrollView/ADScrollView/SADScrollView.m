//
//  SADScrollView.m
//  ADScrollView
//
//  Created by User01 on 16/8/22.
//  Copyright © 2016年 Spring. All rights reserved.
//

#import "SADScrollView.h"
#define WIDTH   self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height

#define LeftRigthFengXi 64

//#define CardWidth 315
//#define CardHidth 270

//#define CardWidth86 (CardWidth - 20)
//#define CardHidth86 (CardHidth * 0.86)

@interface SADScrollView ()<UIScrollViewDelegate>{
//    UIScrollView * scrollerView;
    UIPageControl * pageControl;
    int selectIndex;
    NSMutableArray * AdArray;
    
    NSMutableArray * AllAdImageBtnArray;
    
    NSInteger CardWidth;
    NSInteger CardHidth;
    
    NSInteger CardWidth86;
    NSInteger CardHidth86;
    
    CGSize CardSize;
    
    NSUInteger cardCount;
    
    BOOL isRepete;
}

@end

@implementation SADScrollView

- (instancetype)initWithFrame:(CGRect)frame WithAdArray:(NSArray*)adArray CardViewSize:(CGSize)cardSize WithRepete:(BOOL)_isRepete{
    self = [super initWithFrame:frame];
    if (self) {
        if (adArray.count ==0) {
            NSLog(@"您传入的AdArray为空");
            return self;
        }
        isRepete = _isRepete;
        cardCount = adArray.count;
        if (isRepete) {
            //特别说明 adArray 加了两次是为了可以循环滚动
            AdArray = [NSMutableArray arrayWithArray:adArray];
            [AdArray addObjectsFromArray:adArray];
        }else{
            AdArray = [NSMutableArray arrayWithArray:adArray];
        }
        
        CardSize = cardSize;
        
        [self initScrollView:frame];
    }
    return self;
}

- (void)initScrollView:(CGRect)frame{
    if (CardSize.height>0) {
        CardWidth =CardSize.width;
        CardHidth =CardSize.height;
    }else{
        CardWidth =frame.size.width - 80;
        CardHidth =frame.size.height - 80;
    }
    CardWidth86 =(CardWidth - 20);
    CardHidth86 =(CardHidth * 0.86);
    
    
    
    UIScrollView * scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake((frame.size.width - CardWidth)* 0.5, 20, CardWidth, CardHidth)];
//    [scrollerView setBackgroundColor:[UIColor redColor]];
    [scrollerView setShowsHorizontalScrollIndicator:NO];
    scrollerView.delegate = self;
    scrollerView.clipsToBounds = NO;

    AllAdImageBtnArray  = [NSMutableArray array];
    
    for (NSInteger i = 0; i <AdArray.count; i ++) {
        UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [imageButton setBackgroundColor:[UIColor blueColor]];
        NSString * imageName = [AdArray objectAtIndex:i];
        [imageButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        imageButton.layer.cornerRadius = 5;//圆角半径
        imageButton.layer.masksToBounds = YES;//切远角
        imageButton.frame = CGRectMake(0, 0, CardWidth, CardHidth);
        [imageButton setCenter:CGPointMake(CardWidth *i + CardWidth * 0.5, CardHidth * 0.5)];
        imageButton.tag = i;
        [imageButton setAlpha:0.70];
        [imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollerView addSubview:imageButton];
        [AllAdImageBtnArray addObject:imageButton];
    }
    
    scrollerView.contentSize = CGSizeMake(CardWidth *AdArray.count, CardHidth);
    scrollerView.pagingEnabled = YES;
    if (isRepete) {
        scrollerView.contentOffset = CGPointMake(CardWidth *cardCount, 0);
    }
    [scrollerView setTag:1001];
    
    [self scrollViewDidScroll:scrollerView];
    [self addSubview:scrollerView];
    
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CardHidth+(CardHidth * 0.1)+10, frame.size.width, 0)];
    [self addSubview:pageControl];
    pageControl.numberOfPages = cardCount;//总的图片页数
    pageControl.currentPage = 0; //当前页
}
#pragma mark -
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    NSLog(@"%f",scrollView.contentOffset.x);
    //    滑动结束
    if (isRepete) {
        if (scrollView.contentOffset.x == CardWidth) {
            scrollView.contentOffset = CGPointMake(CardWidth *(cardCount+1), 0);
        }
        if (scrollView.contentOffset.x == CardWidth *(cardCount+2)) {
            scrollView.contentOffset = CGPointMake(CardWidth *2, 0);
        }
    }
    selectIndex = (int)((scrollView.contentOffset.x + CardWidth* 0.5) /CardWidth) % cardCount;
    NSLog(@"--->%d",selectIndex);
    
    //    if (selectIndex == self.get_adArray.count) {
    //        selectIndex = 0;
    //
    //    }
    [pageControl setCurrentPage:selectIndex];
}

# pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag !=1001) {
        return;
    }
    //    selectIndex = (scrollView.contentOffset.x + CardWidth* 0.5) /CardWidth;
    
    for (UIImageView *imageView in AllAdImageBtnArray) {
        CGPoint center = imageView.center;
        [imageView setFrame:CGRectMake(0, 0, CardWidth86, CardHidth86)];
        [imageView setCenter:center];
        [imageView setAlpha:0.4];
    }
    int current = ((scrollView.contentOffset.x + CardWidth* 0.5) /CardWidth);
    if (AllAdImageBtnArray.count>current) {
        UIImageView * imageView = [AllAdImageBtnArray objectAtIndex:current];
        [imageView setAlpha:1];
    }
    //    UIImageView * imageView = [imageViewArray objectAtIndex:selectIndex];
    //    CGPoint center = imageView.center;
    //    [imageView setFrame:CGRectMake(0, 0, CardWidth, CardHidth)];
    //    [imageView setCenter:center];
    
    [self updateProgress:scrollView];
    
}

- (void)updateProgress:(UIScrollView *)scrollView
{
    //    if (![self.delegate respondsToSelector:@selector(updateView:withProgress:scrollDirection:)]) {
    //        return;
    //    }
    CGFloat scrollViewCenter = (scrollView.contentOffset.x + CardWidth* 0.5);
    
    for (UIImageView *view in AllAdImageBtnArray) {
        CGFloat progress;
        progress = (view.center.x - scrollViewCenter) / CGRectGetHeight(scrollView.bounds);
        // scale
        CGFloat width = view.frame.size.width;
        CGFloat height = view.frame.size.height;
        CGPoint center = view.center;
        
        width = width * (1 - 0.3 * (fabs(progress))) + 20;
        height = height * (1.15 - 0.3 * (fabs(progress)));
        
        if (width<CardWidth86) {
            width = CardWidth86;
        }
        if (height<CardHidth86) {
            height = CardHidth86;
        }
        
        view.frame = CGRectMake(0, 0, width, height);
        //        NSLog(@"%f,%f",width,height);
        view.layer.masksToBounds = YES; //没这句话它圆不起来
        view.layer.cornerRadius = 5.0; //设置图片圆角的尺度
        view.center = center;
        
        
    }
}


#pragma mark 图片点击事件
-(void)imageButtonAction:(UIButton*)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag % cardCount;
    
    if ([self.delegate respondsToSelector:@selector(adEventClickIndex:)]) {
        [self.delegate adEventClickIndex:index];
    }
}

@end

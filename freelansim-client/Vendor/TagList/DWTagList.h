//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWTagListDelegate <NSObject>

@required

- (void)selectedTag:(NSString*)tagName;

@end

#define CORNER_RADIUS 5.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 7.0f
#define FONT_SIZE 15.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.88f green:0.58f blue:0.47f alpha:1.00f]
#define TEXT_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 0.0f)
#define BORDER_COLOR [UIColor colorWithRed:0.88f green:0.58f blue:0.47f alpha:1.00f].CGColor
#define BORDER_WIDTH 1.0f

@interface DWTagList : UIView
{
    UIView *view;
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) id<DWTagListDelegate> delegate;

- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end

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

#define CORNER_RADIUS 2.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 7.0f
#define FONT_SIZE 14.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 3.0f
#define BACKGROUND_COLOR [UIColor whiteColor]
#define TEXT_COLOR [UIColor colorWithRed:(93/255.f) green:(101/255.f) blue:(119/255.f) alpha:1]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 0.0f)
#define BORDER_COLOR [UIColor colorWithRed:(215/255.f) green:(223/255.f) blue:(225/255.f) alpha:1].CGColor
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

//
//  Fonts.h
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#ifndef Journey_Fonts_h
#define Journey_Fonts_h

// Example
// #define EXAMPLE_COLOR        RGBACOLOR(1, 1, 1, 1)
// #define FONTSIZE_BOLD_17     [UIFont boldSystemFontOfSize:17.0]
// #define FONTSIZE_16          [UIFont systemFontOfSize:16.0]
// #define YAHEI_FONTSIZE_12    [UIFont fontWithName:@"MicrosoftYaHei" size:12.0]

#define NAV_BAR_BG_NORMAL_COLOR         UIColorFromRGB(0xF3F6F6)
#define NAV_BAR_TITLE_NORMAL_COLOR      UIColorFromRGB(0x2E3642)
#define MENU_HOVER_BG_COLOR             UIColorFromRGB(0xD4E1E1)

#define ADD_LEVEL_COLOR         RGBACOLOR(190, 1, 0, 1)
#define HERO_EQUI_COLOR         RGBACOLOR(77, 134, 198, 1)
#define DPS_TAG_COLOR           RGBACOLOR(78, 167, 171, 1)
#define ASS_TAG_COLOR           RGBACOLOR(59, 72, 88, 1)
#define TAG_TEXT_COLOR          RGBACOLOR(247, 247, 247, 1) // Dark Gray
#define TAG_DISABLE_COLOR       RGBACOLOR(104, 104, 104, 1) // Dark Gray

#define SEARCH_FILTER_LAB_HIGHTED_COLOR RGBACOLOR(255, 255, 255, 1)
#define SEARCH_FILTER_LAB_NORMAL_COLOR RGBACOLOR(66, 33, 11, 1)

#define SEARCH_FILTER_BTN_HIGHTED_COLOR RGBACOLOR(96, 159, 204, 1)
#define SEARCH_FILTER_BTN_NORMAL_COLOR RGBACOLOR(242, 242, 242, 1)
#define SEARCH_FILTER_LABEL_NORMAL_COLOR RGBACOLOR(230, 230, 230, 1)

#define OVERLAY_FILL_COLOR         RGBACOLOR(0, 255, 0, 0.5)
#define OVERLAY_STROKE_COLOR       RGBACOLOR(135, 206, 235, 0.5)

//HelveticaNeue
#define HelveticaNeue_FONTSIZE_12    [UIFont fontWithName:@"HelveticaNeue" size:12.0]
#define HelveticaNeue_FONTSIZE_13    [UIFont fontWithName:@"HelveticaNeue" size:13.0]
#define HelveticaNeue_FONTSIZE_14    [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define HelveticaNeue_FONTSIZE_16    [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define HelveticaNeue_FONTSIZE_20    [UIFont fontWithName:@"HelveticaNeue" size:20.0]
#define HelveticaNeue_FONTSIZE_21    [UIFont fontWithName:@"HelveticaNeue" size:21.0]

#define FONTSIZE_15          [UIFont systemFontOfSize:15.0]

#define UIColorFromRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BTN_ENABLE_BG_COLOR        UIColorFromRGB(0xAC0005)
#define BTN_DISABLE_BG_COLOR       UIColorFromRGB(0xD7D7D7)
#define BTN_ENABLE_TITLE_COLOR     UIColorFromRGB(0xFFFFFF)
#define BTN_DISABLE_TITLE_COLOR    UIColorFromRGB(0x000000)


#define THEME_GREEN                UIColorFromRGB(0x32C689)
#define COLOR_BLACK                UIColorFromRGB(0x000000)
#define COLOR_WHITE                UIColorFromRGB(0xFFFFFF)


#endif

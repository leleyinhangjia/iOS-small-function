//
//  ColorPalette.h
//  Colors
//
//  Created by Ignacio Romero Z. on 7/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Color;

@interface Palette : NSObject

@property (nonatomic, readonly) NSMutableArray *colors;

+ (instancetype)sharedPalette;

- (void)reloadAll;
- (void)removeColor:(Color *)color;
- (void)removeAll;

@end

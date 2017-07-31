//
//  UINavigationItem+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/7/31.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (ZHExtension)

@end

typedef NS_ENUM(NSInteger, ItemLocation) {
    ItemLocationLeft     = 0,
    ItemLocationRight      = 1,
};

@interface UINavigationItem (ZHBarButtonItemExtension)

- (void)zh_setNoSpaceBarButtonItem:(NSArray <UIBarButtonItem *> *)barButtonItems itemLocation:(ItemLocation)itemLocation;

@end

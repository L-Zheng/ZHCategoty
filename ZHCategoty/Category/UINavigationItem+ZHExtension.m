//
//  UINavigationItem+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/7/31.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "UINavigationItem+ZHExtension.h"
#import "ZHDefineHeader.h"

@implementation UINavigationItem (ZHExtension)

@end

@implementation UINavigationItem (ZHBarButtonItemExtension)

- (void)zh_setNoSpaceBarButtonItem:(NSArray <UIBarButtonItem *> *)barButtonItems itemLocation:(ItemLocation)itemLocation{
    
    if (barButtonItems.count == 0) {
        return;
    }
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = kIsScreen3X ? -20 : -16;
    
    //空白间距60   @3x  20
    //空白间距32   @2x  16
    
    NSMutableArray *willSetItems = [NSMutableArray arrayWithObject:space];
    [willSetItems addObjectsFromArray:barButtonItems];
    
    switch (itemLocation) {
        case ItemLocationLeft:
            self.leftBarButtonItems = willSetItems;
            break;
            
        case ItemLocationRight:
            self.rightBarButtonItems = willSetItems;
            break;
            
        default:
            self.leftBarButtonItems = willSetItems;
            break;
    }
}

@end

//
//  AnimationView.h
//  ceshi
//
//  Created by mm on 2019/7/17.
//  Copyright © 2019 mm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationView : UIView
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,assign) CGFloat offset;
@end

NS_ASSUME_NONNULL_END

//
//  AnimationView.m
//  ceshi
//
//  Created by mm on 2019/7/17.
//  Copyright © 2019 mm. All rights reserved.
//

#import "AnimationView.h"
#import <QuartzCore/QuartzCore.h>
@implementation AnimationView

-(id)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        //返回按钮
        [self creatBackBut];
        //画一条直线的动画
        [self creatLineAnimation];
        //渐变的圆环动画
        [self creatCircle];
        //波浪动画
        [self creatCurve];
        //围绕着圆环转的圆点
        [self creatCAKeyframeAnimationDemo];
    }
    return self;
}
-(void)creatBackBut{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 40, 100, 30);
    [but setTitle:@"返回" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor greenColor]];
    [but addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:but];
}
-(void)back{
    [UIView animateWithDuration:0.8 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.01, self.frame.size.height);
        self.alpha = 0.2;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
//画一个直线动画
-(void)creatLineAnimation{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //要画的线的起始点
    [path moveToPoint:CGPointMake(10, 100)];
    //线的终点
    [path addLineToPoint:CGPointMake(300, 100)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 2;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    /*
     加上这句代码就把直线编程虚线了(数组里面为虚线的每段长度)
     如果为多个值,则会进行循环画相应长度的虚线
     */
//    layer.lineDashPattern =@[@(10)];
    
    
    /*
     CABasicAnimation:只针对起点和终点进行动画,可以理解成CAKeyframeAnimation只设置起点和终点
     strokeStart:从起始点都结尾点  消除线
     strokeEnd:从起始点到结束点  画线
     */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //.动画时长
    animation.duration = 5;
    /*
     fromValue/toValue  起始/结束(0-1)
     fromValue:相当于从直线的哪个位置开始执行动画
     toValue:动画结束在线的哪个位置
     */
    animation.fromValue = @(0);
    animation.toValue = @(1);
    //动画重复次数
    animation.repeatCount = 1;
    //保持线的最终状态
    animation.fillMode = kCAFillModeForwards;
    //动画添加到CAShapeLayer上
    [layer addAnimation:animation forKey:nil];
    //layer展示到视图上
    [self.layer addSublayer:layer];
}
/*
 画一个渐变圆环(其实就是建一个view,给view加上一个渐变背景色,然后画圆环,设置view.layer.mask 加上一层蒙版,和控件切圆一样的思路,最后加上CAGradientLayer的动画,就形成一个渐变色圆环的动画)
 */
-(void)creatCircle{
    //设置底层View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, 120)];
    [self addSubview:view];
    //通过贝塞尔曲线画圆环
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, 60) radius:50 startAngle:-2*M_PI endAngle:0 clockwise:YES];
    //把贝塞尔曲线画的圆环展示出来
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 10;
    //这个颜色可以随便设置
    layer.strokeColor = [UIColor redColor].CGColor;
    //因为默认填充色为黑色  所以把填充色规定为白色
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = path.CGPath;
    [view.layer addSublayer:layer];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    //背景色起始点 z左上角为(0.0)
    gradient.startPoint = CGPointMake(0, 0);
    //背景色终点
    gradient.endPoint = CGPointMake(1, 1);
    //设置所有的渐变颜色
    gradient.colors = @[(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor blackColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
    //设置颜色区间点位置(相当于把圆环看成1 然后各个颜色在圆环的位置)
    gradient.locations = @[@(.25),@(.5),@(.8),@(1)];
    //设置底层View的渐变色
    [view.layer addSublayer:gradient];
    //给view加蒙板(蒙板就是展示贝塞尔曲线画出来圆环的CAShapeLayer)
    view.layer.mask = layer;
    //添加动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue =@(1);
    animation.duration = 5;
    [layer addAnimation:animation forKey:@""];
}
//创建波浪线的承载以及帧的刷新
-(void)creatCurve{
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 250, self.frame.size.width, 200);
    self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:self.shapeLayer];
    /*
     CADisplayLink:和计时器差不多 不过这个是按照帧数去刷新 才能看出来波浪一直在动(具体区别自行百度)
     */
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(showAnimation)];
    /*
     link:加入到指定的runloop中 NSRunLoopCommonModes加入到这个中,可以使这个按帧数刷新不受页面变化的影响(NSRunLoopCommonMode这个会受到页面滚动等等因素的影响,具体差别自行百度)
     */
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.offset = 0;
}
//创建波浪线及其动态
-(void)showAnimation{
    //创建可变的路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    //规定波浪浮动的高度
    CGFloat y=50;
    //要绘制路径的起始点
    CGPathMoveToPoint(path, nil, 0, y);
    //循环整个屏幕宽度的像素点(具体根据自己需要宽度自行设置)
    for (int i = 0; i<self.frame.size.width; i++) {
        //算出波浪线各个点所在的位置
        y = 10*sin((1/50.0)*i+self.offset);
        //把算出的的点连成线
        CGPathAddLineToPoint(path, nil, i, y);
    }
    //这两个方法是为了下面的整体蓝色部分,使看着更像波浪线(可以屏蔽这两个划线方法  看看实际效果)
    CGPathAddLineToPoint(path, nil, self.frame.size.width, 100);
    CGPathAddLineToPoint(path, nil, 0, 100);
    //闭合整个路径
    CGPathCloseSubpath(path);
    //把该路径通过CAShapeLayer呈现出来(类似呈现贝塞尔所画的线的路径)
    self.shapeLayer.path = path;
    //递减保留的图形路径计数 (我个人认为可以理解成释放(要是有错误麻烦大佬指正))
    CGPathRelease(path);
    //
    self.offset +=0.1;
    if (self.offset>200*M_PI) {
        self.offset = 0;
    }
    
}
/*
 围着圆环转的小圆点
 1:先通过贝塞尔曲线画一个圆环
 2:创建一个view(任何控件都可以)切圆
 3:加载CAKeyframeAnimation 动画
 */
-(void)creatCAKeyframeAnimationDemo{
    //创建圆环
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, 450) radius:50 startAngle:-2*M_PI endAngle:0 clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 3;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
    //创建view(围着圆转的红色小圆点)
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.backgroundColor = [UIColor redColor];
    [self addSubview:view];
    //给创建的view切圆
    UIBezierPath *criclePath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(view.frame.size.width/2, view.frame.size.height/2)];
    CAShapeLayer *cricleLayer = [CAShapeLayer layer];
    cricleLayer.path = criclePath.CGPath;
    view.layer.mask = cricleLayer;
    
    //添加动画使其围绕着圆环转
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    //这里是围着贝塞尔曲线转的 所以keyPath设置为position
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.duration = 10;
    //无限转
    animation.repeatCount = HUGE;
    //把动画加载到创建的view上(让圆点到圆环上切转动都在此处完成)
    [view.layer addAnimation:animation forKey:@""];
}



@end

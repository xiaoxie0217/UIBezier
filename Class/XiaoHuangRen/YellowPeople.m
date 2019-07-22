//
//  XiaoHuangRenView.m
//  ceshi
//
//  Created by mm on 2019/7/17.
//  Copyright © 2019 mm. All rights reserved.
//


/*
 根据Xr模拟器做得 未做适配 在别的模拟器上看小黄人可能变形
 另外页面涉及的圆/弧/文字等也可以通过CGContextRef画在drawRect里面(具体方法在另一个demo里面)
 1:控件的切圆角(两种方法都有,推荐第二种)
 2:通过贝塞尔曲线来画小黄人 (包含贝塞尔曲线画圆,长方形,将文字通过layer画到view上等(因为演示模板,所有贝塞尔曲线就偷个懒 创建名字的时候用数字来区分了))

 */

#import "YellowPeople.h"
#import <QuickLook/QuickLook.h>
@implementation YellowPeople

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self creatBackBut];
        [self creatUI];
    }
    return self;
}
//创建返回按钮
-(void)creatBackBut{
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 60, 100, 80);
    [but setTitle:@"返回" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor greenColor]];
    [but addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:but];
    
    //第一种切圆角的方式
    /*
     此方法切圆角可以用 但是占内存比较多  故不推荐
     */
//    but.layer.masksToBounds = YES;
//    but.layer.cornerRadius = 5;
//    but.layer.borderWidth = 2;
//    but.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    
    //第二种切圆角的方式
    /*
     此方法通过贝塞尔曲线来画圆角 可以切多种情况的圆角且占内存较少 推荐使用此方法(但是这代码有点多 如果页面需要切圆角的控件有点多,则需要封装起来统一调用)
     注:此方法切xib的控件可能会有问题(因为切的时候已经做完适配了,故切出来的圆角会有问题(只会切左上角),所以输入的控件尺寸应该为适配过以后的)
     rect:控件的尺寸  (直接控件 .bounds 就可以得到)
     corners:画圆角的情况 (可以在控件/左/右/上/下 画 可以点进去看  根据实际情况选择)
     cornerRadii: 画圆角的尺寸
     
     
     bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
     */
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:but.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    but.layer.mask = layer;
}

-(void)back{
    //简单hidden消失动画
    /*
    这两个方法一定要看清楚,要不加载的动画会有问题
     CGAffineTransformMakeTranslation:实现以初始位置为基准,在x轴方向上平移x单位,在y轴方向上平移y单位
     CGAffineTransformMakeScale:实现以初始位置为基准,在x轴方向上缩放x倍,在y轴方向上缩放y倍(支付宝集福  福卡的高低不同就可以通过这个实现)
     
     */
    [UIView animateWithDuration:0.8 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.01, self.frame.size.height);
        self.alpha = 0.2;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

//开始画小黄人
-(void)creatUI{
    //小黄人的身体(正方形)贝塞尔曲线画正方形
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width/4, 300, self.frame.size.width/2, 300)];
    //layer加载到view上
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor yellowColor] and:path1]];
    
    //小黄人身体上半部分的半圆
    UIBezierPath *paht2 = [self creatSemicircle:0 and:-M_PI and:CGPointMake(self.frame.size.width/2, 300) and:NO and:self.frame.size.width/4];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor yellowColor] and:paht2]];
    
    //小黄人下半身的半圆M
    UIBezierPath *paht3 = [self creatSemicircle:0 and:-M_PI and:CGPointMake(self.frame.size.width/2, 600) and:YES and:self.frame.size.width/4];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor yellowColor] and:paht3]];
    
    //小黄人脖子的黑色矩形
    UIBezierPath *path4 = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width/4, 320, self.frame.size.width/2, 40)];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor blackColor] and:path4]];
    
    //小黄人两个眼睛外面的大圆
    UIBezierPath *path5 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake((self.frame.size.width/10)*4, 340) and:YES and:self.frame.size.width/10];
    [self.layer addSublayer:[self creatBorderCAShapeLayer:[UIColor whiteColor] and:[UIColor grayColor] and:10 and:path5]];
    
    UIBezierPath *path6 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake((self.frame.size.width/10)*6, 340) and:YES and:self.frame.size.width/10];
    [self.layer addSublayer:[self creatBorderCAShapeLayer:[UIColor whiteColor] and:[UIColor grayColor] and:10 and:path6]];
    
    //小黄人眼睛里面的小圆
    UIBezierPath *path7 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake(self.frame.size.width/2-30, 340) and:YES and:15];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor brownColor] and:path7]];
    
    UIBezierPath *path8 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake(self.frame.size.width/2+30, 340) and:YES and:15];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor brownColor] and:path8]];
    
    //小黄人眼睛里面的黑色眼珠
    UIBezierPath *path9 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake(self.frame.size.width/2-28, 343) and:YES and:6];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor blackColor] and:path9]];
    
    UIBezierPath *path10 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake(self.frame.size.width/2+25, 343) and:YES and:6];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor blackColor] and:path10]];
    
    //小黄人眼睛里面的白色眼珠
    UIBezierPath *path11 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake(self.frame.size.width/2-32, 340) and:YES and:3];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor whiteColor] and:path11]];
    
    UIBezierPath *path12 = [self creatSemicircle:-2*M_PI and:0 and:CGPointMake(self.frame.size.width/2+20, 340) and:YES and:3];
    [self.layer addSublayer:[self creatCAShapeLayer:[UIColor whiteColor] and:path12]];
    
    //小黄人笑的嘴巴
    UIBezierPath *path13 = [self creatSemicircle:M_PI_4 and:M_PI_4*3 and:CGPointMake(self.frame.size.width/2, 420) and:YES and:self.frame.size.width/8];
    [self.layer addSublayer:[self creatBorderCAShapeLayer:[UIColor yellowColor] and:[UIColor blackColor] and:1 and:path13]];
    
    //小黄人的头发(只是举个例子)
    for (int i = 0; i<5; i++) {
        UIBezierPath *path14 = [UIBezierPath bezierPath];
        [path14 moveToPoint:CGPointMake(150+i*30, 220)];
        [path14 addLineToPoint:CGPointMake(180+i*10, 180)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor blackColor].CGColor;
        path14.lineWidth = 2;
        layer.path = path14.CGPath;
        [self.layer addSublayer:layer];
    }
    
    
    //添加标签
    //创建文字相关layer
    CATextLayer *textLayer = [CATextLayer layer];
    
    textLayer.frame = CGRectMake(self.frame.size.width/2, 600+self.frame.size.width/4+50, self.frame.size.width/2, 40);
    //要显示的文字
    textLayer.string = @"制作人:小谢";
    //文字大小
    textLayer.fontSize = 14;
    //文字颜色
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    //文字要是过多  是否换行
//    textLayer.wrapped = YES;
    
    //创建的layer的背景色
//    textLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    //文字颜色的分辨率要和当前屏幕的分辨率相同 要不看到的文字会模糊
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [self.layer addSublayer:textLayer];
}

/*
 绘制圆或弧形(小黄人身上所有的圆弧都在此)
 startLocation:起始的弧度(3点的方向为圆的起始点方向)
 endPoint:结束的弧度
 controlPoint:半圆的圆点
 clockwise:YES为顺时针/NO为逆时针
 radius:半径
 */

-(UIBezierPath *)creatSemicircle:(CGFloat)startLocation and:(CGFloat)endLocation and:(CGPoint)controlPoint and:(BOOL)clockwise and:(CGFloat)radius{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:controlPoint radius:radius startAngle:startLocation endAngle:endLocation clockwise:clockwise];
    return path;
}
/*
 相当于绘制一个layer层(相等于贝塞尔曲线的容器,是为了绘制贝塞尔曲线路径并添加到View上,这个和贝塞尔曲线结合使用)   没有边框的
 color:贝塞尔曲线所画的填充颜色
 path:贝塞尔曲线
 */
-(CAShapeLayer *)creatCAShapeLayer:(UIColor*)color and:(UIBezierPath *)path{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = color.CGColor;
    layer.path = path.CGPath;
    return layer;
}

/*
 相当于绘制一个layer层(相等于贝塞尔曲线的容器,是为了绘制贝塞尔曲线路径并添加到View上,这个和贝塞尔曲线结合使用)  有边框的
 color:贝塞尔曲线所画的填充颜色
 borderColor:边框填充颜色
 width:边框宽度
 path:贝塞尔曲线
 */
-(CAShapeLayer *)creatBorderCAShapeLayer:(UIColor*)color and:(UIColor *)borderColor and:(CGFloat)width and:(UIBezierPath *)path{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = color.CGColor;
    layer.strokeColor = borderColor.CGColor;
    layer.lineWidth = width;
    layer.path = path.CGPath;
    return layer;
}


@end

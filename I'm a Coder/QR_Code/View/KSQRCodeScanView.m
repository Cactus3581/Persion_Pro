//
//  KSQRCodeScanView.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeScanView.h"
NS_ASSUME_NONNULL_BEGIN

@interface KSQRCodeScanView()
//扫码区域各种参数
@property (nonatomic, strong,nullable) KSQRCodeScanViewStyle* viewStyle;

//扫码区域
@property (nonatomic,assign)CGRect scanRetangleRect;

//线条扫码动画封装
@property (nonatomic,strong,nullable)KSQRCodeScanLineAnimation *scanLineAnimation;
//网格扫码动画封装
@property (nonatomic,strong,nullable)KSQRCodeNetLatticeAnimation *scanNetAnimation;

//线条在中间位置，不移动
@property (nonatomic,strong,nullable)UIImageView *scanLineStill;

/**
 @brief  启动相机时 菊花等待
 */
@property(nonatomic,strong,nullable)UIActivityIndicatorView* activityView;

/**
 @brief  启动相机中的提示文字
 */
@property(nonatomic,strong,nullable)UILabel *labelReadying;

@end

NS_ASSUME_NONNULL_END

@implementation KSQRCodeScanView

-(instancetype)initWithFrame:(CGRect)frame style:(KSQRCodeScanViewStyle*)style {
    if (self = [super initWithFrame:frame]) {
        self.viewStyle = style;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(instancetype)initWithStyle:(KSQRCodeScanViewStyle*)style {
    if (self = [super init]) {
        self.viewStyle = style;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect {
    [self drawScanRect];
}

#pragma mark - 绘制背景图，扫码区域，四个角，及四边框
- (void)drawScanRect {
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;//左边及右边距离
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    if (_viewStyle.whRatio != 1) {//如果扫码区域不是正方形，根据宽度重现设置高度
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / _viewStyle.whRatio;
        NSInteger hInt = (NSInteger)h;
        h = hInt;
        sizeRetangle = CGSizeMake(w, h);
    }
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
#pragma mark - 设置非识别区域颜色
    const CGFloat *components = CGColorGetComponents(_viewStyle.notRecoginitonArea.CGColor);
    CGFloat red_notRecoginitonArea = components[0];
    CGFloat green_notRecoginitonArea = components[1];
    CGFloat blue_notRecoginitonArea = components[2];
    CGFloat alpa_notRecoginitonArea = components[3];
    CGContextSetRGBFillColor(context, red_notRecoginitonArea, green_notRecoginitonArea,
                             blue_notRecoginitonArea, alpa_notRecoginitonArea);
#pragma mark - 填充矩形
    //扫码区域上面填充
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
    CGContextFillRect(context, rect);
    //扫码区域左边填充
    rect = CGRectMake(0, YMinRetangle, XRetangleLeft,sizeRetangle.height);
    CGContextFillRect(context, rect);
    //扫码区域右边填充
    rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft,sizeRetangle.height);
    CGContextFillRect(context, rect);
    //扫码区域下面填充
    rect = CGRectMake(0, YMaxRetangle, self.frame.size.width,self.frame.size.height - YMaxRetangle);
    CGContextFillRect(context, rect);
    //执行绘画
    CGContextStrokePath(context);
    
#pragma mark - 绘制扫码矩形框
    if (_viewStyle.isNeedShowRetangle) { //需要绘制扫码矩形框
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddRect(context, CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height));
        //CGContextMoveToPoint(context, XRetangleLeft, YMinRetangle);
        //CGContextAddLineToPoint(context, XRetangleLeft+sizeRetangle.width, YMinRetangle);
        CGContextStrokePath(context);
    }
    _scanRetangleRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
#pragma mark - 画矩形框4格外围相框角
    //相框角的宽度和高度
    int wAngle = _viewStyle.photoframeAngleW;
    int hAngle = _viewStyle.photoframeAngleH;
    //4个角的 线的宽度
    CGFloat linewidthAngle = _viewStyle.photoframeLineW;// 经验参数：6和4
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    //diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    switch (_viewStyle.photoframeAngleStyle) {
        case KScanViewPhotoframeAngleStyle_Outer: {
            diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
        }
            break;
        case KScanViewPhotoframeAngleStyle_On: {
            diffAngle = 0;
        }
            break;
        case KScanViewPhotoframeAngleStyle_Inner: {
            diffAngle = -_viewStyle.photoframeLineW/2;
        }
            break;
        default: {
            diffAngle = linewidthAngle/3;
        }
            break;
    }
    
#pragma mark - 画线
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, linewidthAngle);
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    CGContextStrokePath(context);
}

#pragma mark - 根据矩形区域，获取识别区域
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(KSQRCodeScanViewStyle*)style {
    int XRetangleLeft = style.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft*2, view.frame.size.width - XRetangleLeft*2);
    if (style.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whRatio;
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        sizeRetangle = CGSizeMake(w, h);
    }
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - style.centerUpOffset;
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    //计算兴趣区域
    CGRect rectOfInterest;
    //ref:http://www.cocoachina.com/ios/20141225/10763.html
    CGSize size = view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                    cropRect.origin.x/size.width,
                                    cropRect.size.height/fixHeight,
                                    cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                    (cropRect.origin.x + fixPadding)/fixWidth,
                                    cropRect.size.height/size.height,
                                    cropRect.size.width/fixWidth);
    }
    return rectOfInterest;
}

#pragma mark -  相机启动中的文字提示
- (void)startDeviceReadyingWithText:(NSString *)text {
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    if (!_viewStyle.isNeedShowRetangle) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / _viewStyle.whRatio;
        NSInteger hInt = (NSInteger)h;
        h = hInt;
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    
    //设备启动状态提示
    if (!_activityView) {
        self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_activityView setCenter:CGPointMake(XRetangleLeft +  sizeRetangle.width/2 - 50, YMinRetangle + sizeRetangle.height/2)];
        
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityView];
        
        CGRect labelReadyRect = CGRectMake(_activityView.frame.origin.x + _activityView.frame.size.width + 10, _activityView.frame.origin.y, 100, 30);
        self.labelReadying = [[UILabel alloc]initWithFrame:labelReadyRect];
        _labelReadying.backgroundColor = [UIColor clearColor];
        _labelReadying.textColor  = [UIColor whiteColor];
        _labelReadying.font = [UIFont systemFontOfSize:18.];
        _labelReadying.text = text;
        [self addSubview:_labelReadying];
        [_activityView startAnimating];
    }
}

#pragma mark -  关闭相机启动中的文字提示
- (void)stopDeviceReadying {
    if (_activityView) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        [_labelReadying removeFromSuperview];
        self.activityView = nil;
        self.labelReadying = nil;
    }
}

#pragma mark -动画
/**
 *  开始扫描动画
 */
- (void)startScanAnimation {
    switch (_viewStyle.anmiationStyle) {
        case KScanViewAnimationStyle_LineMove: {
            //线动画
            if (!_scanLineAnimation)
                self.scanLineAnimation = [[KSQRCodeScanLineAnimation alloc]init];
            [_scanLineAnimation startAnimatingWithRect:_scanRetangleRect
                                                InView:self
                                                 Image:_viewStyle.animationImage];
        }
            break;
        case KScanViewAnimationStyle_NetGrid: {
            //网格动画
            if (!_scanNetAnimation)
                self.scanNetAnimation = [[KSQRCodeNetLatticeAnimation alloc]init];
            [_scanNetAnimation startAnimatingWithRect:_scanRetangleRect
                                               InView:self
                                                Image:_viewStyle.animationImage];
        }
            break;
        case KScanViewAnimationStyle_LineStill: {
            if (!_scanLineStill) {
                CGRect stillRect = CGRectMake(_scanRetangleRect.origin.x+20,
                                              _scanRetangleRect.origin.y + _scanRetangleRect.size.height/2,
                                              _scanRetangleRect.size.width-40,
                                              2);
                _scanLineStill = [[UIImageView alloc]initWithFrame:stillRect];
                _scanLineStill.image = _viewStyle.animationImage;
            }
            [self addSubview:_scanLineStill];
        }
        default:
            break;
    }
}

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation {
    if (_scanLineAnimation) {
        [_scanLineAnimation stopAnimating];
    }
    if (_scanNetAnimation) {
        [_scanNetAnimation stopAnimating];
    }
    if (_scanLineStill) {
        [_scanLineStill removeFromSuperview];
    }
}

@end

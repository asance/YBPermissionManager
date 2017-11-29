//
//  YBPermissionBeLimitedView.m
//  test_CodeReview
//
//  Created by asance on 2017/10/13.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBPermissionBeLimitedView.h"
#import "YBPermissionManager.h"
#import "UIColor+HexInt.h"
#import "NSNumber+LayoutAdaptation.h"

@implementation YBPermissionBeLimitedView

+ (void)fetchPermissionWithType:(YBPermissionType)type success:(void (^)(void))success failure:(void (^)(void))failure{
    YBPermissionBeLimitedView *view = [[YBPermissionBeLimitedView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    view.permissionType = type;
    view.onOpenPermissionBlock = success;
    view.onClosePermissionBlock = failure;
    view.appName = nil;
    [[YBPermissionManager shareInstance] setPermissionBeLimitedView:view];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view startAnimationing];
}
+ (void)fetchPermissionWithType:(YBPermissionType)type appName:(NSString *)appName success:(void (^)(void))success failure:(void (^)(void))failure{
    YBPermissionBeLimitedView *view = [[YBPermissionBeLimitedView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    view.permissionType = type;
    view.appName = appName;
    view.onOpenPermissionBlock = success;
    view.onClosePermissionBlock = failure;
    [[YBPermissionManager shareInstance] setPermissionBeLimitedView:view];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view startAnimationing];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.confirmButton];
        
        [self.contentView addSubview:self.line1View];
        [self.contentView addSubview:self.line2View];
        
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self setRemindAttributedText];
    }
    return self;
}
#pragma mark - Button Action
- (void)onCloseAction{
    [self stopAnimaitoning];
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        if(self.onClosePermissionBlock){
            self.onClosePermissionBlock();
        }
        [self removeFromSuperview];
    });
}
- (void)onCloseTouchDownAction{
    self.cancelButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)onCloseTouchOutSideAction{
    self.cancelButton.backgroundColor = [UIColor whiteColor];
}
- (void)onConfirmAction{
    self.confirmButton.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        if(YES==[[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]){
            NSDictionary *options = @{};
            [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {}];
        }
        else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
- (void)onTouchDownAction{
    self.confirmButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)onTouchOutSideAction{
    self.confirmButton.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Public Mehtod
- (void)startAnimationing{
    self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.backgroundView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.transform = CGAffineTransformMakeScale(1, 1);
                         self.backgroundView.alpha = 0.5f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)stopAnimaitoning{
    [UIView animateWithDuration:0.2f
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{self.alpha = 0.0f;}
                     completion:nil];
}

#pragma mark - Getter Setter
- (UIView *)backgroundView{
    if(!_backgroundView){
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.6;
    }
    return _backgroundView;
}
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [NSNumber adaptToHeight:275], [NSNumber adaptToHeight:175])];
        _contentView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        CGFloat width = CGRectGetWidth(self.contentView.frame);
        CGFloat titleLabelHeight = [NSNumber adaptToHeight:55];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, titleLabelHeight)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:[NSNumber adaptToHeight:15]];
        _titleLabel.textColor = [UIColor hexColor:@"333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"您的通讯录已被限制";
    }
    return _titleLabel;
}
- (UILabel *)detailLabel{
    if(!_detailLabel){
        CGFloat width = CGRectGetWidth(self.contentView.frame);
        CGFloat titleLabelHeight = [NSNumber adaptToHeight:65];
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), width, titleLabelHeight)];
        _detailLabel.font = [UIFont systemFontOfSize:[NSNumber adaptToHeight:16]];
        _detailLabel.textColor = [UIColor hexColor:@"999999"];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.text = @"";
    }
    return _detailLabel;
}
- (UIButton *)cancelButton{
    if(!_cancelButton){
        CGFloat height = CGRectGetHeight(self.contentView.frame);
        CGFloat width = CGRectGetWidth(self.contentView.frame);
        CGFloat buttonHeight = [NSNumber adaptToHeight:45];
        CGFloat edgeHeight = 0;//[NSNumber adaptToHeight:10];
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, height-buttonHeight-edgeHeight, width*0.5, buttonHeight);
        
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:[NSNumber adaptToHeight:15]];
        
        [_cancelButton setTitle:@"等会吧" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor hexColor:@"0099ff"] forState:UIControlStateNormal];
        
        [_cancelButton addTarget:self action:@selector(onCloseAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton addTarget:self action:@selector(onCloseTouchDownAction) forControlEvents:UIControlEventTouchDown];
        [_cancelButton addTarget:self action:@selector(onCloseTouchOutSideAction) forControlEvents:UIControlEventTouchDragOutside];
        [_cancelButton addTarget:self action:@selector(onCloseTouchOutSideAction) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton{
    if(!_confirmButton){
        CGFloat height = CGRectGetHeight(self.contentView.frame);
        CGFloat width = CGRectGetWidth(self.contentView.frame);
        CGFloat buttonHeight = [NSNumber adaptToHeight:45];
        CGFloat edgeHeight = 0;//[NSNumber adaptToHeight:10];
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), height-buttonHeight-edgeHeight, width*0.5, buttonHeight);
        
        _confirmButton.backgroundColor = [UIColor whiteColor];
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:[NSNumber adaptToHeight:15]];
        
        [_confirmButton setTitle:@"立即设置" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor hexColor:@"0099ff"] forState:UIControlStateNormal];
        
        [_confirmButton addTarget:self action:@selector(onConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton addTarget:self action:@selector(onTouchDownAction) forControlEvents:UIControlEventTouchDown];
        [_confirmButton addTarget:self action:@selector(onTouchOutSideAction) forControlEvents:UIControlEventTouchDragOutside];
        [_confirmButton addTarget:self action:@selector(onTouchOutSideAction) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _confirmButton;
}
- (UIView *)line1View{
    if(!_line1View){
        CGFloat width = CGRectGetWidth(self.contentView.frame);
        _line1View = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.confirmButton.frame), width, 0.5)];
        _line1View.backgroundColor = [UIColor hexColor:@"e5e5e5"];
    }
    return _line1View;
}
- (UIView *)line2View{
    if(!_line2View){
        CGFloat height = CGRectGetHeight(self.cancelButton.frame);
        _line2View = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMinY(self.cancelButton.frame), 0.5, height)];
        _line2View.backgroundColor = [UIColor hexColor:@"e5e5e5"];
    }
    return _line2View;
}
- (void)setAppName:(NSString *)appName{
    if(0==appName.length){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    _appName = [appName copy];
    [self setRemindAttributedText];
}
- (NSString *)titleLabelString{
    if(YBPermissionTypeContact==self.permissionType){
        return @"您的通讯录权限已被限制";
    }
    else if(YBPermissionTypePhoto==self.permissionType){
        return @"您的相册权限已被限制";
    }
    else if(YBPermissionTypeVido==self.permissionType){
        return @"您的相机权限已被限制";
    }
    else if(YBPermissionTypeLocation==self.permissionType){
        return @"您的定位权限已被限制";
    }
    return @"您的权限已被限制";
}
- (NSString *)subTitleString0{
    if(YBPermissionTypeContact==self.permissionType){
        return @"点击手机设置-隐私-通讯录";
    }
    else if(YBPermissionTypePhoto==self.permissionType){
        return @"点击手机设置-隐私-照片";
    }
    else if(YBPermissionTypeVido==self.permissionType){
        return @"点击手机设置-隐私-相机";
    }
    else if(YBPermissionTypeLocation==self.permissionType){
        return @"点击手机设置-隐私-定位服务";
    }
    return @"点击手机设置-隐私";
}
- (void)setRemindAttributedText{
    //设置特效字体
    NSString *totalString = @"";
    NSString *title0 = [self subTitleString0];
    NSString *title1 = [NSString stringWithFormat:@"-%@-开启访问功能即可",self.appName];
    totalString = [NSString stringWithFormat:@"%@\n%@",title0,title1];
    NSMutableAttributedString *atrTitle = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:[NSNumber adaptToHeight:14]],NSFontAttributeName,
                              [UIColor hexColor:@"333333"],NSForegroundColorAttributeName,nil];
    [atrTitle setAttributes:attrDict range:NSMakeRange(0, totalString.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [atrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    self.detailLabel.attributedText = atrTitle;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)setPermissionType:(YBPermissionType)permissionType{
    _permissionType = permissionType;
    self.titleLabel.text = [self titleLabelString];
    [self setRemindAttributedText];
}
@end

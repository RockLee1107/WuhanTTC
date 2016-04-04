//
//  LXPasswordView.h
//  
//
//  Created by HuangXiuJie on 16/3/30.
//
//

#import <UIKit/UIKit.h>

@interface LXPasswordView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) BOOL isShow;
@end

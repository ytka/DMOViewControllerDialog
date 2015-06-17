//
//  UIViewController+DMODialog.h
//  domoTodo2
//
//  Created by yutaka on 2015/01/13.
//  Copyright (c) 2015年 domo apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (DMODialog)
+ (UIViewController*) dmo_topController;
+ (void)dmo_presentConfirmDialogWithTitle:(NSString*)title message:(NSString*)message confirmHandler:(void (^)(UIAlertAction *action))confirmHandler;
+ (void)dmo_presentErrorDialog:(NSError*)error;

- (void)dmo_presentMessageDialogWithTitle:(NSString*)title message:(NSString*)message
                               okTitle:(NSString*)okTitle okHandler:(void (^)(UIAlertAction *action))okHandler
                             canelHandler:(void (^)(UIAlertAction *action))cancelHandler;
- (void)dmo_presentTextFieldDialogWithTitle:(NSString*)title message:(NSString*)message
                                    okTitle:(NSString*)okTitle okHandler:(void (^)(UIAlertAction *action, UITextField *textField))okHandler
                               canelHandler:(void (^)(UIAlertAction *action))cancelHandler
              textFieldConfigurationHandler:(void (^)(UITextField *textField))textFieldConfigurationHandler;
- (void)dmo_presentConfirmDialogWithTitle:(NSString*)title message:(NSString*)message confirmHandler:(void (^)(UIAlertAction *action))confirmHandler;
- (void)dmo_presentErrorDialog:(NSError*)error;


- (void)dmo_showActionSheetWithTitle:(NSString*)title message:(NSString*)message
                destructiveTitle:(NSString*)destructiveTitle destructiveHandler:(void (^)(UIAlertAction *action))destructiveHandler;
- (void)dmo_showActionSheetWithTitle:(NSString*)title message:(NSString*)message
                         otherTitles:(NSArray*)otherTitles othersHandler:(void (^)(NSUInteger index))othersHandler;
@end

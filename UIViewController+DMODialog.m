//
//  UIViewController+DMODialog.m
//  domoTodo2
//
//  Created by yutaka on 2015/01/13.
//  Copyright (c) 2015年 domo apps. All rights reserved.
//

#import "UIViewController+DMODialog.h"


@implementation UIViewController (DMODialog)


+ (UIViewController*) dmo_topController {
    // 最前面のViewControllerを取得
    UIViewController *topController = [[UIApplication sharedApplication].delegate window].rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}


#pragma mark - Alert
+ (void)dmo_presentConfirmDialogWithTitle:(NSString*)title message:(NSString*)message confirmHandler:(void (^)(UIAlertAction *action))confirmHandler {
    [[self dmo_topController] dmo_presentConfirmDialogWithTitle:title message:message confirmHandler:confirmHandler];
}

+ (void)dmo_presentErrorDialog:(NSError*)error {
    [[self dmo_topController] dmo_presentErrorDialog:error];
}


- (UIAlertController*)dmo_baseAlertControllerWithTitle:(NSString*)title message:(NSString*)message
                                      canelHandler:(void (^)(UIAlertAction *action))cancelHandler {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:cancelHandler
                                   ];
    [alert addAction:cancelAction];
    return alert;
}

- (void)dmo_presentMessageDialogWithTitle:(NSString*)title message:(NSString*)message
                               okTitle:(NSString*)okTitle okHandler:(void (^)(UIAlertAction *action))okHandler
                          canelHandler:(void (^)(UIAlertAction *action))cancelHandler {

    UIAlertController* alert = [self dmo_baseAlertControllerWithTitle:title message:message canelHandler:cancelHandler];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:okHandler];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)dmo_presentConfirmDialogWithTitle:(NSString*)title message:(NSString*)message confirmHandler:(void (^)(UIAlertAction *action))confirmHandler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:confirmHandler];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)dmo_presentErrorDialog:(NSError*)error {
    if (!error)  return;

    //    DLog(@"error: %@, info:%@", error, error.localizedDescription);

    NSString* title = nil;
    NSString* detail = nil;

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];
    if (underlyingError) {
        error = underlyingError;
    }

    NSMutableString* details = [NSMutableString new];
    if (error.localizedDescription) {
        title = error.localizedDescription;
    }
    if (error.localizedFailureReason) {
        [details appendFormat:@"%@\n", error.localizedFailureReason];
    }
    if (error.localizedRecoverySuggestion) {
        [details appendFormat:@"%@\n", error.localizedRecoverySuggestion];
    }
    [details appendFormat:@"\n%@: %ld", error.domain, (long)error.code];
    detail = details;

    [self dmo_presentConfirmDialogWithTitle:title message:detail confirmHandler:nil];
}

- (void)dmo_presentTextFieldDialogWithTitle:(NSString*)title message:(NSString*)message
                                 okTitle:(NSString*)okTitle okHandler:(void (^)(UIAlertAction *action, UITextField *textField))okHandler
                            canelHandler:(void (^)(UIAlertAction *action))cancelHandler
           textFieldConfigurationHandler:(void (^)(UITextField *textField))textFieldConfigurationHandler {

    UIAlertController* alert = [self dmo_baseAlertControllerWithTitle:title message:message canelHandler:cancelHandler];
    [alert addTextFieldWithConfigurationHandler:textFieldConfigurationHandler];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction* action) {
                                                         okHandler(action, alert.textFields.firstObject);
                                                     }
                               ];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - ActionSheet
- (void)dmo_showActionSheetWithTitle:(NSString*)title message:(NSString*)message
                destructiveTitle:(NSString*)destructiveTitle destructiveHandler:(void (^)(UIAlertAction *action))destructiveHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"DTCancel",nil) style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        destructiveHandler(action);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dmo_showActionSheetWithTitle:(NSString*)title message:(NSString*)message
                    otherTitles:(NSArray*)otherTitles othersHandler:(void (^)(NSUInteger index))othersHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"DTCancel",nil) style:UIAlertActionStyleCancel handler:nil]];
    [otherTitles enumerateObjectsUsingBlock:^(NSString* title, NSUInteger index, BOOL *stop) {
        [alertController addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            othersHandler(index);
        }]];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

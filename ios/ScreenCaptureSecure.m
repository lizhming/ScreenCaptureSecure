#import "ScreenCaptureSecure.h"


@implementation ScreenCaptureSecure

id<NSObject> screenCaptureObserver;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}
RCT_EXPORT_METHOD(enableSecure)
{
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    screenCaptureObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                    object:nil
                                                    queue:mainQueue
                                                usingBlock:^(NSNotification *note) {
                                                    // executes after screenshot
                                                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"주의"
                                                                                message:@"작품을 캡쳐한 스크린샷을 온라인, 오프라인에 무단으로 공유 및 배포할 경우 법적인 제재를 받을 수 있습니다."
                                                                                preferredStyle:UIAlertControllerStyleAlert];

                                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {}];

                                                    [alert addAction:defaultAction];
                                                    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                                                    if([rootViewController isKindOfClass:[UINavigationController class]])
                                                    {
                                                        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
                                                    }
                                                    if([rootViewController isKindOfClass:[UITabBarController class]])
                                                    {
                                                        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
                                                    }

                                                    [rootViewController presentViewController:alert animated:YES completion:nil];
                                                }];
}

RCT_EXPORT_METHOD(disableSecure)
{
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    if (screenCaptureObserver != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver: screenCaptureObserver];
    }
    screenCaptureObserver = nil;
}
@end


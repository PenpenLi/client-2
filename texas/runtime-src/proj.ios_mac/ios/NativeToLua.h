#import <UIKit/UIKit.h>

@interface NativeToLua : NSObject <UIAlertViewDelegate>{
    UIAlertView* alertView_;
}

+ (NativeToLua*) getInstance;
+ (void) showAlertOK:(NSDictionary*) dict;
+ (void) showAlertOKCancel:(NSDictionary*) dict;
+ (void) openURL:(NSDictionary*) dict;
+ (NSString*) getMacAddress;
+ (NSString*) getOpenUDID;
+ (NSString*) getDeviceName;
+ (void) vibrate:(NSDictionary*) dict;

@end

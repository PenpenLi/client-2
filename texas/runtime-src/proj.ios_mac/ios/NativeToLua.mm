
#include "NativeToLua.h"
#include "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#include "openudid/OpenUDIDIOS.h"

#import <AudioToolbox/AudioToolbox.h>

using namespace cocos2d;

@implementation NativeToLua

static NativeToLua* native = nil;
static LUA_FUNCTION okCallback = 0;
static LUA_FUNCTION cancelCallback = 0;

+ (NativeToLua*) getInstance
{
    if (native == nil)
    {
        native =[[NativeToLua alloc] init];
    }
    return native;
}

- (void) showAlertOK_Title:(NSString*)title ok:(NSString*) okText message:(NSString*) message
{
    alertView_ = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:okText otherButtonTitles:nil, nil];
    [alertView_ show];
    [alertView_ release];
}

- (void) showAlertOKCancel_Title:(NSString*)title ok:(NSString*) okText cancel:(NSString*)cancelText message:(NSString*) message
{
    alertView_ = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:okText otherButtonTitles:cancelText, nil];
    [alertView_ show];
    [alertView_ release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex--------:%ld", buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"okCallback111:%d", okCallback);
        if(okCallback)
        {
            LuaObjcBridge::pushLuaFunctionById(okCallback);
            LuaObjcBridge::getStack()->executeFunction(0);
            LuaObjcBridge::releaseLuaFunctionById(okCallback);
        }
    }else if(buttonIndex == 1)
    {
        if(cancelCallback)
        {
            LuaObjcBridge::pushLuaFunctionById(cancelCallback);
            LuaObjcBridge::getStack()->executeFunction(0);
            LuaObjcBridge::releaseLuaFunctionById(cancelCallback);
        }
    }
    alertView_ = nil;
}

+ (void) showAlertOK:(NSDictionary *)dict
{
    NSString* title = [dict objectForKey:@"title"];
    NSString* okText = [dict objectForKey:@"okText"];
    NSString* descText = [dict objectForKey:@"descText"];
    okCallback = [[dict objectForKey:@"okCallback"] intValue];
    NSLog(@"okCallback:%d", okCallback);
    [[NativeToLua getInstance] showAlertOK_Title:title ok:okText message:descText];
}

+ (void) showAlertOKCancel:(NSDictionary*) dict
{
    NSString* title = [dict objectForKey:@"title"];
    NSString* okText = [dict objectForKey:@"okText"];
    NSString* cancelText = [dict objectForKey:@"cancelText"];
    NSString* descText = [dict objectForKey:@"descText"];
    okCallback = [[dict objectForKey:@"okCallback"] intValue];
    cancelCallback = [[dict objectForKey:@"cancelCallback"] intValue];
    NSLog(@"okCallback:%d", okCallback);
    NSLog(@"cancelCallback:%d", cancelCallback);
    [[NativeToLua getInstance] showAlertOKCancel_Title:title ok:okText cancel:cancelText message:descText];
}

+ (void) openURL:(NSDictionary*) dict
{
    NSString* url = [dict objectForKey:@"url"];
    if (url == nil || url.length == 0)
    {
        return;
    }
    NSURL *nsurl = [NSURL URLWithString:[NSString stringWithCString:[url UTF8String] encoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:nsurl];
}

+ (NSString*) getMacAddress
{
    return @"device not support !!!";
}

+ (NSString*) getOpenUDID
{
    const char* cudid = [[OpenUDIDIOS value] cStringUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%s", cudid];
}
+ (NSString*) getDeviceName
{
    UIDevice *device = [UIDevice currentDevice];
    const char* dn = [[device name] cStringUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%s", dn];;
}
+ (void) vibrate:(NSDictionary*) dict
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end

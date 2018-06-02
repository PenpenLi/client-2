package org.cocos2dx.utils;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.app.AlertDialog;
import android.content.Intent;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Looper;
import android.os.Vibrator;
import android.telephony.TelephonyManager;
import android.content.DialogInterface;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.content.Context;

/**
 * Created by a on 2018/4/19.
 */

public class NativeToLua {

    static Cocos2dxActivity mContext = null;
    static TelephonyManager mTelephonyManager = null;
    static Vibrator mVibrator = null;

    static AlertDialog mDialog;
    static int mOKCallback;
    static int mCancelCallback;

    public static void init(Cocos2dxActivity context){
        System.out.println("Native To Lua init");
        mContext = context;
        mTelephonyManager = (TelephonyManager) context
                .getSystemService(Context.TELEPHONY_SERVICE);
        mVibrator = (Vibrator) context
                .getSystemService(Context.VIBRATOR_SERVICE);
    }

    public static void showAlertOK(final String title, final String okText, final String descText, final int callback) {
        System.out.println("showAlertOK title:" + title + ",okText:" + okText + ",descText:" + descText + ",callback:" + callback);
        mOKCallback = callback;
        mContext.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mDialog != null) {
                    mDialog.dismiss();
                }

                mDialog = new AlertDialog.Builder(mContext).setCancelable(true)
                        .setTitle(title).setMessage(descText).create();

                DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(final DialogInterface dialog, final int which) {
                        if (mOKCallback != 0) {
                            mContext.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(
                                            mOKCallback, "ok");
                                    Cocos2dxLuaJavaBridge
                                            .releaseLuaFunction(mOKCallback);
                                }
                            });
                            dialog.dismiss();
                            mDialog = null;
                        }
                    }
                };

                mDialog.setButton(okText,listener);
                mDialog.show();
            }
        });
    }

    public static void showAlertOKCancel(final String title, final String okText,
                                         final String cancelText, final String descText,
                                         final int okCallback, final int cancelCallback) {
        System.out.println("showAlertOK title:" + title + ",okText:" + okText + ",cancelText:" + cancelText +
                ",descText:" + descText + ",callback:" + okCallback + ",cancelCallback:" + cancelCallback);
        mOKCallback = okCallback;
        mCancelCallback = cancelCallback;
        mContext.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mDialog != null) {
                    mDialog.dismiss();
                }

                mDialog = new AlertDialog.Builder(mContext).setCancelable(true)
                        .setTitle(title).setMessage(descText).create();

                DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(final DialogInterface dialog, final int which) {

                        if (mOKCallback != 0) {
                            mContext.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    System.out.println("button which:" + which);
                                    if (which == -1) {
                                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(
                                                mOKCallback, "ok");
                                    } else {
                                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(
                                                mCancelCallback, "cancel");
                                    }
                                    Cocos2dxLuaJavaBridge
                                            .releaseLuaFunction(mOKCallback);
                                    Cocos2dxLuaJavaBridge
                                            .releaseLuaFunction(mCancelCallback);
                                }

                            });
                            dialog.dismiss();
                            mDialog = null;
                        }

                    }
                };

                mDialog.setButton(okText,listener);
                mDialog.setButton2(cancelText,listener);
                mDialog.show();
            }
        });
    }

    public static void openURL(String url) {
        if (mContext == null) {
            return;
        }
        Uri uri = Uri.parse(url);
        mContext.startActivity(new Intent(Intent.ACTION_VIEW, uri));
    }

    public static String getMacAddress() {
        WifiManager wifi = (WifiManager) mContext.getApplication().getApplicationContext()
                .getSystemService(Context.WIFI_SERVICE);
        WifiInfo info = wifi.getConnectionInfo();
        if (info == null)
            return null;
        return info.getMacAddress();
    }

    public static String getOpenUDID() {
        String id = null;
        if (mTelephonyManager != null) {
            id = mTelephonyManager.getDeviceId();
        }
        if (id == null) {
            id = getMacAddress();
        }
        if (id == null) {
            id = "";
        }
        return id;
    }

    public static String getDeviceName() {
        return Build.USER;
    }

    public static void vibrate(long time) {
        if (mVibrator == null) {
            return;
        }
        mVibrator.vibrate(time);
    }

    public static void vibrate(long[] pattern, int repeatcount) {
        if (mVibrator == null) {
            return;
        }
        mVibrator.vibrate(pattern, repeatcount);
    }
}

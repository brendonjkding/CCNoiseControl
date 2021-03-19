#import "CCNoiseControl.h"
#import <objc/runtime.h>

@interface BluetoothDevice : NSObject
-(unsigned)listeningMode;
-(BOOL)setListeningMode:(unsigned)arg1 ;
@end
@interface BluetoothManager : NSObject
+(id)sharedInstance;
-(id)connectedDevices;
@end
@interface CAPackage : NSObject
@property (readonly) CALayer * rootLayer; 
+(id)packageWithContentsOfURL:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id*)arg4 ;
@end
@interface MediaControlsExpandableButton : UIControl
@property (nonatomic,retain) NSArray * options;
@end
@interface MediaControlsBluetoothListeningModeButton : MediaControlsExpandableButton
@property (nonatomic,retain) NSSet * availableListeningModes;
@end
@interface MediaControlsExpandableButtonOption : NSObject
@property (nonatomic,retain) NSString * identifier;
@property (nonatomic,retain) NSString * packageName;
@end

@implementation CCNoiseControl{
  UIImage* _noiseImage;
  UIImage* _transImage;
}
- (instancetype)init{
  id ret=[super init];
  
  NSBundle* bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/BluetoothManager.framework"];
  if (!bundle.loaded) [bundle load];

  if(objc_getClass("MediaControlsBluetoothListeningModeButton")){
    NSString *noisePackageName, *transPackageName;
    MediaControlsBluetoothListeningModeButton *button=[objc_getClass("MediaControlsBluetoothListeningModeButton") alloc];
    [button setAvailableListeningModes:[NSSet setWithArray:@[@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation",@"AVOutputDeviceBluetoothListeningModeAudioTransparency"]]];
    for(MediaControlsExpandableButtonOption *option in [button options]){
      if([[option identifier] isEqualToString:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"]){
        noisePackageName=[option packageName];
      }
      if([[option identifier] isEqualToString:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"]){
        transPackageName=[option packageName];
      }
    }
    NSString *pathformat=@"/System/Library/PrivateFrameworks/MediaControls.framework/%@.ca";

    CAPackage* noisePackage=[CAPackage packageWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:pathformat, noisePackageName]] type:@"com.apple.coreanimation-bundle" options:0 error:nil];
    _noiseImage=[self imageFromLayer:[noisePackage rootLayer]];
    _noiseImage=[UIImage imageWithCGImage:_noiseImage.CGImage scale:_noiseImage.scale orientation:UIImageOrientationDownMirrored];

    CAPackage* transPackage=[CAPackage packageWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:pathformat, transPackageName]] type:@"com.apple.coreanimation-bundle" options:0 error:nil];
    _transImage=[self imageFromLayer:[transPackage rootLayer]];
    _transImage=[UIImage imageWithCGImage:_transImage.CGImage scale:_transImage.scale orientation:UIImageOrientationDownMirrored];
  }
  else{
    NSBundle* bundle=[NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/BluetoothSettings.bundle"];
    _noiseImage=[UIImage imageNamed:@"iOS_Settings_NC" inBundle:bundle compatibleWithTraitCollection:0];
    _transImage=[UIImage imageNamed:@"iOS_Settings_Normal" inBundle:bundle compatibleWithTraitCollection:0];
    
    CGFloat scale=2.*(_noiseImage.size.width/35.);
    _noiseImage=[UIImage imageWithCGImage:_noiseImage.CGImage scale:scale orientation:UIImageOrientationUp];
    _transImage=[UIImage imageWithCGImage:_transImage.CGImage scale:scale orientation:UIImageOrientationUp];
  }
  

  return ret;
}
//https://stackoverflow.com/questions/3454356/uiimage-from-calayer-in-ios
- (UIImage *)imageFromLayer:(CALayer *)layer
{
  UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);

  [layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return outputImage;
}

//Return the icon of your module here
- (UIImage *)iconGlyph
{
  return _transImage;
}

- (UIImage *)selectedIconGlyph
{
  return _noiseImage;
}

//Return the color selection color of your module here
- (UIColor *)selectedColor
{
	return [UIColor blueColor];
}

// 2 AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation
// 1 AVOutputDeviceBluetoothListeningModeNormal
// 3 AVOutputDeviceBluetoothListeningModeAudioTransparency
- (BOOL)isSelected
{
  NSArray*connectedDevices=[[objc_getClass("BluetoothManager") sharedInstance] connectedDevices];
  if(![connectedDevices count]) return NO;

  return [connectedDevices[0] listeningMode]==2;
}

- (void)setSelected:(BOOL)selected
{
  NSArray*connectedDevices=[[objc_getClass("BluetoothManager") sharedInstance] connectedDevices];
  if(![connectedDevices count]) return;

  unsigned listeningMode=selected?2:3;
  BOOL success=[connectedDevices[0] setListeningMode:listeningMode];
  if(!success) return;

	_selected = selected;

  [super refreshState];

}

@end

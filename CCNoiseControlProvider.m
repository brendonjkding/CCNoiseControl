#import "CCNoiseControlProvider.h"
#import "CCNoiseControl.h"
#import "CAPackage.h"
#import <ControlCenterUIKit/CCUICAPackageDescription.h>
#import <objc/runtime.h>

@implementation CCNoiseControlProvider

- (instancetype)init
{
  self = [super init];
  _moduleInstancesByIdentifier = [NSMutableDictionary new];
  return self;
}

- (NSUInteger)numberOfProvidedModules
{
  return 1;
}

- (NSString*)identifierForModuleAtIndex:(NSUInteger)index
{
  if(index==0){
    return @"com.brend0n.ccnoisecontrol";
  }
  else{
    return @"";
  }
}

- (id)moduleInstanceForModuleIdentifier:(NSString*)identifier
{
  id module = [_moduleInstancesByIdentifier objectForKey:identifier];
  if(!module)
  {
    if([identifier isEqualToString:@"com.brend0n.ccnoisecontrol"]){
      module = [[CCNoiseControl alloc] init];  
    }
    [_moduleInstancesByIdentifier setObject:module forKey:identifier];
  }

  return module;
}

- (NSString*)displayNameForModuleIdentifier:(NSString*)identifier
{
  if([identifier isEqualToString:@"com.brend0n.ccnoisecontrol"]){
    return @"CCNoiseControl(NC/Trans)";
  }
  else{
    return @"";
  }
}

- (UIImage*)settingsIconForModuleIdentifier:(NSString*)identifier
{
  CCUICAPackageDescription *description = [objc_getClass("CCUICAPackageDescription") descriptionForPackageNamed:@"CCNoiseControlIcon" inBundle:[NSBundle bundleForClass:[self class]]];
  CAPackage* package = [CAPackage packageWithContentsOfURL:[description packageURL] type:@"com.apple.coreanimation-bundle" options:0 error:nil];
  return [self imageFromLayer:[package rootLayer] flip:1];
}

//https://stackoverflow.com/questions/3454356/uiimage-from-calayer-in-ios
//https://stackoverflow.com/questions/1135631/vertical-flip-of-cgcontext
- (UIImage *)imageFromLayer:(CALayer *)layer flip:(BOOL)flip
{
  UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if(flip){
    CGAffineTransform flipVertical = CGAffineTransformMake(
        1, 0, 0, -1, 0, layer.frame.size.height
    );
    CGContextConcatCTM(context, flipVertical);
  }
  [layer renderInContext:context];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

@end
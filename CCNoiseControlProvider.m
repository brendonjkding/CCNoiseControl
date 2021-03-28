#import "CCNoiseControlProvider.h"
#import "CCNoiseControl.h"

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

@end
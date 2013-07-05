#import "UIDevice+Family.h"


#pragma mark Class Definition

@implementation UIDevice (Family)


#pragma mark - Public Methods

+ (NSString *)familyName
{
	UIDevice *currentDevice = [self currentDevice];
	
	NSString *familyName = [currentDevice familyName];
	
	return familyName;
}

- (NSString *)familyName
{
	NSString *familyName = nil;
	
	switch ([self userInterfaceIdiom])
	{
		case UIUserInterfaceIdiomPad:
		{
			familyName = @"iPad";
			
			break;
		}
		
		default:
		{
			familyName = @"iPhone";
			
			break;
		}
	}
	
	return familyName;
}


@end
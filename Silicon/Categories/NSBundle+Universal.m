#import "NSBundle+Universal.h"
#import "UIDevice+Family.h"


#pragma mark Class Definition

@implementation NSBundle (Universal)


#pragma mark - Public Methods

- (NSString *)universalNibNameForNibName: (NSString *)nibName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Determine the family name of the device the application is being run on.
	NSString *familyName = [UIDevice familyName];
	
	// Check if the nib for the current device family exists.
	NSString *universalNibName = [NSString stringWithFormat: @"%@_%@", 
		nibName, 
		familyName];
	
	NSString *nibPath = [self pathForResource: universalNibName 
		ofType: @"nib"];
	
	if ([fileManager fileExistsAtPath: nibPath] == NO)
	{
		// If the device family nib does not exist check if the default nib exists.
		universalNibName = nibName;
		
		nibPath = [self pathForResource: universalNibName 
			ofType: @"nib"];
		
		if ([fileManager fileExistsAtPath: nibPath] == NO)
		{
			// If the default nib does not exist check if the iPhone nib exists.
			universalNibName = [NSString stringWithFormat: @"%@_iPhone", 
				nibName];
			
			nibPath = [self pathForResource: universalNibName 
				ofType: @"nib"];
			
			if ([fileManager fileExistsAtPath: nibPath] == NO)
			{
				// NOTE: If this point is reached then no nibs exist for the nib name.
				universalNibName = nil;
			}
		}
	}
	
	return universalNibName;
}


@end
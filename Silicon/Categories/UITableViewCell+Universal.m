#import "UITableViewCell+Universal.h"
#import "NSBundle+Universal.h"


#pragma mark Class Definition

@implementation UITableViewCell (Universal)


#pragma mark - Public Methods

+ (instancetype)universalCellForNibName: (NSString *)nibName 
	bundle: (NSBundle *)bundle
{
	id cell = nil;
	
	// Determine the universal nib name of the nib.
	NSString *universalNibName = [bundle universalNibNameForNibName: nibName];
	
	// If it does not exist create a cache of all the nibs
	static NSCache *nibCache = nil;
	if (nibCache == nil)
		nibCache = [[NSCache alloc] 
			init];
	
	// Load the cached nib if it exists.
	UINib *nib = [nibCache objectForKey: universalNibName];
	
	// If the nib has not been cached read it from disk and cache it.
	if (nib == nil)
	{
		nib = [UINib nibWithNibName: universalNibName 
			bundle: bundle];
		
		[nibCache setObject: nib 
			forKey: universalNibName];
	}
	
	// Unarchive the contents of the nib.
	NSArray *nibContents = [nib instantiateWithOwner: self 
		options: nil];
	
	// Iterate through the top level objects of the nib looking for an object that matches the current class.
	for (id topLevelObject in nibContents)
	{
		if ([topLevelObject isKindOfClass: [self class]] == YES)
		{
			cell = topLevelObject;
			
			break;
		}
	}
	
	return cell;
}

+ (instancetype)universalCellForNibName: (NSString *)nibName
{
	NSBundle *mainBundle = [NSBundle mainBundle];
	
	id cell = [self universalCellForNibName: nibName 
		bundle: mainBundle];
	
	return cell;
}


@end
#import "FDViewController.h"
#import "NSBundle+Universal.h"
#import "UIDevice+Family.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDViewController ()


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDViewController


#pragma mark - Properties


#pragma mark - Constructors

- (id)initWithUniversalNibName: (NSString *)nibName
{
	NSBundle *mainBundle = [NSBundle mainBundle];
	
	NSString *universalNibName = [mainBundle universalNibNameForNibName: nibName];
	
	if ((self = [self initWithNibName: universalNibName 
		bundle: mainBundle]) == nil)
	{
		return nil;
	}
	
	return self;
}


#pragma mark - Destructor

- (void)dealloc 
{
	// nil out delegates of any instance variables.
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

+ (id)allocWithZone: (NSZone *)zone
{
	// Check if a class for the current device family exists.
	NSString *familyClassName = [NSString stringWithFormat: @"%@_%@", 
		NSStringFromClass(self), 
		[UIDevice familyName]];
	
	Class familyClass = NSClassFromString(familyClassName);
	
	// If a class for the current device family exists allocate an instance of it otherwise call super.
	if (familyClass != nil)
	{
		return [familyClass allocWithZone: zone];
	}
	else
	{
		return [super allocWithZone: zone];
	}
}


#pragma mark - Private Methods


@end
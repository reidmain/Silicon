#import "FDRootViewController_iPhone.h"


#pragma mark Class Extension

@interface FDRootViewController_iPhone ()

- (void)_initializeRootViewControlleriPhone;

@end


#pragma mark - Class Definition

@implementation FDRootViewController_iPhone


#pragma mark - Constructors

- (id)initWithNibName: (NSString *)nibName 
    bundle: (NSBundle *)bundle
{
	// Abort if base initializer fails.
	if ((self = [super initWithNibName: nibName 
        bundle: bundle]) == nil)
	{
		return nil;
	}
	
	// Initialize view.
	[self _initializeRootViewControlleriPhone];
	
	// Return initialized instance.
	return self;
}

- (id)initWithCoder: (NSCoder *)coder
{
	// Abort if base initializer fails.
	if ((self = [super initWithCoder: coder]) == nil)
	{
		return nil;
	}
	
	// Initialize view.
	[self _initializeRootViewControlleriPhone];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Private Methods

- (void)_initializeRootViewControlleriPhone
{
	// Set the controller's title.
	self.title = @"iPhone";
}


@end
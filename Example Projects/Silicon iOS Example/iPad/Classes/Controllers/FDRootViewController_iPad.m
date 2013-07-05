#import "FDRootViewController_iPad.h"


#pragma mark Class Extension

@interface FDRootViewController_iPad ()

- (void)_initializeRootViewControlleriPad;

@end


#pragma mark - Class Definition

@implementation FDRootViewController_iPad


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
	[self _initializeRootViewControlleriPad];
	
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
	[self _initializeRootViewControlleriPad];
	
	// Return initialized instance.
	return self;
}

#pragma mark - Private Methods

- (void)_initializeRootViewControlleriPad
{
	// Set the controller's title.
	self.title = @"iPad";
}


@end
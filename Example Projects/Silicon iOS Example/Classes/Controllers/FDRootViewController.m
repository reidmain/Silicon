#import "FDRootViewController.h"


#pragma mark Class Definition

@implementation FDRootViewController


#pragma mark - Overridden Methods

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad
{
	// Call base implementation.
	[super viewDidLoad];
	
	// Set the background colour of the view.
	self.view.backgroundColor = [UIColor orangeColor];
}


@end
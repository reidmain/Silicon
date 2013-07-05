#import "AppDelegate.h"
#import "FDRootViewController.h"


#pragma mark Class Definition

@implementation AppDelegate
{
	@private __strong UIWindow *_mainWindow;
}


#pragma mark - UIApplicationDelegate Methods

- (BOOL)application: (UIApplication *)application 
	didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
	// Create the main window.
	UIScreen *mainScreen = [UIScreen mainScreen];
	
	_mainWindow = [[UIWindow alloc] 
		initWithFrame: mainScreen.bounds];
	
	_mainWindow.backgroundColor = [UIColor blackColor];
	
	// Create the root view controller and assign it to the window.
	FDRootViewController *rootViewController = [[FDRootViewController alloc] 
		initWithUniversalNibName: @"FDRootView"];
	
	UINavigationController *navigationController = [[UINavigationController alloc] 
		initWithRootViewController: rootViewController];
	
	_mainWindow.rootViewController = navigationController;
	
	// Show the main window.
	[_mainWindow makeKeyAndVisible];
	
	// Indicate success.
	return YES;
}


#pragma mark - Private Methods


@end
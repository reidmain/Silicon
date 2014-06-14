#import "FDViewController.h"
#import "FDScrollingTabBar.h"


#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface FDScrollingTabBarController : FDViewController<
	UIScrollViewDelegate, 
	FDScrollingTabBarDelegate>


#pragma mark - Properties

@property (nonatomic, readonly) FDScrollingTabBar *scrollingTabBar;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;


#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods


@end
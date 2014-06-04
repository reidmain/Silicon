#import "FDScrollingTabBarController.h"
#import <FDFoundationKit/NSArray+Accessing.h>


#pragma mark Constants


#pragma mark - Class Extension

@interface FDScrollingTabBarController ()

- (void)_initializeScrollingTabBarController;

@end


#pragma mark - Class Definition

@implementation FDScrollingTabBarController
{
	@private __strong UIScrollView *_scrollView;
}


#pragma mark - Properties

- (void)setViewControllers: (NSArray *)viewControllers
{
	if (_viewControllers != viewControllers)
	{
		// Set the view controllers.
		_viewControllers = viewControllers;
		
		// Set the content size of the scroll view to be large enough for all view controllers.
		_scrollView.contentSize = CGSizeMake([_viewControllers count] * _scrollView.frame.size.width, 0.0f);
		
		[self _tilePages];
		
		// Attempt to select the previously selected view controller.
		UIViewController *previouslySelectedViewController = _selectedViewController;
		self.selectedIndex = [_viewControllers indexOfObject: previouslySelectedViewController];
	}
}

- (void)setSelectedViewController: (UIViewController *)selectedViewController
{
	// Determine the index of the selected view controller and set it.
	NSUInteger selectedIndex = [_viewControllers indexOfObject: selectedViewController];
	
	self.selectedIndex = selectedIndex;
}

- (void)setSelectedIndex: (NSUInteger)selectedIndex
{
	// Determine what view controller maps to the selected index. If there is no mapping default to the first controller.
	UIViewController *viewControllerToSelect = [_viewControllers tryObjectAtIndex: selectedIndex];
	if (viewControllerToSelect == nil)
	{
		selectedIndex = 0;
		viewControllerToSelect = [_viewControllers firstObject];
	}
	
	_selectedViewController = viewControllerToSelect;
	
	_scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width * selectedIndex, 0.0f);
}

- (NSUInteger)selectedIndex
{
	// Determine the index of the selected view controller and return it.
	NSUInteger selectedIndex = [_viewControllers indexOfObject: _selectedViewController];
	
	return selectedIndex;
}


#pragma mark - Constructors

- (instancetype)initWithUniversalNibName: (NSString *)nibName
{
	// Abort if base initializer fails.
	if ((self = [super initWithUniversalNibName: nibName]) == nil)
	{
		return nil;
	}
	
	// Initialize view controller.
	[self _initializeScrollingTabBarController];
	
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
	
	// Initialize view controller.
	[self _initializeScrollingTabBarController];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (void)loadView
{
	// Create the controller's view.
	UIScreen *mainScreen = [UIScreen mainScreen];
	
	self.view = [[UIView alloc] 
		initWithFrame: mainScreen.bounds];
	
	// Set the scroll view to be the same size as the controller's view.
	_scrollView.frame = self.view.bounds;
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth 
		| UIViewAutoresizingFlexibleHeight;
	
	// Add the scroll view to the controller's view.
	[self.view addSubview: _scrollView];
	
	// Set the content size of the scroll view to be large enough for all view controllers.
	_scrollView.contentSize = CGSizeMake([_viewControllers count] * _scrollView.frame.size.width, 0.0f);
	
	[self _tilePages];
}


#pragma mark - Private Methods

- (void)_initializeScrollingTabBarController
{
	// Initialize instance variables.
	_scrollView = [[UIScrollView alloc] 
		initWithFrame: CGRectZero];
	_scrollView.delegate = self;
	
	// Enable paging on the scroll view.
	_scrollView.pagingEnabled = YES;
	
	// Hide all scrolling indicators.
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
}

- (void)_tilePages
{
	// Calculate which view controllers should exist in the scroll view.
	NSInteger firstControllerIndex = floorf(CGRectGetMinX(_scrollView.bounds) / CGRectGetWidth(_scrollView.bounds));
	NSInteger lastControllerIndex = floorf((CGRectGetMaxX(_scrollView.bounds) - 1.0f) / CGRectGetWidth(_scrollView.bounds));
	
	// Ensure the first controller index is not less than zero.
	firstControllerIndex = MAX(firstControllerIndex, 0);
	
	// Ensure the last controller index is not greater than the total number of view controllers.
	lastControllerIndex = MIN(MAX(lastControllerIndex, 0), [_viewControllers count] - 1);
	
	[_viewControllers enumerateObjectsUsingBlock: ^(UIViewController *viewController, NSUInteger index, BOOL *stop)
		{
			if (firstControllerIndex <= index 
				&& index <= lastControllerIndex)
			{
				// Check if the view controller is already in the scroll view.
				if (viewController.view.superview != _scrollView)
				{
					// Position the view controller in the scroll view.
					CGRect viewControllerFrame = self.view.bounds;
					viewControllerFrame.origin.x = _scrollView.bounds.size.width * index;
					viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth 
						| UIViewAutoresizingFlexibleHeight;
					
					viewController.view.frame = viewControllerFrame;
					
					// Add the view controller to the scroll view.
					[self addChildViewController: viewController];
					
					[_scrollView addSubview: viewController.view];
					
					[viewController didMoveToParentViewController: self];
				}
			}
			else
			{
				if (viewController.view.superview == _scrollView)
				{
					// Remove the controller from the scroll view.
					[viewController willMoveToParentViewController: nil];
					
					[viewController.view removeFromSuperview];
					
					[viewController removeFromParentViewController];
				}
			}
		}];
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
	[self _tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSUInteger selectedControllerIndex = floorf(CGRectGetMidX(_scrollView.bounds) / CGRectGetWidth(_scrollView.bounds));
	
	_selectedViewController = [_viewControllers tryObjectAtIndex: selectedControllerIndex];
}


@end
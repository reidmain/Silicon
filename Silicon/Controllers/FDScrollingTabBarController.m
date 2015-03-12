#import "FDScrollingTabBarController.h"
#import <FDFoundationKit/FDFoundationKit.h>
#import "UIViewController+ScrollViewInsets.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDScrollingTabBarController ()

- (void)_initializeScrollingTabBarController;
- (void)_updateScrollViewContentSize;
- (void)_tilePages;

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
		// Remove all existing controllers as child controllers.
		for (UIViewController *viewController in _viewControllers)
		{
			[viewController willMoveToParentViewController: nil];
			
			[viewController.view removeFromSuperview];
			
			[viewController removeFromParentViewController];
		}
		
		// Set the view controllers.
		_viewControllers = viewControllers;
		
		// Add all the new controller as child controllers.
		for (UIViewController *viewController in _viewControllers)
		{
			[self addChildViewController: viewController];
			
			[viewController didMoveToParentViewController: self];
		}
		
		// Set the items on the scrolling tab bar.
		_scrollingTabBar.items = [viewControllers valueForKeyPath: @keypath(_selectedViewController.title)];
		
		// Update the scroll view's content size to ensure it is large enough for all the view controllers.
		[self _updateScrollViewContentSize];
		
		// Attempt to select the previously selected view controller.
		UIViewController *previouslySelectedViewController = _selectedViewController;
		self.selectedIndex = [_viewControllers indexOfObject: previouslySelectedViewController];
		
		// Layout the view in case the size of the scroll tab bar has changed.
		[self.view layoutIfNeeded];
		
		[self _tilePages];
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
	
	// Set the selected view controller.
	_selectedViewController = viewControllerToSelect;
	
	// Set the content offset of the scroll view to ensure the selected view controller is visible.
	_scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width * selectedIndex, 0.0f);
	
	_scrollingTabBar.selectedIndex = selectedIndex;
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
	
	// Update the scroll view's content size to ensure it is large enough for all the view controllers.
	[self _updateScrollViewContentSize];
	
	// Add the scrolling tab bar to the controller's view.
	[self.view addSubview: _scrollingTabBar];
	
	// Size the scrolling tab bar so it is as wide as the controller's view.
	_scrollingTabBar.translatesAutoresizingMaskIntoConstraints = NO;
	
	id topLayoutGuide = self.topLayoutGuide;
	NSDictionary *autoLayoutViews = NSDictionaryOfVariableBindings(
		topLayoutGuide, 
		_scrollingTabBar);
	
	[self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[_scrollingTabBar]-0-|" 
		options: 0 
		metrics: nil 
		views: autoLayoutViews]];
	[self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topLayoutGuide]-0-[_scrollingTabBar]" 
		options: 0 
		metrics: nil 
		views: autoLayoutViews]];
}

- (void)viewDidLayoutSubviews
{
	// Call base implementation.
	[super viewDidLayoutSubviews];
	
	// Update the scroll view's content size to ensure it is large enough for all the view controllers.
	[self _updateScrollViewContentSize];
	
	// Tile the pages and then call layoutSubviews because the tiling of pages could require auto layout to take another pass.
	[self _tilePages];
	
	[self.view layoutSubviews];
}


#pragma mark - Private Methods

- (void)_initializeScrollingTabBarController
{
	// Create the scroll view.
	_scrollView = [[UIScrollView alloc] 
		initWithFrame: CGRectZero];
	_scrollView.delegate = self;
	
	// Enable paging on the scroll view.
	_scrollView.pagingEnabled = YES;
	
	// Hide all scrolling indicators on the scroll view.
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	
	// Create the scrolling tab bar.
	_scrollingTabBar = [FDScrollingTabBar new];
	_scrollingTabBar.delegate = self;
	
	// Prevent the scroll view's insets from being automatically set.
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)_updateScrollViewContentSize
{
	_scrollView.contentSize = CGSizeMake([_viewControllers count] * _scrollView.frame.size.width, 0.0f);
}

- (void)_tilePages
{
	// If the controller's view has not yet been added as a subview there is no point to laying out any of the pages. The superview must exist because only once the superview exists can the content insets be correctly calculated and adjusted.
	if (self.view.superview == nil)
	{
		return;
	}
	
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
				// Position the controller's view in the scroll view.
				CGRect viewControllerFrame = _scrollView.frame;
				viewControllerFrame.origin.x = _scrollView.bounds.size.width * index;
				viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth 
					| UIViewAutoresizingFlexibleHeight;
				
				viewController.view.frame = viewControllerFrame;
				
				// Check if the controller's view is already in the scroll view.
				if (viewController.view.superview != _scrollView)
				{
					// Adjust the controller's scroll view's insets.
					UIEdgeInsets contentInsetAdjustment = UIEdgeInsetsMake(CGRectGetMaxY(_scrollingTabBar.frame), 0.0f, [self bottomLayoutGuide].length, 0.0f);
					[viewController setScrollingTabBarControllerContentInsetAdjustment: contentInsetAdjustment];
					
					// Add the controller's view to the scroll view.
					[_scrollView addSubview: viewController.view];
				}
			}
			else
			{
				if (viewController.view.superview == _scrollView)
				{
					// Remove the adjustment on the controller's scroll view.
					[viewController setScrollingTabBarControllerContentInsetAdjustment: UIEdgeInsetsZero];
					
					// Remove the controller's view from the scroll view.
					[viewController.view removeFromSuperview];
				}
			}
		}];
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
	[self _tilePages];
	
	NSUInteger selectedControllerIndex = floorf(CGRectGetMidX(_scrollView.bounds) / CGRectGetWidth(_scrollView.bounds));
	
	_scrollingTabBar.selectedIndex = selectedControllerIndex;
}

- (void)scrollViewDidEndDecelerating: (UIScrollView *)scrollView
{
	NSUInteger selectedControllerIndex = floorf(CGRectGetMidX(_scrollView.bounds) / CGRectGetWidth(_scrollView.bounds));
	
	_selectedViewController = [_viewControllers tryObjectAtIndex: selectedControllerIndex];
}


#pragma mark - FDScrollingTabBarDelegate Methods

- (void)scrollingTabBar: (FDScrollingTabBar *)scrollingTabBar 
	didSelectItem: (NSString *)item
{
	NSUInteger selectedIndex = [scrollingTabBar.items indexOfObject: item];
	
	self.selectedIndex = selectedIndex;
}


@end
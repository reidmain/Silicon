#import "UIViewController+ScrollViewInsets.h"
#import <objc/runtime.h>


#pragma mark Constants

static void * const _ScrollingTabBarControllerContentInsetAdjustmentKey = (void *)&_ScrollingTabBarControllerContentInsetAdjustmentKey;


#pragma mark - Class Definition

@implementation UIViewController (ScrollViewInsets)


#pragma mark - Public Methods

- (UIScrollView *)adjustableScrollView
{
	UIScrollView *adjustableScrollView = nil;
	
	// First check if the controller's view is a scroll view.
	if ([self.view isKindOfClass: [UIScrollView class]] == YES)
	{
		adjustableScrollView = (UIScrollView *)self.view;
	}
	// Otherwise check if the controller's view's first child is a scroll view.
	else if ([[[self.view subviews] firstObject] isKindOfClass: [UIScrollView class]] == YES)
	{
		adjustableScrollView = (UIScrollView *)[[self.view subviews] firstObject];
	}
	
	return adjustableScrollView;
}

- (void)setScrollingTabBarControllerContentInsetAdjustment: (UIEdgeInsets)scrollingTabBarControllerContentInsetAdjustment
{
	// Locate the scroll view to be adjusted.
	UIScrollView *adjustableScrollView = [self adjustableScrollView];
	
	// If there is no scroll view to adjust return immediately.
	if (adjustableScrollView == nil)
	{
		return;
	}
	
	// Calculate the difference between the stored content inset adjustment and the adjustment being set.
	UIEdgeInsets currentContentInset = self.scrollingTabBarControllerContentInsetAdjustment;
	
	UIEdgeInsets contentInsetToAdd = scrollingTabBarControllerContentInsetAdjustment;
	contentInsetToAdd.top -= currentContentInset.top;
	contentInsetToAdd.bottom -= currentContentInset.bottom;
	
	// Calculate the expected content offset once the content inset has been updated so it can be used later in a hack.
	CGPoint expectedContentOffset = adjustableScrollView.contentOffset;
	expectedContentOffset.y -= contentInsetToAdd.top;
	
	// Update the content insets of the scroll view.
	UIEdgeInsets contentInset = adjustableScrollView.contentInset;
	contentInset.top += contentInsetToAdd.top;
	contentInset.bottom += contentInsetToAdd.bottom;
	
	adjustableScrollView.contentInset = contentInset;
	adjustableScrollView.scrollIndicatorInsets = contentInset;
	
	// HACK: For some reason the content offset does not get set correctly after the insets have been updated. This is a hack to ensure that the content offset is set correctly.
	if (CGPointEqualToPoint(adjustableScrollView.contentOffset, expectedContentOffset) == NO)
	{
		adjustableScrollView.contentOffset = expectedContentOffset;
	}
	
	// Store the adjustment as an associated object so it can be used later.
	NSValue *boxedValue = [NSValue valueWithUIEdgeInsets: scrollingTabBarControllerContentInsetAdjustment];
	
	objc_setAssociatedObject(self, _ScrollingTabBarControllerContentInsetAdjustmentKey, boxedValue, OBJC_ASSOCIATION_COPY);
}

- (UIEdgeInsets)scrollingTabBarControllerContentInsetAdjustment
{
	NSValue *boxedValue = objc_getAssociatedObject(self, _ScrollingTabBarControllerContentInsetAdjustmentKey);
	
	UIEdgeInsets scrollingTabBarControllerContentInsetAdjustment = [boxedValue UIEdgeInsetsValue];
	
	return scrollingTabBarControllerContentInsetAdjustment;
}


@end
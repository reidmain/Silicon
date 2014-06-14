#import "UIViewController+ScrollViewInsets.h"


#pragma mark Class Definition

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

- (void)setAdjustableScrollViewInsets: (UIEdgeInsets)insets
{
	UIScrollView *adjustableScrollView = [self adjustableScrollView];
	
	adjustableScrollView.contentInset = insets;
	adjustableScrollView.scrollIndicatorInsets = insets;
}


@end
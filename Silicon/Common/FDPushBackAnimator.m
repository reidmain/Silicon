#import "FDPushBackAnimator.h"
#import "UIView+Layout.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDPushBackAnimator ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDPushBackAnimator
{
	@private __strong UIView *_overlay;
}


#pragma mark - Properties


#pragma mark - Constructors

- (id)init
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	_overlay = [UIView new];
	_overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth 
		| UIViewAutoresizingFlexibleHeight;
	_overlay.backgroundColor = [UIColor colorWithWhite: 0.0f 
		alpha: 0.5f];
	_overlay.alpha = 0.0f;
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods


#pragma mark - Private Methods


#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext
{
	return 0.5;
}

- (void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext
{
	UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
	UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
	
	if (_presenting == YES)
	{
		// Add the overlay and the from view controller's view to the container view.
		[transitionContext.containerView addSubview: _overlay];
		[transitionContext.containerView addSubview: toViewController.view];
		
		// Ensure the overlay is the same size as the container view.
		_overlay.frame = transitionContext.containerView.bounds;
		
		// Animate the from view controller's view in from the bottom of the screen.
		toViewController.view.yOrigin = transitionContext.containerView.height;
		
		[UIView animateWithDuration: [self transitionDuration: transitionContext] 
			delay: 0.0 
			options: UIViewAnimationOptionCurveEaseInOut 
			animations: ^
				{
					_overlay.alpha = 1.0f;
					
					fromViewController.view.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
					
					toViewController.view.yOrigin = 0.0f;
				} 
			completion: ^(BOOL finished)
				{
					[transitionContext completeTransition: YES];
				}];
	}
	else
	{
		// HACK: For some reason you need to reset the transform of the controller that is behind the controller that was presented. The transform is not persisted.
		toViewController.view.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
		
		// Animate the presented view controller off through the bottom of the screen.
		[UIView animateWithDuration: [self transitionDuration: transitionContext] 
			delay: 0.0 
			options: UIViewAnimationOptionCurveEaseInOut 
			animations: ^
				{
					_overlay.alpha = 0.0f;
					
					fromViewController.view.yOrigin = transitionContext.containerView.height;
					
					toViewController.view.transform = CGAffineTransformIdentity;
				} 
			completion: ^(BOOL finished)
				{
					[transitionContext completeTransition: YES];
				}];
	}
}


@end
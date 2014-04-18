#import "FDViewController.h"
#import "NSBundle+Universal.h"
#import "UIDevice+Family.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDViewController ()

- (void)_initializeViewController;
- (void)_keyboardWillShow: (NSNotification *)notification;
- (void)_keyboardWillHide: (NSNotification *)notification;


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDViewController
{
	@private __strong UIView *_keyboardLayoutGuide;
	@private __strong NSLayoutConstraint *_keyboardTopConstraint;
}


#pragma mark - Properties


#pragma mark - Constructors

- (id)initWithUniversalNibName: (NSString *)nibName
{
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *universalNibName = [mainBundle universalNibNameForNibName: nibName];
	
	// Abort if base initializer fails.
	if ((self = [super initWithNibName: universalNibName 
		bundle: mainBundle]) == nil)
	{
		return nil;
	}
	
	// Initialize view controller.
	[self _initializeViewController];
	
	// Return initialized instance.
	return self;
}

- (id)initWithNibName: (NSString *)nibName 
    bundle: (NSBundle *)bundle
{
	// Abort if base initializer fails.
	if ((self = [self initWithUniversalNibName: nibName]) == nil)
	{
		return nil;
	}
	
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
	[self _initializeViewController];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Destructor

- (void)dealloc 
{
	// nil out delegates of any instance variables.
	
	// Stop listening for keyboard notifications.
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter removeObserver: UIKeyboardWillShowNotification];
	[defaultCenter removeObserver: UIKeyboardWillHideNotification];
}


#pragma mark - Public Methods

- (UIView *)keyboardLayoutGuide
{
	// If the view has not been loaded the guide is not available.
	if ([self isViewLoaded] == NO)
	{
		return nil;
	}
	
	// Create the keyboard layout guide if it has not been created yet.
	if (_keyboardLayoutGuide == nil)
	{
		_keyboardLayoutGuide = [[UIView alloc] 
			initWithFrame: CGRectZero];
		_keyboardLayoutGuide.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview: _keyboardLayoutGuide];
		
		_keyboardTopConstraint = [NSLayoutConstraint constraintWithItem: _keyboardLayoutGuide 
			attribute: NSLayoutAttributeTop 
			relatedBy: NSLayoutRelationEqual 
			toItem: self.view 
			attribute: NSLayoutAttributeTop 
			multiplier: 1.0f 
			constant: self.view.bounds.size.height];
		[self.view addConstraint: _keyboardTopConstraint];
		
		[self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[_keyboardLayoutGuide]-0-|" 
			options: 0 
			metrics: nil 
			views: NSDictionaryOfVariableBindings(_keyboardLayoutGuide)]];
	}
	
	return _keyboardLayoutGuide;
}

- (void)keyboardWillShowWithDuration: (double)duration
{
	// Designed to be overridden by subclasses to notify when the keyboard will show.
}

- (void)keyboardWillHideWithDuration: (double)duration
{
	// Designed to be overridden by subclasses to notify when the keyboard will hide.
}

- (void)dismissKeyboard
{
	UIApplication *sharedApplication = [UIApplication sharedApplication];
	[sharedApplication sendAction: @selector(resignFirstResponder) 
		to: nil 
		from: nil 
		forEvent: nil];
}


#pragma mark - Overridden Methods

+ (id)allocWithZone: (NSZone *)zone
{
	// Check if a class for the current device family exists.
	NSString *familyClassName = [NSString stringWithFormat: @"%@_%@", 
		NSStringFromClass(self), 
		[UIDevice familyName]];
	
	Class familyClass = NSClassFromString(familyClassName);
	
	// If a class for the current device family exists allocate an instance of it otherwise call super.
	if (familyClass != nil)
	{
		return [familyClass allocWithZone: zone];
	}
	else
	{
		return [super allocWithZone: zone];
	}
}


#pragma mark - Private Methods

- (void)_initializeViewController
{
	// Listen for keyboard notifications.
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver: self 
		selector: @selector(_keyboardWillShow:) 
		name: UIKeyboardWillShowNotification 
		object: nil];
    [defaultCenter addObserver: self 
		selector: @selector(_keyboardWillHide:) 
		name: UIKeyboardWillHideNotification 
		object: nil];
}

- (void)_keyboardWillShow: (NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSNumber *duration = [userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey];
	CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	_keyboardTopConstraint.constant = keyboardFrame.origin.y;
	
	[self keyboardWillShowWithDuration: [duration doubleValue]];
}

- (void)_keyboardWillHide: (NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSNumber *duration = [userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey];
	
	_keyboardTopConstraint.constant = self.view.bounds.size.height;
	
	[self keyboardWillHideWithDuration: [duration doubleValue]];
}


@end
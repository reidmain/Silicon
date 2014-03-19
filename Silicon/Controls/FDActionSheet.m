#import "FDActionSheet.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDActionSheet ()

- (NSMutableSet *)_activeActionSheets;
- (void)_show;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDActionSheet
{
    @private __strong UIActionSheet *_actionSheet;
    @private __strong NSString *_cancelButtonTitle;
    @private __strong FDActionSheetPressedBlock _cancelPressedBlock;
    @private __strong FDActionSheetPressedBlock _destructivePressedBlock;
    @private __strong NSMutableArray *_pressedBlocks;
}


#pragma mark - Properties


#pragma mark - Constructors

- (id)initWithTitle: (NSString *)title 
	cancelButtonTitle: (NSString *)cancelButtonTitle 
	cancelPressedBlock: (FDActionSheetPressedBlock)cancelPressedBlock 
	destructiveButtonTitle: (NSString *)destructiveButtonTitle 
	destructivePressedBlock: (FDActionSheetPressedBlock)destructivePressedBlock
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	_actionSheet = [[UIActionSheet alloc] 
		initWithTitle: title 
			delegate: self 
			cancelButtonTitle: nil 
			destructiveButtonTitle: destructiveButtonTitle 
			otherButtonTitles: nil];
	
	_cancelButtonTitle = cancelButtonTitle;
	_cancelPressedBlock = cancelPressedBlock;
	_destructivePressedBlock = destructivePressedBlock;
	_pressedBlocks = [NSMutableArray array];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods

- (void)addButtonWithTitle: (NSString *)buttonTitle 
	pressedBlock: (FDActionSheetPressedBlock)pressedBlock
{
	[_actionSheet addButtonWithTitle: buttonTitle];
	
	[_pressedBlocks addObject: pressedBlock];
}

- (void)showFromToolbar: (UIToolbar *)toolBar
{
	[self _show];
	
	[_actionSheet showFromToolbar: toolBar];
}

- (void)showFromTabBar: (UITabBar *)tabBar
{
	[self _show];
	
	[_actionSheet showFromTabBar: tabBar];
}

- (void)showFromBarButtonItem: (UIBarButtonItem *)barButtonItem 
	animated: (BOOL)animated
{
	[self _show];
	
	[_actionSheet showFromBarButtonItem: barButtonItem 
		animated: animated];
}

- (void)showFromRect: (CGRect)rect 
	inView: (UIView *)view 
	animated: (BOOL)animated
{
	[self _show];
	
	[_actionSheet showFromRect: rect 
		inView: view 
		animated: animated];
}

- (void)showInView: (UIView *)view
{
	[self _show];
	
	[_actionSheet showInView: view];
}

- (void)cancel
{
	NSInteger cancelButtonIndex = [_actionSheet cancelButtonIndex];
    [_actionSheet dismissWithClickedButtonIndex: cancelButtonIndex 
		animated: YES];
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods

- (NSMutableSet *)_activeActionSheets
{
	static NSMutableSet *activeActionSheets = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^
		{
			activeActionSheets = [NSMutableSet set];
		});
	
	return activeActionSheets;
}

- (void)_show
{
	[_actionSheet addButtonWithTitle: _cancelButtonTitle];
	[_actionSheet setCancelButtonIndex: [_actionSheet numberOfButtons] - 1];

	[[self _activeActionSheets] addObject: self];
}


#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet: (UIActionSheet *)actionSheet 
	clickedButtonAtIndex: (NSInteger)buttonIndex
{
	// If the cancel button was pressed call the cancel block.
	if(buttonIndex == [actionSheet cancelButtonIndex])
	{
		if(_cancelPressedBlock != nil)
		{
			_cancelPressedBlock();
		}
	}
	// If the destructive button was pressed call the destructive block
	else if(buttonIndex == [actionSheet destructiveButtonIndex])
	{
		if(_destructivePressedBlock != nil)
		{
			_destructivePressedBlock();
		}
	}
	// Otherwise, call the block for the button that was pressed.
	else
	{
		NSInteger pressedIndex = buttonIndex - ([actionSheet destructiveButtonIndex] + 1);
		FDActionSheetPressedBlock pressedBlock = [_pressedBlocks objectAtIndex: pressedIndex];
		pressedBlock();
	}
	
	// Release all blocks so there is no chance of a block introducing a circular retain on the alert view.
	_cancelPressedBlock = nil;
	_destructivePressedBlock = nil;
	_pressedBlocks = nil;
}

- (void)actionSheet: (UIActionSheet *)actionSheet 
	didDismissWithButtonIndex: (NSInteger)buttonIndex
{
	[[self _activeActionSheets] removeObject: self];
}


@end
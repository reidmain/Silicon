#import "FDScrollingTabBarCell.h"
#import <FDFoundationKit/FDFoundationKit.h>


#pragma mark Constants


#pragma mark - Class Extension

@interface FDScrollingTabBarCell ()

- (void)_initializeScrollingTabBarCell;


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDScrollingTabBarCell
{
	@private __strong UILabel *_label;
}


#pragma mark - Properties

- (void)setText: (NSString *)text
{
	if (FDIsEmpty(text) == YES)
	{
		_label.text = @"{ Missing Title }";
	}
	else
	{
		_label.text = text;
	}
}

- (NSString *)text
{
	return _label.text;
}

- (void)setTextColor: (UIColor *)textColor
{
	_label.textColor = textColor;
}

- (UIColor *)textColor
{
	return _label.textColor;
}

- (void)setHighlightedTextColor: (UIColor *)highlightedTextColor
{
	_label.highlightedTextColor = highlightedTextColor;
}

- (UIColor *)highlightedTextColor
{
	return _label.highlightedTextColor;
}


#pragma mark - Constructors

- (id)initWithFrame: (CGRect)frame
{
	// Abort if base initializer fails.
	if ((self = [super initWithFrame: frame]) == nil)
	{
		return nil;
	}
	
	// Initialize collection view cell.
	[self _initializeScrollingTabBarCell];
	
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
	
	// Initialize collection view cell.
	[self _initializeScrollingTabBarCell];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (void)setHighlighted: (BOOL)highlighted
{
	// Call the base implementation.
	[super setHighlighted: highlighted];
	
	// Configure the collection view cell for the highlighted state.
	_label.font = highlighted ? _highlightedFont : _font;
}

- (void)setSelected: (BOOL)selected
{
	// Call the base implementation.
	[super setSelected: selected];
	
	// Configure the table view cell for the selected state.
	_label.font = selected ? _highlightedFont : _font;
}

- (void)tintColorDidChange
{
//	_label.textColor = [self tintColor];
}


#pragma mark - Private Methods

- (void)_initializeScrollingTabBarCell
{
	// Initialize instance variables.
	_label = [UILabel new];
	_label.textColor = [self tintColor];
	_label.highlightedTextColor = _label.textColor;
	
	_font = [UIFont fontWithName: @"HelveticaNeue-Light" 
		size: 17.0f];
	_highlightedFont = [UIFont fontWithName: @"HelveticaNeue-Medium" 
		size: 17.0f];
	
	_label.font = _font;
	
	// Add the label to the content view and position it.
	[self.contentView addSubview: _label];
	
	_label.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *autoLayoutViews = NSDictionaryOfVariableBindings(_label);
	
	[self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[_label]-0-|" 
		options: 0 
		metrics: nil 
		views: autoLayoutViews]];
	[self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[_label]-0-|" 
		options: 0 
		metrics: nil 
		views: autoLayoutViews]];
}


@end
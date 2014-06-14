#import "FDScrollingTabBar.h"
#import "FDScrollingTabBarCell.h"
#import "UIColor+Creation.h"
#import "UIView+Layout.h"


#pragma mark Constants

static NSString * const CellIdentifier = @"ScrollingTabBarCell";


#pragma mark - Class Extension

@interface FDScrollingTabBar ()

- (void)_initializeScrollingTabBar;


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDScrollingTabBar
{
	@private __strong UICollectionView *_collectionView;
	@private __strong FDScrollingTabBarCell *_templateCell;
}


#pragma mark - Properties

- (void)setItems: (NSArray *)items
{
	if (_items != items)
	{
		_items = items;
		
		self.selectedIndex = 0;
	}
}

- (void)setSelectedIndex: (NSUInteger)selectedIndex
{
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow: selectedIndex 
		inSection: 0];
	if ([_collectionView.indexPathsForSelectedItems firstObject] != indexPath)
	{
		[_collectionView selectItemAtIndexPath: indexPath 
			animated: YES 
			scrollPosition: UICollectionViewScrollPositionLeft];
	}
}

- (NSUInteger)selectedIndex
{
	NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
	
	return selectedIndexPath.row;
}


#pragma mark - Constructors

- (id)initWithFrame: (CGRect)frame
{
	// Abort if base initializer fails.
	if ((self = [super initWithFrame: frame]) == nil)
	{
		return nil;
	}
	
	// Initialize view.
	[self _initializeScrollingTabBar];
	
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
	
	// Initialize view.
	[self _initializeScrollingTabBar];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (void)tintColorDidChange
{
	// Call base implementation.
	[super tintColorDidChange];
	
	// Set the background color of the collection view.
	_collectionView.backgroundColor = [self barTintColor];
}


#pragma mark - Private Methods

- (void)_initializeScrollingTabBar
{
	_font = [UIFont fontWithName: @"HelveticaNeue-Light" 
		size: 17.0f];
	_highlightedFont = [UIFont fontWithName: @"HelveticaNeue-Medium" 
		size: 17.0f];
	// Initialize instance variables.
	_barTintColor = [UIColor whiteColor];
	_separatorColor = [UIColor colorWithHexString: @"D6D6D6" 
		alpha: 1.0f];
	
	// Create the collection view.
	UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
	collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	_collectionView = [[UICollectionView alloc] 
		initWithFrame: CGRectZero 
			collectionViewLayout: collectionViewFlowLayout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	
	// Ensure the collection view always bounces horizontally and displays no scrolling indicators.
	_collectionView.alwaysBounceHorizontal = YES;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.showsVerticalScrollIndicator = NO;
	
	// Register the scroll tab bar cell with the collection view.
	[_collectionView registerClass: [FDScrollingTabBarCell class] 
		forCellWithReuseIdentifier: CellIdentifier];
	
	// Add the collection view to the scrolling tab bar.
	[self addSubview: _collectionView];
	
	// Create a separator view and add it to the scrolling tab bar.
	UIView *separatorView = [UIView new];
	separatorView.backgroundColor = _separatorColor;
	
	[self addSubview: separatorView];
	
	// Position the collection view and the separator view.
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	separatorView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *autoLayoutViews = NSDictionaryOfVariableBindings(
		_collectionView, 
		separatorView);
	
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[_collectionView]-0-|" 
		options: 0 
		metrics: nil 
		views: autoLayoutViews]];
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[separatorView]-0-|" 
		options: 0 
		metrics: nil 
		views: autoLayoutViews]];
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[_collectionView]-0-[separatorView(==0.5)]-0-|" 
		options: 0 
		metrics: nil 
		views: autoLayoutViews]];

}


#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView: (UICollectionView *)collectionView 
	numberOfItemsInSection: (NSInteger)section
{
	NSInteger numberOfItems = [_items count];
	
	return numberOfItems;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView 
	cellForItemAtIndexPath: (NSIndexPath *)indexPath
{
	FDScrollingTabBarCell *scrollingTabBarCell = [collectionView dequeueReusableCellWithReuseIdentifier: CellIdentifier 
		forIndexPath: indexPath];
	
	NSString *item = [_items objectAtIndex: indexPath.row];
	scrollingTabBarCell.text = item;
	scrollingTabBarCell.textColor = [self tintColor];
	scrollingTabBarCell.font = _font;
	scrollingTabBarCell.highlightedFont = _highlightedFont;
	scrollingTabBarCell.highlightedTextColor = _highlightedTextColor;
	
	return scrollingTabBarCell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView: (UICollectionView *)collectionView 
	didSelectItemAtIndexPath: (NSIndexPath *)indexPath
{
	NSString *item = [_items objectAtIndex: indexPath.row];
	
	[self.delegate scrollingTabBar: self 
		didSelectItem: item];
	
	[collectionView scrollToItemAtIndexPath: indexPath 
		atScrollPosition: UICollectionViewScrollPositionLeft 
		animated: YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout Methods

- (CGSize)collectionView: (UICollectionView *)collectionView 
	layout: (UICollectionViewLayout*)collectionViewLayout 
	sizeForItemAtIndexPath: (NSIndexPath *)indexPath
{
	if (_templateCell == nil)
	{
		_templateCell = [FDScrollingTabBarCell new];
		_templateCell.selected = YES;
	}
	
	NSString *item = [_items objectAtIndex: indexPath.row];
	_templateCell.text = item;
	
//	_templateCell.selected = [[collectionView indexPathsForSelectedItems] containsObject: indexPath];
	
	CGSize sizeForItem = [_templateCell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
	sizeForItem.height = collectionView.bounds.size.height;
	
	return sizeForItem;
}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView 
	layout: (UICollectionViewLayout*)collectionViewLayout 
	insetForSectionAtIndex: (NSInteger)section
{
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, collectionView.width - 50.0f);
	
	return edgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	CGFloat minimumInteritemSpacing = 14.0f;
	
	return minimumInteritemSpacing;
}


@end
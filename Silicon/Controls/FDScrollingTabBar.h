@import UIKit;
#import "FDScrollingTabBarDelegate.h"


#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface FDScrollingTabBar : UIView<
	UICollectionViewDataSource, 
	UICollectionViewDelegate>


#pragma mark - Properties

@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy) UIFont *highlightedFont;

@property (nonatomic, copy) UIColor *barTintColor;
@property (nonatomic, copy) UIColor *separatorColor;
@property (nonatomic, copy) UIColor *highlightedTextColor;

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, weak) id<FDScrollingTabBarDelegate> delegate;


#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods


@end
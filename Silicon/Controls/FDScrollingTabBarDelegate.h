#pragma mark Forward Declarations

@class FDScrollingTabBar;


#pragma mark - Protocol

@protocol FDScrollingTabBarDelegate<NSObject>


#pragma mark - Required Methods

@required

- (void)scrollingTabBar: (FDScrollingTabBar *)scrollingTabBar 
	didSelectItem: (NSString *)item;


#pragma mark - Optional Methods

@optional




@end
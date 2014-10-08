@import UIKit;


#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Type Definitions

typedef void (^FDActionSheetPressedBlock)(void);


#pragma mark - Class Interface

@interface FDActionSheet : NSObject<
	UIActionSheetDelegate>


#pragma mark - Properties


#pragma mark - Constructors

- (id)initWithTitle: (NSString *)title 
	cancelButtonTitle: (NSString *)cancelButtonTitle 
	cancelPressedBlock: (FDActionSheetPressedBlock)cancelPressedBlock 
	destructiveButtonTitle: (NSString *)destructiveButtonTitle 
	destructivePressedBlock: (FDActionSheetPressedBlock)destructivePressedBlock;


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (void)addButtonWithTitle: (NSString *)buttonTitle 
	pressedBlock: (FDActionSheetPressedBlock)pressedBlock;

- (void)showFromToolbar: (UIToolbar *)toolBar;
- (void)showFromTabBar: (UITabBar *)tabBar;
- (void)showFromBarButtonItem: (UIBarButtonItem *)barButtonItem 
	animated: (BOOL)animated;
- (void)showFromRect: (CGRect)rect 
	inView: (UIView *)view 
	animated: (BOOL)animated;
- (void)showInView: (UIView *)view;

- (void)cancel;


@end
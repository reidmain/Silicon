#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface FDViewController : UIViewController


#pragma mark - Properties


#pragma mark - Constructors

- (id)initWithUniversalNibName: (NSString *)nibName;


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (UIView *)keyboardLayoutGuide;
- (void)keyboardWillShowWithDuration: (double)duration;
- (void)keyboardWillHideWithDuration: (double)duration;


@end
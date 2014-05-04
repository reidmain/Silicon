#import "FDActionSheet.h"


#pragma mark Class Interface

@interface FDActionSheet (OpenURL)


#pragma mark - Static Methods

+ (FDActionSheet *)actionSheetForURL: (NSURL *)url 
	callbackURL: (NSURL *)callbackURL 
	callbackName: (NSString *)callbackName;


@end
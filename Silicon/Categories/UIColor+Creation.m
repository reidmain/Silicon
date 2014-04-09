#import "UIColor+Creation.h"
#import <FDFoundationKit/FDNullOrEmpty.h>


#pragma mark Class Definition

@implementation UIColor (Creation)


#pragma mark - Public Methods

+ (UIColor *)colorWithHexString: (NSString *)hexString 
	alpha: (CGFloat)alpha
{
	// If the hex string is empty return nil.
	if (FDIsEmpty(hexString) == YES)
	{
		return nil;
	}
	
	// Create a scanner from the hex string.
	NSScanner *scanner = [NSScanner scannerWithString: hexString];
	
	// If the hex string starts with # move the scan location of the scanner past it.
	if ([hexString hasPrefix: @"#"])
	{
		scanner.scanLocation = 1;
	}
	
	// Extract the RGB value from the hex string.
	unsigned int rgbValue = 0;
	[scanner scanHexInt: &rgbValue];
	
	// Break the RGB value into its red, green and blue components.
	CGFloat redComponent = ((rgbValue >> 16) & 0xFF) / 255.0f;
	CGFloat greenComponent = ((rgbValue >> 8) & 0xFF) / 255.0f;
	CGFloat blueComponent = (rgbValue & 0xFF) / 255.0f;
	
	UIColor *color = [self colorWithRed: redComponent 
		green: greenComponent 
		blue: blueComponent 
		alpha: alpha];
	
	return color;
}


@end
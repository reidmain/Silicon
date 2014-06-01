#import "NSDate+RelativeStrings.h"


#pragma mark Constants

#define Second 1
#define Minute (60 * Second)
#define Hour (60 * Minute)
#define Day (24 * Hour)
#define Week (7 * Day)
#define Month (30 * Day)
#define Year (365 * Day)


#pragma mark - Class Definition

@implementation NSDate (RelativeStrings)


#pragma mark - Public Methods

- (NSString *)relativeTimeString
{
	NSString *relativeTimeString = nil;
	
	NSTimeInterval timeIntervalFromSelfToNow = [self timeIntervalSinceNow] * (-1);
	if (timeIntervalFromSelfToNow <= 0)
	{
		relativeTimeString = @"now";
	}
	else if (timeIntervalFromSelfToNow < Minute)
	{
		int secondsSinceNow = timeIntervalFromSelfToNow;
		
		if (secondsSinceNow == 1)
			relativeTimeString = @"1 second ago";
		else
			relativeTimeString = [NSString stringWithFormat: @"%d seconds ago", 
				secondsSinceNow];
	}
	else if (timeIntervalFromSelfToNow < Hour)
	{
		int minutesSinceNow = timeIntervalFromSelfToNow / Minute;
		
		if (minutesSinceNow == 1)
			relativeTimeString = @"1 minute ago";
		else
			relativeTimeString = [NSString stringWithFormat: @"%d minutes ago", 
				minutesSinceNow];
	}
	else if (timeIntervalFromSelfToNow < Day)
	{
		int hoursSinceNow = timeIntervalFromSelfToNow / Hour;
		
		if (hoursSinceNow == 1)
			relativeTimeString = @"1 hour ago";
		else
			relativeTimeString = [NSString stringWithFormat: @"%d hours ago", 
				hoursSinceNow];
	}
	else if (timeIntervalFromSelfToNow < Week)
	{
		int daysSinceNow = timeIntervalFromSelfToNow / Day;
		
		if (daysSinceNow == 1)
			relativeTimeString = @"1 day ago";
		else
			relativeTimeString = [NSString stringWithFormat: @"%d days ago", 
				daysSinceNow];
	}
	else if (timeIntervalFromSelfToNow < Month)
	{
		int weeksSinceNow = timeIntervalFromSelfToNow / Week;
		
		if (weeksSinceNow == 1)
			relativeTimeString = @"1 week ago";
		else
			relativeTimeString = [NSString stringWithFormat: @"%d weeks ago", 
				weeksSinceNow];
	}
	else if (timeIntervalFromSelfToNow < Year)
	{
		int monthsSinceNow = timeIntervalFromSelfToNow / Month;
		
		if (monthsSinceNow == 1)
			relativeTimeString = @"1 month ago";
		else
			relativeTimeString = [NSString stringWithFormat: @"%d months ago",
				 monthsSinceNow];
	}
	else
	{
		int yearsSinceNow = timeIntervalFromSelfToNow / Year;
		
		if (yearsSinceNow == 1)
			relativeTimeString = @"1 year ago";
		else
			relativeTimeString = [NSString stringWithFormat: @"%d years ago", 
				yearsSinceNow];
	}

	return relativeTimeString;
}

- (NSString *)mediumRelativeDateString
{
	NSTimeInterval timeIntervalFromSelfToNow = [self timeIntervalSinceNow] * (-1);

	NSString *relativeDateString = nil;

	if(timeIntervalFromSelfToNow <= 0)
	{
		relativeDateString = @"just now";
	}
	else if(timeIntervalFromSelfToNow < Minute)
	{
		int secondsSinceNow = timeIntervalFromSelfToNow / Second;
		
		relativeDateString = [NSString stringWithFormat: @"%ds ago", secondsSinceNow];
	}
	else if(timeIntervalFromSelfToNow < Hour)
	{
		int minutesSinceNow = timeIntervalFromSelfToNow / Minute;
		
		relativeDateString = [NSString stringWithFormat: @"%dm ago", minutesSinceNow];
	}
	else if(timeIntervalFromSelfToNow < Day)
	{
		int hoursSinceNow = timeIntervalFromSelfToNow / Hour;
		
		relativeDateString = [NSString stringWithFormat: @"%dh ago", hoursSinceNow];
	}
	else if(timeIntervalFromSelfToNow < Month)
	{
		int daysSinceNow = timeIntervalFromSelfToNow / Day;
		
		relativeDateString = [NSString stringWithFormat: @"%dd ago", daysSinceNow];
	}
	else if (timeIntervalFromSelfToNow < Year)
	{
		int monthsSinceNow = timeIntervalFromSelfToNow / Month;
		
		relativeDateString = [NSString stringWithFormat: @"%dmo ago", monthsSinceNow];
	}
	else
	{
		int yearsSinceNow = timeIntervalFromSelfToNow / Year;
		
		relativeDateString = [NSString stringWithFormat: @"%dy ago", yearsSinceNow];
	}
	
	return relativeDateString;
}

- (NSString *)shortRelativeDateString
{
	NSTimeInterval timeIntervalFromSelfToNow = [self timeIntervalSinceNow] * (-1);

	NSString *relativeDateString = nil;

	if(timeIntervalFromSelfToNow <= 0)
	{
		relativeDateString = @"now";
	}
	else if(timeIntervalFromSelfToNow < Minute)
	{
		int secondsSinceNow = timeIntervalFromSelfToNow / Second;
		
		relativeDateString = [NSString stringWithFormat: @"%ds", secondsSinceNow];
	}
	else if(timeIntervalFromSelfToNow < Hour)
	{
		int minutesSinceNow = timeIntervalFromSelfToNow / Minute;
		
		relativeDateString = [NSString stringWithFormat: @"%dm", minutesSinceNow];
	}
	else if(timeIntervalFromSelfToNow < Day)
	{
		int hoursSinceNow = timeIntervalFromSelfToNow / Hour;
		
		relativeDateString = [NSString stringWithFormat: @"%dh", hoursSinceNow];
	}
	else if(timeIntervalFromSelfToNow < Week)
	{
		int daysSinceNow = timeIntervalFromSelfToNow / Day;
		
		relativeDateString = [NSString stringWithFormat: @"%dd", daysSinceNow];
	}
	
	return relativeDateString;
}


@end
#import "FDActionSheet+OpenURL.h"


#pragma mark Constants

static NSString * const URLScheme_GoogleChrome = @"googlechrome-x-callback:";
static NSString * const URLScheme_Twitter = @"twitter:";
static NSString * const URLScheme_Tweetbot = @"tweetbot:";


#pragma mark - Class Definition

@implementation FDActionSheet (OpenURL)


#pragma mark - Public Methods

+ (FDActionSheet *)actionSheetForURL: (NSURL *)url 
	callbackURL: (NSURL *)callbackURL 
	callbackName: (NSString *)callbackName
{
	UIApplication *sharedApplication = [UIApplication sharedApplication];
	
    FDActionSheet *actionSheet = [[FDActionSheet alloc] 
		initWithTitle: [url absoluteString] 
			cancelButtonTitle: @"Cancel" 
			cancelPressedBlock: nil 
			destructiveButtonTitle: nil 
			destructivePressedBlock: nil];
    
    // Default to showing a button that will open the URL in Safari.
    [actionSheet addButtonWithTitle: @"Open with Safari" 
		pressedBlock: ^
			{
				[sharedApplication openURL: url];
			}];
    
    // If the user has Chrome installed show a button that will open the URL in Chrome.
    if([sharedApplication canOpenURL: [NSURL URLWithString: URLScheme_GoogleChrome]] == YES)
    {
        [actionSheet addButtonWithTitle: @"Open with Chrome" 
			pressedBlock: ^
				{
					NSString *chromeURLString = [NSString stringWithFormat: @"%@//x-callback-url/open/?x-source=%@&x-success=%@&create-new-tab&url=%@", 
						URLScheme_GoogleChrome, 
						callbackName, 
						[callbackURL absoluteString], 
						[url absoluteString]];
					NSURL *chromeURL = [NSURL URLWithString: chromeURLString];
					
					[sharedApplication openURL: chromeURL];
				}];
    }
    
    // If the URL is from a Tweet button see if the user has any native Twitter apps installed.
    if([[url host] isEqualToString: @"twitter.com"] && [[url path] isEqualToString: @"/share"])
    {
        // Construct the message to send to the Twitter app.
		NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
		
		NSString *queryString = [url query];
		NSArray *queryStringComponents = [queryString componentsSeparatedByString: @"&"];
		for (NSString *queryStringComponent in queryStringComponents)
		{
			NSArray *pairComponents = [queryStringComponent componentsSeparatedByString: @"="];
			NSString *key = [pairComponents objectAtIndex: 0];
			NSString *value = [pairComponents objectAtIndex: 1];

			[queryParameters setObject: value 
				forKey: key];
		}
        
        NSMutableString *text = [NSMutableString string];
        [text appendString:[queryParameters objectForKey:@"text"]];
        
        NSString *urlAsString = [queryParameters objectForKey:@"url"];
        if(urlAsString != nil)
        {
            [text appendFormat:@" %@", urlAsString];
        }
        
        NSString *viaString = [queryParameters objectForKey:@"via"];
        if(viaString != nil)
        {
            [text appendFormat:@" via @%@", viaString];
        }
        
        // If the Twitter app exists open the tweet in it.
        if([sharedApplication canOpenURL: [NSURL URLWithString: URLScheme_Twitter]] == YES)
        {
            [actionSheet addButtonWithTitle: @"Open with Twitter" 
				pressedBlock: ^
					{
						NSString *twitterURLString = [NSString stringWithFormat: @"%@//post?text=%@", 
							URLScheme_GoogleChrome, 
							text];
						NSURL *twitterURL = [NSURL URLWithString: twitterURLString];
						
						[sharedApplication openURL: twitterURL];
					}];
        }
        
        // If the Tweetbot app exists open the tweet in it.
        if([sharedApplication canOpenURL: [NSURL URLWithString: URLScheme_Tweetbot]] == YES)
        {
            [actionSheet addButtonWithTitle: @"Open with Tweetbot" 
				pressedBlock: ^
					{
						NSString *tweetbotURLString = [NSString stringWithFormat: @"%@///post?text=%@&callback_url=%@", 
							URLScheme_Tweetbot, 
							text, 
							[callbackURL absoluteString]];
						NSURL *tweetbotURL = [NSURL URLWithString: tweetbotURLString];
						
						[sharedApplication openURL: tweetbotURL];
					}];
        }
    }
    
    return actionSheet;
}


@end
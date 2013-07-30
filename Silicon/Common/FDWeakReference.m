#import "FDWeakReference.h"


#pragma mark Class Definition

@implementation FDWeakReference


#pragma mark - Constructors

+ (id)weakReferenceWithObject: (id)object
{
	FDWeakReference *weakReference = [[FDWeakReference alloc] 
		init];
	
	weakReference.referencedObject = object;
	
	return weakReference;
}


#pragma mark - Overridden Methods

- (NSString *)description
{
	NSString *description = [NSString stringWithFormat: @"<FDWeakReference = { Referenced Object: %@ }>", 
		_referencedObject];
	
	return description;
}


@end
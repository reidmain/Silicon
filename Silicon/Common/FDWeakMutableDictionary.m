#import "FDWeakMutableDictionary.h"
#import "FDWeakReference.h"


#pragma mark Class Definition

@implementation FDWeakMutableDictionary
{
	@private __strong NSMutableDictionary *_weakReferences;
}


#pragma mark - Constructors

- (id)init
{
	// Abort if base initializer fails.
	if ((self = [self initWithCapacity: 0]) == nil)
	{
		return nil;
	}
	
	// Return initialized instance.
	return self;
}

- (id)initWithCapacity: (NSUInteger)capacity
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	_weakReferences = [[NSMutableDictionary alloc] 
		initWithCapacity: capacity];
	
	// Return initialized instance.
	return self;
}

- (id)initWithObjects: (NSArray *)objects 
	forKeys: (NSArray *)keys
{
	// Raise exception if the objects and keys arrays do not have the same number of elements.
	NSUInteger numberOfObjects = [objects count];
	
	if (numberOfObjects != [keys count])
	{
		[NSException raise: NSInvalidArgumentException 
			format: @"%s objects and keys arrays must have the same number of elements", 
				__PRETTY_FUNCTION__];
	}
	
	// Abort if base initializer fails.
	if ((self = [self initWithCapacity: numberOfObjects]) == nil)
	{
		return nil;
	}
	
	// Add the objects to the dictionary.
	for(NSUInteger i = 0; i < numberOfObjects; i++)
	{
		id object = [objects objectAtIndex: i];
		id key = [keys objectAtIndex: i];
		
		if(object != nil 
			&& key != nil)
		{
			[self setObject: object 
				forKey: key];
		}
	}
	
	// Return initialized instance.
	return self;
}


#pragma mark - Overridden Methods

- (NSUInteger)count
{
	NSUInteger count = [_weakReferences count];
	
	return count;
}

- (id)objectForKey: (id)key
{
	FDWeakReference *weakReference = [_weakReferences objectForKey: key];
	
	id object = weakReference.referencedObject;
	
	// Remove keys whose objects no longer exist.
    if (object == nil 
		&& key != nil)
	{
		[_weakReferences removeObjectForKey: key];
	}
	
	return object;
}

- (NSEnumerator *)keyEnumerator
{
    // Enumerate over a copy because -objectForKey: modifies the dictionary which could cause an exception.
	NSArray *copiedKeys = [_weakReferences allKeys];
	
	NSEnumerator *keyEnumerator = [copiedKeys objectEnumerator];
	
    return keyEnumerator;
}

- (void)setObject: (id)object 
	forKey: (id<NSCopying>)key
{
	// Wrap the object in a weak reference to prevent it from being retained when it is added to the dictionary.
	FDWeakReference *weakReference = [FDWeakReference weakReferenceWithObject: object];
	
	[_weakReferences setObject: weakReference 
		forKey: key];
}

- (void)removeObjectForKey: (id)key
{
	[_weakReferences removeObjectForKey: key];
}


@end
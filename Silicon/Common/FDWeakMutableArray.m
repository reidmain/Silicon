#import "FDWeakMutableArray.h"
#import <FDFoundationKit/FDWeakReference.h>


#pragma mark Class Definition

@implementation FDWeakMutableArray
{
	@private __strong NSMutableArray *_weakReferences;
}


#pragma mark - Constructors

- (instancetype)init
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	_weakReferences = [NSMutableArray array];
	
	// Return initialized instance.
	return self;
}

- (instancetype)initWithCapacity: (NSUInteger)capacity
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	_weakReferences = [NSMutableArray arrayWithCapacity: capacity];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Overridden Methods

- (NSUInteger)count
{
	NSUInteger count = [_weakReferences count];
	
	return count;
}

- (id)objectAtIndex: (NSUInteger)index
{
	FDWeakReference *weakReference = [_weakReferences objectAtIndex: index];
	
	id object = weakReference.referencedObject;
	
	return object;
}

- (void)insertObject: (id)object 
	atIndex:(NSUInteger)index
{
	// Wrap the object in a weak reference to prevent it from being retained when it is inserted to the array.
	FDWeakReference *weakReference = [FDWeakReference weakReferenceWithObject: object];
	
	[_weakReferences insertObject: weakReference 
		atIndex: index];
}

- (void)addObject: (id)object
{
	// Wrap the object in a weak reference to prevent it from being retained when it is added to the array.
	FDWeakReference *weakReference = [FDWeakReference weakReferenceWithObject: object];
	
	[_weakReferences addObject: weakReference];
}

- (void)removeObjectAtIndex: (NSUInteger)index
{
	[_weakReferences removeObjectAtIndex: index];
}

- (void)removeLastObject
{
	[_weakReferences removeLastObject];
}

- (void)replaceObjectAtIndex: (NSUInteger)index 
	withObject: (id)object
{
	// Wrap the object in a weak reference to prevent it from being retained when it replaces the existing object in the array.
	FDWeakReference *weakReference = [FDWeakReference weakReferenceWithObject: object];
	
	[_weakReferences replaceObjectAtIndex: index 
		withObject: weakReference];
}


@end
#pragma mark Class Interface

@interface FDWeakReference : NSObject


#pragma mark - Properties

@property (nonatomic, weak) id referencedObject;


#pragma mark - Constructors

+ (id)weakReferenceWithObject: (id)object;


@end
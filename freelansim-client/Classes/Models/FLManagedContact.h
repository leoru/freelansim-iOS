//
//  FLManagedContact.h
//  
//
//  Created by CPU124C41 on 27/06/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class FLManagedFreelancer;


@interface FLManagedContact : NSManagedObject

@property (nonatomic, retain) NSString				*type;
@property (nonatomic, retain) NSString				*value;
@property (nonatomic, retain) FLManagedFreelancer	*freelancer;

@end

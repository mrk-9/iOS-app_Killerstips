//
//  KTCategory+CoreDataProperties.h
//  
//
//  Created by Hua Wan on 3/8/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KTCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *categoryId;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END

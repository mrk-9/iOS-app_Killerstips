//
//  KTTips+CoreDataProperties.h
//  
//
//  Created by Hua Wan on 3/8/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KTTips.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTTips (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *tipDescription;
@property (nullable, nonatomic, retain) NSNumber *favourited;
@property (nullable, nonatomic, retain) NSString *tipId;
@property (nullable, nonatomic, retain) NSString *photo;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *pack;
@property (nullable, nonatomic, retain) NSNumber *read;

@end

NS_ASSUME_NONNULL_END

//
//  KTWebService.h
//  KidsArtGallery
//
//  Created by Venus on 4/16/16.
//  Copyright (c) 2016 KidsArtGallery. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//#define kVALUE_SERVERADDRESS        @"http://killertips.herokuapp.com/"
#define kVALUE_SERVERADDRESS        @"http://50.112.29.21"
//#define kVALUE_SERVERADDRESS        @"http://146.185.183.154"

typedef void (^KTWebServiceHandler)(NSError *error, id result);
typedef void (^KGUploadingHandler)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);

@interface KTWebService : NSObject

+ (KTWebService *)sharedInstance;

- (BOOL)canSendRequest;

- (void)termsOfUseWithCompletion:(KTWebServiceHandler)completionHandler;

- (void)signupWithEmail:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname deviceToken:(NSString *)deviceToken completion:(KTWebServiceHandler)completionHandler;

- (void)signupForNewsletterWithEmail:(NSString *)email password:(NSString *)password deviceToken:(NSString *)deviceToken completion:(KTWebServiceHandler)completionHandler;

- (void)signupForNewsletterWithEmail:(NSString *)email name:(NSString *)name company:(NSString *)company completion:(KTWebServiceHandler)completionHandler;

- (void)signupWithFacebook:(NSString *)facebookId email:(NSString *)email token:(NSString *)token firstname:(NSString *)firstname lastname:(NSString *)lastname completion:(KTWebServiceHandler)completionHandler;

- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(KTWebServiceHandler)completionHandler;

- (void)forgotPassword:(NSString *)email completion:(KTWebServiceHandler)completionHandler;

- (void)registerDeviceToken:(NSString *)deviceToken user:(NSString *)token completion:(KTWebServiceHandler)completionHandler;

- (void)logoutWithEmail:(NSString *)email completion:(KTWebServiceHandler)completionHandler;

- (void)loadCategoriesAllWithToken:(NSString *)token completion:(KTWebServiceHandler)completionHandler;

- (void)loadTipsAllWithToken:(NSString *)token completion:(KTWebServiceHandler)completionHandler;

- (void)loadTipsAllWithToken:(NSString *)token completion:(KTWebServiceHandler)completionHandler pageNumber:(NSInteger)pageNumber;

- (void)loadTipsWithToken:(NSString *)token categoryId:(NSString *)categoryId pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler;

- (void)loadTipsWithToken:(NSString *)token packId:(NSString *)packId pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler;

- (void)loadTipsUnreadWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler;

- (void)loadTipsFavouriteWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler;

- (void)loadTipContentWithToken:(NSString *)token tipId:(NSString *)tipId completion:(KTWebServiceHandler)completionHandler;

- (void)loadPurchasedPacksWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler;

- (void)loadPurchasingTipsWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler;

- (void)favourite:(BOOL)favourite tip:(NSString *)tipId token:(NSString *)token completion:(KTWebServiceHandler)completionHandler;

- (void)readTip:(NSString *)tipId token:(NSString *)token completion:(KTWebServiceHandler)completionHandler;

- (void)searchTip:(NSString *)tipKey token:(NSString *)token completion:(KTWebServiceHandler)completionHandler;

- (void)purchasePack:(NSString *)packId token:(NSString *)token completion:(KTWebServiceHandler)completionHandler;

@end

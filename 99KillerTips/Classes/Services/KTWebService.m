//
//  KTWebService.m
//  KidsArtGallery
//
//  Created by Venus on 4/16/16.
//  Copyright (c) 2016 KidsArtGallery. All rights reserved.
//

#import "KTWebService.h"
#import "AFNetworking.h"

@interface KTWebService ()
{
    AFHTTPSessionManager *httpSessionManager;
}

@end

@implementation KTWebService

+ (KTWebService *)sharedInstance
{
    static dispatch_once_t oncePredicate;
    static KTWebService *sharedInstance = nil;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[KTWebService alloc] init];
        [sharedInstance reset];
    });
    
    return sharedInstance;
}

- (void)reset
{
    httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kVALUE_SERVERADDRESS]];
    httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:httpSessionManager.responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"text/html"];
    httpSessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //[KTUtilities showAlert:kTitleForAlert message:@"The Internet connection appears to be offline."];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (BOOL)canSendRequest
{
    return YES;
}

- (void)termsOfUseWithCompletion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{};
    
    [httpSessionManager GET:@"/api/v1/accounts/terms" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)signupWithEmail:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname deviceToken:(NSString *)deviceToken completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"email" : email,
                            @"password" : password,
                            @"first_name" : firstname,
                            @"last_name" : lastname,
                            @"device_token" : deviceToken};
    
    [httpSessionManager POST:@"/api/v1/accounts/create" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)signupForNewsletterWithEmail:(NSString *)email password:(NSString *)password deviceToken:(NSString *)deviceToken completion:(KTWebServiceHandler)completionHandler
{
    completionHandler(nil, nil);
    return;
    NSDictionary *param = @{@"email" : email,
                            @"password" : password,
                            @"device_token" : deviceToken};
    
    [httpSessionManager POST:@"/api/v1/accounts/create" parameters:param progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if (completionHandler == nil) return;
                         if (responseObject[@"status"] == nil)
                             completionHandler(nil, nil);
                         else if ([responseObject[@"status"] boolValue] == NO)
                             completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                         else
                         {
                             NSDictionary * userData = responseObject[@"data"];
                             completionHandler(nil, userData);
                             NSLog(@"Success");
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"%@", error.description);
                         if (completionHandler)
                             completionHandler(error, nil);
                     }];
}

- (void)signupForNewsletterWithEmail:(NSString *)email name:(NSString *)name company:(NSString *)company completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"email" : email,
                            @"name" : name,
                            @"company" : company};
    
    [httpSessionManager POST:@"/api/v1/accounts/create" parameters:param progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if (completionHandler == nil) return;
                         if (responseObject[@"status"] == nil)
                             completionHandler(nil, nil);
                         else if ([responseObject[@"status"] boolValue] == NO)
                             completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                         else
                         {
                             NSDictionary * userData = responseObject[@"data"];
                             completionHandler(nil, userData);
                             NSLog(@"Success");
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"%@", error.description);
                         if (completionHandler)
                             completionHandler(error, nil);
                     }];
}

- (void)signupWithFacebook:(NSString *)facebookId email:(NSString *)email token:(NSString *)token firstname:(NSString *)firstname lastname:(NSString *)lastname completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token,
                            @"email" : email,
                            @"first_name" : firstname,
                            @"last_name" : lastname,
                            @"social" : @"facebook",
                            @"device_token" : @""};
    
    [httpSessionManager POST:@"/api/v1/accounts/social_sign_in" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //[formData appendPartWithFileData:UIImageJPEGRepresentation(photo, 1.0f) name:@"user_photo" fileName:@"postImage" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionHandler == nil) return;
        if (responseObject[@"status"] == nil)
            completionHandler(nil, nil);
        else if ([responseObject[@"status"] boolValue] == NO)
            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
        else
        {
            NSDictionary * userData = responseObject[@"data"];
            completionHandler(nil, userData);
            NSLog(@"Success");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
        if (completionHandler)
            completionHandler(error, nil);
    }];
}

- (void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"email" : email,
                            @"password" : password};
    
    [httpSessionManager POST:@"/api/v1/accounts/sign_in" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)forgotPassword:(NSString *)email completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"email" : email};
    
    [httpSessionManager GET:@"/api/v1/accounts/forgot_password" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)registerDeviceToken:(NSString *)deviceToken user:(NSString *)token completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"device_token" : deviceToken,
                            @"token" : token};
    
    [httpSessionManager POST:@"/api/v1/accounts/set_device" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)logoutWithEmail:(NSString *)email completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"email" : email};
    
    [httpSessionManager GET:@"/api/v1/accounts/destroy" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadCategoriesAllWithToken:(NSString *)token completion:(KTWebServiceHandler)completionHandler;
{
    NSDictionary *param = @{@"token" : token};
    
    [httpSessionManager GET:@"/api/v1/tips/categories" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadTipsAllWithToken:(NSString *)token completion:(KTWebServiceHandler)completionHandler;
{
    [self loadTipsAllWithToken:token completion:completionHandler pageNumber:1];
}

- (void)loadTipsAllWithToken:(NSString *)token completion:(KTWebServiceHandler)completionHandler pageNumber:(NSInteger)pageNumber
{
    NSDictionary *param = @{@"token" : token, @"page_number" : @(pageNumber), @"per_page" : @(100)};
    
    [httpSessionManager GET:@"/api/v1/tips" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadTipsWithToken:(NSString *)token categoryId:(NSString *)categoryId pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"category_id" : categoryId, @"page_number" : @(pageNumber)};
    
    [httpSessionManager GET:@"/api/v1/tips" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadTipsWithToken:(NSString *)token packId:(NSString *)packId pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"pack_id" : packId, @"page_number" : @(pageNumber)};
    
    [httpSessionManager GET:@"/api/v1/tips" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadTipsUnreadWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"unread" : @(YES), @"page_number" : @(pageNumber), @"per_page" : @(TIPS_PERPAGE)};
    
    [httpSessionManager GET:@"/api/v1/tips" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadTipsFavouriteWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"favourite" : @(YES), @"page_number" : @(pageNumber)};
    
    [httpSessionManager GET:@"/api/v1/tips" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadTipContentWithToken:(NSString *)token tipId:(NSString *)tipId completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"tip_id" : tipId};
    
    [httpSessionManager GET:@"/api/v1/tips/tip_content" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadPurchasedPacksWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"page_number" : @(pageNumber)};
    
    [httpSessionManager GET:@"/api/v1/accounts/get_purchased_packs" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)loadPurchasingTipsWithToken:(NSString *)token pageNumber:(int)pageNumber completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"page_number" : @(pageNumber)
                            };
    
    [httpSessionManager GET:@"/api/v1/accounts/get_unpurchased_packs" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)favourite:(BOOL)favourite tip:(NSString *)tipId token:(NSString *)token completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"tip_id" : tipId, @"favourite" : @(favourite)};
    
    [httpSessionManager POST:@"/api/v1/accounts/set_favourite" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)readTip:(NSString *)tipId token:(NSString *)token completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"tip_id" : tipId, @"is_read" : @(YES)};
    
    [httpSessionManager POST:@"/api/v1/accounts/set_read" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)searchTip:(NSString *)tipKey token:(NSString *)token completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"key" : tipKey};
    
    [httpSessionManager GET:@"/api/v1/tips/find" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

- (void)purchasePack:(NSString *)packId token:(NSString *)token completion:(KTWebServiceHandler)completionHandler
{
    NSDictionary *param = @{@"token" : token, @"pack_id" : packId};
    
    [httpSessionManager POST:@"/api/v1/accounts/set_purchase" parameters:param progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completionHandler == nil) return;
                        if (responseObject[@"status"] == nil)
                            completionHandler(nil, nil);
                        else if ([responseObject[@"status"] boolValue] == NO)
                            completionHandler([NSError errorWithDomain:responseObject[@"data"] code:10001 userInfo:nil], nil);
                        else
                        {
                            NSDictionary * userData = responseObject[@"data"];
                            completionHandler(nil, userData);
                            NSLog(@"Success");
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@", error.description);
                        if (completionHandler)
                            completionHandler(error, nil);
                    }];
}

@end

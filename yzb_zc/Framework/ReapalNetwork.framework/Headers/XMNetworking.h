//
//  BANetworking.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMAsyncTask;

@interface XMNetworking : NSObject

/** Authenticate the default client as a user with an email and password.
 *
 * @param email The user's email address
 * @param password The user's password
 * @param completion The completion block to be called once the authentication attempt completes either successfully or with an error.
 *
 * @return The resulting request task.
 */
+ (XMAsyncTask *)authenticateAsUserWithAccount:(NSString *)account password:(NSString *)password;

/** Informs the caller whether the default client is authenticated or not, i.e. has an active OAuth token.
 *
 * @return YES if the default client is authenticated, otherwise NO.
 */
+ (BOOL)isAuthenticated;

/* Configure the default client with a BANetworking authenticate request resolving class.
 *
 * @param authenticatedClass  request userModel resolving class
 * @param apiClass    request userModel API resolving class
 *
 */
+ (void)setupAuthenticatedHandlerClass:(Class)authenticatedClass authenticatedAPIClass:(Class)apiClass;

/* Configure the default client with a BANetworking common parameters class.
 *
 *
 */
+ (void)setupCommonParametersClass:(Class)commonClass;

/*
 * Configure the default client with http header userAgent.
 */
+ (void)setupUserAgent:(NSString *)userAgent;

/**
 *  Configure the default Debug to NO
 *  set the debug request.
 */
+ (void)setDebugEnabled:(BOOL)value;

/** Configure the default client to store the OAuth token in the user Keychain.
 *
 * @param name The Service name to use when storing the token in the keychain.
 */
+ (void)automaticallyStoreTokenInKeychainForServiceWithName:(NSString *)name;

/** Configure the default client to store the OAuth token in the user Keychain. The bundle identifier will be used as the Service name for this Keychain item.
 */
+ (void)automaticallyStoreTokenInKeychainForCurrentApp;

/** Configure the default client to store the OAuth token in the user UserDefaults.
 *
 * @param name The Service name to use when storing the token in the UserDefaults.
 */
+ (void)automaticallyStoreTokenInUserDefaultsForServiceWithName:(NSString *)name;

/** Configure the default client to store the OAuth token in the user UserDefaults. The bundle identifier will be used as the Service name for this UserDefaults item.
 */
+ (void)automaticallyStoreTokenInUserDefaultsForCurrentApp;

@end

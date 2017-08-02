//
//  CSHNetworkingManager.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//看@interface，这是对HTTPRequest请求的类扩展

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  the success block of request
 *
 *  @param statusCode the HTTP status code
 *  @param result     the JSON to model mapping result, which is a model or an array
 */
typedef void (^CSHClientSuccessHandler)(NSInteger statusCode, id result);

/**
 *  the failure block of request
 *
 *  @param statusCode the HTTP status code
 *  @param error      the request error
 */
typedef void (^CSHClientFailureHandler)(NSInteger statusCode, NSError *error);
typedef CSHClientFailureHandler CSHNetworkingFailureHandler;

/**
 *  the success block of image upload request
 *
 *  @param statusCode the HTTP status code
 *  @param imageUrl   uploaded image URL
 */
typedef void (^CSHClientImageUploadSuccessHandler)(NSInteger statusCode, NSURL *imageUrl);

@interface CSHNetworkingManager : NSObject

/**
 *  a fired task should be added in ongoing task set, and removed after task completed; Note that, DO NOT add constructive task, such as like an album, posting comment.
 */
@property (nonatomic, strong) NSMutableSet *ongoingTasks;//集合

@end

@interface CSHNetworkingManager (HTTPRequest)

- (void)csh_GET:(NSString *)URLString
     parameters:(NSDictionary *)parameters
        success:(CSHClientSuccessHandler)success
        failure:(CSHClientFailureHandler)failure;

- (void)csh_POST:(NSString *)URLString
      parameters:(NSDictionary *)parameters
         success:(CSHClientSuccessHandler)success
         failure:(CSHClientFailureHandler)failure;

- (void)csh_PUT:(NSString *)URLString
     parameters:(NSDictionary *)parameters
        success:(CSHClientSuccessHandler)success
        failure:(CSHClientFailureHandler)failure;

- (void)csh_PATCH:(NSString *)URLString
       parameters:(NSDictionary *)parameters
          success:(CSHClientSuccessHandler)success
          failure:(CSHClientFailureHandler)failure;

- (void)csh_DELETE:(NSString *)URLString
        parameters:(NSDictionary *)parameters
           success:(CSHClientSuccessHandler)success
           failure:(CSHClientFailureHandler)failure;

/**
 *  upload an image to sever
 *
 *  @param image              UIImage
 *  @param URLString          the *complete* url string
 *  @param compressionQuality 0.0 to 1.0, and 1.0 is the hightest quality (original image)
 *  @param success            success handler
 *  @param failure            failure handler
 */
- (void)csh_uploadImage:(UIImage *)image
                   path:(NSString *)URLString
     compressionQuality:(CGFloat)compressionQuality
                success:(CSHClientImageUploadSuccessHandler)success
                failure:(CSHClientFailureHandler)failure;

@end

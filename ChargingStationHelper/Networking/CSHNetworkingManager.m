//
//  CSHNetworkingManager.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHNetworkingManager.h"
#import "CSHClient.h"

@implementation CSHNetworkingManager

//属性ongoingTasks 重写getter方法 懒加载
- (NSMutableSet *)ongoingTasks {
    if (!_ongoingTasks) {
        _ongoingTasks = [[NSMutableSet alloc] init];
    }
    return _ongoingTasks;
}

/**
 *  cancel all ongoing tasks while dealloc, commonly `GET` method requests.
 */
- (void)dealloc {
    for (NSURLSessionDataTask *task in _ongoingTasks) {
        [task cancel];
    }
}

@end

@implementation CSHNetworkingManager (HTTPRequest)

#pragma mark - http requests

- (void)csh_GET:(NSString *)URLString
     parameters:(NSDictionary *)parameters
        success:(CSHClientSuccessHandler)success
        failure:(CSHClientFailureHandler)failure {
    
    __weak typeof(self) weakSelf = self;
    
    __block NSURLSessionDataTask *task = [[CSHClient sharedClient] GET:URLString parameters:parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf.ongoingTasks removeObject:task];
        task = nil;
        if (error && failure) {
        // for some cases, such as sever doesn't return valid JSON data, the status code in response.HTTPResponse is not the correct one, try to get it in the error object.
        // reference: https://github.com/AFNetworking/AFNetworking/issues/2410
        failure([weakSelf p_statusCodeFromResponseStatusCode:response.HTTPResponse.statusCode error:error], error);
            return;
        }
        if (success) {
            success(response.HTTPResponse.statusCode, response.result);
        }
    }];
    [self.ongoingTasks addObject:task];
}

- (void)csh_POST:(NSString *)URLString
      parameters:(NSDictionary *)parameters
         success:(CSHClientSuccessHandler)success
         failure:(CSHClientFailureHandler)failure {
    __weak typeof(self) weakSelf = self;
    [[CSHClient sharedClient] POST:URLString parameters:parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error && failure) {
        // for some cases, such as sever doesn't return valid JSON data, the status code in response.HTTPResponse is not the correct one, try to get it in the error object.
        // reference: https://github.com/AFNetworking/AFNetworking/issues/2410
        failure([weakSelf p_statusCodeFromResponseStatusCode:response.HTTPResponse.statusCode error:error], error);
            return;
        }
        if (success) {
            success(response.HTTPResponse.statusCode, response.result);
        }
    }];
}

- (void)csh_PUT:(NSString *)URLString
     parameters:(NSDictionary *)parameters
        success:(CSHClientSuccessHandler)success
        failure:(CSHClientFailureHandler)failure {
    __weak typeof(self) weakSelf = self;
    [[CSHClient sharedClient] PUT:URLString
                       parameters:parameters
                       completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
                           if (error && failure) {
                               // for some cases, such as sever doesn't return valid JSON data, the status code in response.HTTPResponse is not the correct one, try to get it in the error object.
                               // reference: https://github.com/AFNetworking/AFNetworking/issues/2410
                               failure([weakSelf p_statusCodeFromResponseStatusCode:response.HTTPResponse.statusCode error:error], error);
                               return;
                           }
                           if (success) {
                               success(response.HTTPResponse.statusCode, response.result);
                           }
                        }];
}

- (void)csh_PATCH:(NSString *)URLString
       parameters:(NSDictionary *)parameters
          success:(CSHClientSuccessHandler)success
          failure:(CSHClientFailureHandler)failure {
    __weak typeof(self) weakSelf = self;
    [[CSHClient sharedClient] PATCH:URLString
                         parameters:parameters
                         completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
                             if (error && failure) {
                                 // for some cases, such as sever doesn't return valid JSON data, the status code in response.HTTPResponse is not the correct one, try to get it in the error object.
                                 // reference: https://github.com/AFNetworking/AFNetworking/issues/2410
                                 failure([weakSelf p_statusCodeFromResponseStatusCode:response.HTTPResponse.statusCode error:error], error);
                                 return;
                             }
                             if (success) {
                                 success(response.HTTPResponse.statusCode, response.result);
                             }
                          }];
}

- (void)csh_DELETE:(NSString *)URLString
        parameters:(NSDictionary *)parameters
           success:(CSHClientSuccessHandler)success
           failure:(CSHClientFailureHandler)failure {
    __weak typeof(self) weakSelf = self;
    [[CSHClient sharedClient] DELETE:URLString
                          parameters:parameters
                          completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
                              if (error && failure) {
                                  // for some cases, such as sever doesn't return valid JSON data, the status code in response.HTTPResponse is not the correct one, try to get it in the error object.
                                  // reference: https://github.com/AFNetworking/AFNetworking/issues/2410
                                  failure([weakSelf p_statusCodeFromResponseStatusCode:response.HTTPResponse.statusCode error:error], error);
                                  return;
                              }
                              if (success) {
                                  success(response.HTTPResponse.statusCode, response.result);
                              }
                           }];
}

- (void)csh_uploadImage:(UIImage *)image
                   path:(NSString *)URLString
     compressionQuality:(CGFloat)compressionQuality
                success:(CSHClientImageUploadSuccessHandler)success
                failure:(CSHClientFailureHandler)failure {
    // prepare a temporary file to store the multipart request prior to sending it to the server due to an alleged bug in NSURLSessionTask.
    //reference: https://github.com/AFNetworking/AFNetworking/issues/1398
    NSString *tmpFilename = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFilename]];
    
    NSMutableURLRequest *multipartRequest = [[CSHClient sharedClient].requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                                             URLString:URLString
                                                                                                            parameters:nil
                                                                                             constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                                                                 NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
                                                                                                 [formData appendPartWithFileData:imageData
                                                                                                                             name:@"file"
                                                                                                                         fileName:@"image.jpeg"
                                                                                                                         mimeType:@"image/jpeg"];
                                                                                              }
                                                                                                                error:nil];
    
    __weak typeof(CSHClient) *weakClient = [CSHClient sharedClient];
    [[CSHClient sharedClient].requestSerializer requestWithMultipartFormRequest:multipartRequest
                                                    writingStreamContentsToFile:tmpFileUrl
                                                              completionHandler:^(NSError * _Nullable error) {
                                                                  NSProgress *progress = nil;
                                                                  NSURLSessionUploadTask *uploadTask = [weakClient uploadTaskWithRequest:multipartRequest
                                                                                                                                fromFile:tmpFileUrl
                                                                                                                                progress:&progress
                                                                                                                       completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                                                                           [[NSFileManager defaultManager] removeItemAtURL:tmpFileUrl
                                                                                                                                                                     error:nil];
                                                                                                                           NSInteger statusCode = 0;
                                                                                                                           NSURL *imageUrl = nil;
                                                                                                                           if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                                                                                                               statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                                                                                                               imageUrl = [NSURL URLWithString:[((NSHTTPURLResponse *)response).allHeaderFields objectForKey:@"Location"]];
                                                                                                                           }
                                                                                                                           
                                                                                                                           if (error && failure) {
                                                                                                                               failure(statusCode, error);
                                                                                                                           } else if (success) {
                                                                                                                               success(statusCode, imageUrl);
                                                                                                                           }
                                                                                                                       }];
                                                                  [uploadTask resume];
                                                               }];
}

#pragma mark - private methods

- (NSInteger)p_statusCodeFromResponseStatusCode:(NSInteger)statusCode error:(NSError *)error {
    
    // HTTP status code
    BOOL isHTTPStatusCode = statusCode >= 100 && statusCode < 600;
    if (isHTTPStatusCode) {
        return statusCode;
    }
    
    // if response serialization error, get the status code
    NSError *underlyingError = error.userInfo[@"NSUnderlyingError"];
    if (underlyingError) {
        NSHTTPURLResponse *response = underlyingError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
            return response.statusCode;
        }
    }
    
    // if all the case above does not hit, return the original one
    return statusCode;
}


@end

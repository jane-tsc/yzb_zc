//
//  BAAsyncTask.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMAsyncTaskResolver;

typedef void (^XMAsyncTaskCompleteBlock) (id result, NSError *error);
typedef void (^XMAsyncTaskSuccessBlock) (id result);
typedef void (^XMAsyncTaskErrorBlock) (NSError *error);
typedef void (^XMAsyncTaskCancelBlock) (void);
typedef void (^XMAsyncTaskThenBlock) (id result, NSError *error);
typedef void (^XMAsyncTaskProgressBlock) (float progress);
typedef XMAsyncTaskCancelBlock (^XMAsyncTaskResolveBlock) (XMAsyncTaskResolver *resolver);

@interface XMAsyncTask : NSObject

/**
 *  Indicates if the task has completed.
 */
@property (readonly) BOOL completed;

/**
 *  Indicates if the task has succeeded.
 */
@property (readonly) BOOL succeeded;

/**
 *  Indicates if the task has errored.
 */
@property (readonly) BOOL errored;

/**
 *  Create a new task. The given block will be executed immediately and provide the task resolver that
 *  can be used to resolve the task. Typically you would, inside of the block, perform asynchronous work
 *  and call succeedWithResult: or failWithError: on the resolver to indicate that the task should succeed
 *  or fail.
 *
 *  @param block The block used to resolve the task.
 *
 *  @return A new task.
 */
+ (instancetype)taskForBlock:(XMAsyncTaskResolveBlock)block;

/**
 *  Creates a task that is immediately resolved with the provided result.
 *
 *  @param result The result of the task.
 *
 *  @return A resolved task.
 */
+ (instancetype)taskWithResult:(id)result;

/**
 *  Creates a task that immediately sends the provided error.
 *
 *  @param error The error of the failed task.
 *
 *  @return A failed task.
 */
+ (instancetype)taskWithError:(NSError *)error;

/**
 *  Register a completion block to be called when the task succeeds or fails. This block will be executed on the
 *  main queue, but the execution order of registered blocks are not gauranteed.
 *
 *  @param completeBlock A completion block.
 *
 *  @return The task itself.
 */
- (instancetype)onComplete:(XMAsyncTaskCompleteBlock)completeBlock;

/**
 *  Register a block to be called only when the task succeeds. This block will be executed on the
 *  main queue, but the execution order of registered blocks are not gauranteed.
 *
 *  @param successBlock A success block.
 *
 *  @return The task itself.
 */
- (instancetype)onSuccess:(XMAsyncTaskSuccessBlock)successBlock;

/**
 *  Register a block to be called only when the task fails. This block will be executed on the
 *  main queue, but the execution order of registered blocks are not gauranteed.
 *
 *  @param errorBlock A failure block.
 *
 *  @return The task itself.
 */
- (instancetype)onError:(XMAsyncTaskErrorBlock)errorBlock;

/**
 *  Register a success and error block to be called when the task completes. These blocks will be
 *  executed on the main queue, but the execution order of registered blocks are not gauranteed.
 *
 *  @param successBlock A success block.
 *  @param errorBlock A failure block.
 *
 *  @return The task itself.
 */
- (instancetype)onSuccess:(XMAsyncTaskSuccessBlock)successBlock onError:(XMAsyncTaskErrorBlock)errorBlock;

/**
 *  Register a block to be called whenever the task progress is updated. The block is executed on the main thread.
 *
 *  @param progressBlock A progress block.
 *
 *  @return The task itself.
 */
- (instancetype)onProgress:(XMAsyncTaskProgressBlock)progressBlock;

/**
 *  Cancel the task. This will result in the execution of the cancellation block returned from the block
 *  passed to taskForBlock:.
 */
- (void)cancel;

/**
 *  Creates a task that will complete only when all of the tasks provided have completed, or fail immediately
 *  if any of them fails.
 *
 *  @param tasks The tasks required to complete.
 *
 *  @return A new task.
 */
+ (instancetype)when:(NSArray *)tasks;

/**
 *  Use this method to add side effects to the completion of the receiver. This methods returns a new
 *  task where the thenBlock will be executed upon completion if self, and then complete the returned task.
 *  This guarantees that any side effects added by the then: method will be executed before the returned
 *  task completes.
 *
 *  @param thenBlock The block to be executed right before the receiver completes.
 *
 *  @return A new task that will complete when the receiver completes, but after executing the thenBlock.
 */
- (instancetype)then:(XMAsyncTaskThenBlock)thenBlock;

/**
 *  Creates a task that will succeed or fail just like the receiver, but will execute the map block on the
 *  result if the receiver completed successfully.
 *
 *  @param block The block to map the result of the receiver task.
 *
 *  @return A new task.
 */
- (instancetype)map:(id (^)(id result))block;

/**
 *  Creates a new task that will, if the receiver successfully completes, execute the provided block to return
 *  a new task using the result of the receiver task. This is useful for chaining a task that depends on the
 *  result of the receiver task. The returned task will only complete when the chained task has completed, or
 *  if either the receiver task or the chained task fails.
 *
 *  @param block The block to create a new task once the receiver successfully completes.
 *
 *  @return A new task.
 */
- (instancetype)pipe:(XMAsyncTask *(^)(id result))block;

@end

@interface XMAsyncTaskResolver : NSObject

/**
 *  Cause the associated task to complete successfully.
 *
 *  @param result The result, if any, of the task.
 */
- (void)succeedWithResult:(id)result;

/**
 *  Cause the associated task to fail.
 *
 *  @param result The error, if any, of the failed task.
 */
- (void)failWithError:(NSError *)error;

/**
 *  Update the progress of the task.
 *
 *  @param The new progress value of the task.
 */
- (void)notifyProgress:(float)progress;

@end

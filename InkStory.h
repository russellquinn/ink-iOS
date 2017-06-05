//
//  InkStory.h
//  Created by Russell Quinn
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface InkStory : NSObject

@property (strong, nonatomic) JSContext *jsContext;

- (instancetype)initWithStoryJsonFile:(NSString *)filePath;

- (BOOL)canContinue;
- (NSString *)continueStory;
- (NSArray *)currentChoices;
- (void)chooseChoiceIndex:(NSInteger)index;

- (JSValue *)evaluateScriptInContext:(NSString *)jsToRun;

@end

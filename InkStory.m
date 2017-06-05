//
//  InkStory.m
//  Created by Russell Quinn
//

#import "InkStory.h"

@implementation InkStory

- (instancetype)initWithStoryJsonFile:(NSString *)filePath
{
    self = [super init];
    if (self)
    {
        self.jsContext = [[JSContext alloc] init];
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        NSString *pathForInkJSRuntime = [mainBundle pathForResource:@"ink" ofType:@"js"];
        
        if (pathForInkJSRuntime != nil)
        {
            NSString *jsRuntimeScript = [NSString stringWithContentsOfFile:pathForInkJSRuntime
                                                                  encoding:NSUTF8StringEncoding
                                                                     error:NULL];
            
            [self evaluateScriptInContext:jsRuntimeScript];
        }
        else
        {
            NSException *fileException = [NSException
                                        exceptionWithName:@"FileNotFoundException"
                                        reason:@"Cannot find ink.js runtime"
                                        userInfo:nil];
            [fileException raise];
        }
        
        if (filePath != nil)
        {
            NSString *pathForStoryJson = [mainBundle pathForResource:filePath ofType:nil];
        
            if (pathForStoryJson != nil)
            {
                NSString *storyJsonString = [NSString stringWithContentsOfFile:pathForStoryJson
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
        
                [self evaluateScriptInContext:[NSString stringWithFormat:@"var storyContent = %@;", storyJsonString]];
                [self evaluateScriptInContext:@"story = new inkjs.Story(storyContent);"];
            }
        }
    }
    return self;
}

- (BOOL)canContinue
{
    return [[self evaluateScriptInContext:@"story.canContinue;"] toBool];
}

- (NSString *)continueStory
{
    return [[self evaluateScriptInContext:@"story.Continue();"] toString];
}

- (NSArray *)currentChoices
{
    return [[self evaluateScriptInContext:@"story.currentChoices;"] toArray];
}

- (void)chooseChoiceIndex:(NSInteger)index
{
    [self evaluateScriptInContext:[NSString stringWithFormat:@"story.ChooseChoiceIndex(%ld);", (long)index]];
}

- (JSValue *)evaluateScriptInContext:(NSString *)jsToRun
{
    return [self.jsContext evaluateScript:jsToRun];
}

@end

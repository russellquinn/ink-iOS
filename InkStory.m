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

- (NSString *)toJson
{
    // There's a typo in inkjs, should be ToJson -- will fix when inkjs is fixed.
    return [[self evaluateScriptInContext:@"story.state.toJson();"] toString];
}

- (void)loadJson:(NSString *)json
{
    // Double escape JSON input to pass as a parameter inside evaluateScriptInContext
    json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    json = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    json = [json stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    json = [json stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    json = [json stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    
    [self evaluateScriptInContext:[NSString stringWithFormat:@"story.state.LoadJson(\"%@\");", json]];
}

- (BOOL)canContinue
{
    return [[self evaluateScriptInContext:@"story.canContinue;"] toBool];
}

- (NSString *)continueStory
{
    return [[self evaluateScriptInContext:@"story.Continue();"] toString];
}

- (NSString *)currentText
{
    return [[self evaluateScriptInContext:@"story.currentText;"] toString];
}

- (BOOL)hasError
{
    return [[self evaluateScriptInContext:@"story.hasError;"] toBool];
}

- (NSArray *)currentErrors
{
    return [[self evaluateScriptInContext:@"story.currentErrors;"] toArray];
}

- (NSArray *)currentChoices
{
    return [[self evaluateScriptInContext:@"story.currentChoices;"] toArray];
}

- (void)chooseChoiceIndex:(NSInteger)index
{
    [self evaluateScriptInContext:[NSString stringWithFormat:@"story.ChooseChoiceIndex(%ld);", (long)index]];
}

- (NSArray *)currentTags
{
    return [[self evaluateScriptInContext:@"story.currentTags;"] toArray];
}

- (NSArray *)globalTags
{
    return [[self evaluateScriptInContext:@"story.globalTags;"] toArray];
}

- (NSArray *)tagsForContentAtPath:(NSString *)path
{
    return [[self evaluateScriptInContext:[NSString stringWithFormat:@"story.TagsForContentAtPath(\"%@\");", path]] toArray];
}

- (void)choosePathString:(NSString *)path
{
    [self evaluateScriptInContext:[NSString stringWithFormat:@"story.ChoosePathString(\"%@\");", path]];
}

- (JSValue *)evaluateScriptInContext:(NSString *)jsToRun
{
    return [self.jsContext evaluateScript:jsToRun];
}

@end

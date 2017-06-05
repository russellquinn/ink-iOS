//
//  InkTestViewController.m
//  Created by Russell Quinn on 6/4/17.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "InkTestViewController.h"

@implementation InkTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currButtons = [[NSMutableArray alloc] init];
    
    CGRect rect = self.view.bounds;
    rect.origin.y = 20.0f;
    rect.size.height = rect.size.height - rect.origin.y - (rect.size.height / 2.0);
    
    self.textView = [[UITextView alloc] initWithFrame:rect];
    [self.view addSubview:self.textView];
    
    self.inkStory = [[InkStory alloc] initWithStoryJsonFile:@"story.json"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self storyLoop];
}

- (void)storyLoop
{
    while ([self.inkStory canContinue] == YES)
    {
        NSString *paragraphText = [self.inkStory continueStory];
        
        self.textView.text = [self.textView.text stringByAppendingFormat:@"\n\n%@", paragraphText];
    }
    
    if (self.textView.text.length > 0)
    {
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
    }
    
    for (UIButton *buttonToRemove in self.currButtons)
    {
        [buttonToRemove removeFromSuperview];
    }
    
    [self.currButtons removeAllObjects];
    
    NSArray *choices = [self.inkStory currentChoices];
    
    CGFloat currYPos = self.textView.frame.origin.y + self.textView.frame.size.height + 5.0f;
    
    for (NSDictionary *choice in choices)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[choice objectForKey:@"text"] forState:UIControlStateNormal];
        button.tag = [[choice objectForKey:@"index"] integerValue];
        [button addTarget:self action:@selector(choiceButtonTapped:) forControlEvents:UIControlEventTouchDown];

        CGRect buttonRect = button.frame;
        buttonRect.origin.x = 20.0f;
        buttonRect.origin.y = currYPos;
        buttonRect.size.width = self.view.bounds.size.width - (buttonRect.origin.x * 2.0);
        buttonRect.size.height = 40.0f;
        button.frame = buttonRect;
        
        currYPos += buttonRect.size.height + 5.0f;
        
        [self.view addSubview:button];
        [self.currButtons addObject:button];
    }
}

- (void)choiceButtonTapped:(UIButton *)button
{
    [self.inkStory chooseChoiceIndex:button.tag];
    [self storyLoop];
}

@end

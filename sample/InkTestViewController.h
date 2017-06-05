//
//  InkTestViewController.h
//  Created by Russell Quinn on 6/4/17.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>
#import "InkStory.h"

@interface InkTestViewController : UIViewController

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) InkStory *inkStory;
@property (strong, nonatomic) NSMutableArray *currButtons;

- (void)storyLoop;
- (void)choiceButtonTapped:(UIButton *)button;

@end


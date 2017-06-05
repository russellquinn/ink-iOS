# ink-iOS

An iOS wrapper, written in Objective C, for the JavaScript port of Inkle's [Ink](https://github.com/inkle/ink), a scripting language for writing interactive narrative.

Inkle offers Unity integration, but no direct way to use the Ink runtime in a native iOS app. Yannick Lohse has [ported the runtime to JavaScript](https://github.com/y-lohse/inkjs). This wrapper provides an Objective C class named `InkStory` that drives the JavaScript runtime via iOS's `JSContext`.

## Installation

Clone the repository from GitHub and add `InkStory.m` and `InkStory.h` to your Xcode project.

Then grab the latest version of `ink.js` (the JavaScript Ink runtime library) from Yannick's [latest release](https://github.com/y-lohse/inkjs/releases). Add this to your Xcode project too.

ink-iOS works from the compiled JSON file produced by Inkle's tools. Add your JSON file to your Xcode project.

## Quickstart

There is an example `InkTestViewController` in `/sample`. It's pretty basic and the layout is intentionally horrible, but it shows the basic requirements for getting things running.

The pertinent parts:

```
#import "InkStory.h"

…

InkStory *inkStory = [[InkStory alloc] initWithStoryJsonFile:@"story.json"];
```

The main loop:

```
while ([inkStory canContinue] == YES)
{
    NSString *paragraphText = [self.inkStory continueStory];

    // Append paragraphText to your text view
}

for (NSDictionary *choice in [inkStory currentChoices])
{
    NSString *choiceTitle = [choice objectForKey:@"text"];
    NSInteger choiceIndex = [choice objectForKey:@"index"];

    // Create UIButtons or whatever for the available options
    // Stash the choiceIndex in its tag field or similar 
}
```

When a choice is selected:

```
[inkStory chooseChoiceIndex:choiceButton.tag]; // The associated choiceIndex
[self storyLoop]; // Run the main loop again
```

## Limitations

This is a very early version of this wrapper. I plan to use it on a project and will keep this repository updated as I make improvements to it.

For differences between the original C# API and the underlying JavaScript API, see [here](https://github.com/y-lohse/inkjs#differences-with-the-c-api).
# Optimizely iOS SDK Quickstart Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Creating an Optimizely Account](#accountcreation)
3. [Installation](#installation)
4. [Creating your first experiment](#quickstart)

## Introduction <a name="introduction"></a>
The goal for the iOS framework is to allow native app developers to create and run A/B tests for their apps. Ideally, creating and running an experiment should not require developers to redeploy their app. There are three different approaches for modifying elements in your app to create an experiment with the Optimizely SDK.

### Available Approaches to A/B Tests 
* **UIView Swizzling**: This is a WYSIWYG method for editing mobile UI objects. No code or App Store push required.
* **Named Variables**: You can change the value of any variable that is registered with Optimizely. There are three approaches here:
	* Named Variables
	* NSLocalisedString
	* Bound Variables
* **Code Blocks**: This allows the developer to run a custom piece of code for a given variation. Adding code requires resubmission to the App Store before activating the experiment.

### Goals and Results

Optimizely records conversion goals and reports experiment results and statistics on a binary basis - if a user has triggered a goal once, he or she is counted as 'converted'. [Learn More](https://help.optimizely.com/hc/en-us/articles/200039935-Interpreting-Test-Results)

We currently capture two types of events automagically:
 
* Taps - When a user of your app taps a specific element.
* View Changes - When a user navigates to a particular view in your app.

The above two types of goals can be added without writing even one line of code. For other goals, a developer can add custom events to be targeted. Custom goals need to be added inside the code. For more information see [Custom Goals](#customgoals)

### Error Reporting

We are currently logging if anything wrong happens on your app when using Optimizely SDK. We send account information along with device and SDK version information to our logging backend when reporting a crash.

## Creating an Optimizely Project <a name="accountcreation"></a>

To create an iOS project, select "Create New Project" in the [Optimizely Dashboard](https://www.optimizely.com/dashboard):

<img src="create-project.png" alt="Drawing" style="width: 100%;"/>

## Installation <a name="installation"></a>
This section outlines the steps required to add the Optimizely framework to an app. You can either install the Optimizely SDK using our **installation script** or **manually**

### Using the installation script
There is a Python script named `OptimizelyInstall.py` located in the root directory of the SDK.

First get your Optimizely Project ID by clicking on `Project Code` from within your new Optimizely project:

![Project Code Dialog](project-code.png)

Make sure that you have your Project ID from Optimizely and the path to your `.xcodeproj` file handy, then run `OptimizelyInstall.py`. Once the script has run skip to step 6 below.

### Manually
1. Drag the `Optimizely.framework` into your project. Check "Copy items into destination group's folder" and make sure the appropriate targets are checked.
    
2. Open the "Build Phases" tab for the app's target. Under "Link Binary with Libraries", add the required frameworks if they're not already included:
    * AdSupport.framework
    * CFNetwork.framework
    * Foundation.framework
    * libicucore.dylib
    * libsqlite3.dylib
    * Security.framework
    * SystemConfiguration.framework
    * UIKit.framework
    
3. Switch to the "Build Settings" tab. Add "-ObjC" to the "Other Linker Flags" build setting.

4. Drag `OptimizelyPrepareNibs.py` from the root directory of the SDK into your project. Check "Copy items into destination group's folder" and **uncheck all targets**.
    
5. Open the "Build Phases" tab for the app's target. In the app menu (top of the screen) click "Editor" -> "Add Build Phase" -> "Add Run Script Build Phase". In the script field, write:

		python "$SRCROOT/OptimizelyPrepareNibs.py"

    This script needs to run at the start of the build process (right after Target Dependencies). To make sure this happens, drag the Run Script phase you just added to the top of the list of phases, just under "Target Dependencies". The final result should look something like this:
    
    ![Build Targets Screenshot](screenshot-run-build-phase.png)

6. Now you're ready to write some code! Open your app's prefix header file: `MyApp-Prefix.pch` under 'Supporting Files' in a standard XCode project. Add the following line of code to the bottom:

		#import <Optimizely/Optimizely.h>

7. Add the following to the beginning of `application:didFinishLaunchingWithOptions:` in your
app delegate:

		- (void)application:(UIApplication*)application didFinishLaunchingWithOptions:(...) {

			#ifdef DEBUG
	        [Optimizely enableEditor];
	        #endif

			[Optimizely startOptimizelyWithAPIToken:@"YOUR-API-TOKEN" launchOptions:launchOptions];
						
    	    // The rest of your initialization code...
        }

### External Dependencies
There are a few external libraries used by the Optimizely SDK. These ship with the Optimizely SDK so there is no need to install them separately.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking):
    used for making network requests.
- [AFDownloadRequestOperation](https://github.com/steipete/AFDownloadRequestOperation):
    used to download assets, with the ability to resume interrupted downloads.
- [FMDB](https://github.com/ccgus/fmdb):
    Objective-C wrapper for sqlite.
- [SocketRocket](https://github.com/square/SocketRocket):
    used to communicate with the web editor over websockets.

## Creating your first experiment <a name="quickstart"></a>
This guide will walk you through setting up your first experiment using UIView Swizzling. If you are using Interface Builder or Storyboards, this is already available to you. However, if you are creating your views programmatically, jump ahead to [UISwizzling](#uiswizzling) and then return to this guide. 

### Setting up Variations
The first step is to create an experiment in the project you set up for your App. On the [optimizely website](http://optimizely.com), select the project that you created at the start of the installation process and click "Create Experiment".

<img src="editor-create-experiment.png" alt="Drawing" style="width: 100%;"/>

Once you have chosen a name and created the experiment, the editor begins waiting for a device to enter edit mode. If you haven't already, run you app in the simulator or on a device. You should see the device appear in the editor. If you don't, check out the troubleshooting section of this guide or email [support](mailto:ios-beta-support@optimizely.com).

<img src="editor-select-device.png" alt="Drawing" style="width: 100%;"/>

Once you have selected your device, it's time to create a variation. Click the "+ Add Variation" button at the top of the editor.

<img src="editor-views.png" alt="Drawing" style="width: 100%;"/>

In your app, navigate to the screen on which you want to run an experiment. As you mouse over the different elements in the side bar, you should see them highlighted in the app. When you select the view element that you want to change, the right section of the screen should  populate with the properties that you can change on that element. If you have any text elements, try changing the text. The change is immediately reflected in your app! Click save to commit your change(s) to the variation.

#### Previewing your variation
To simulate a user's experience when they are in a particular variation, you can use preview mode. Select the variation you want to see and click the 'Preview' button in the top right corner of the screen. This will cause the app to shut down. When you reopen the app, it will have all the changes you specified in your variation.

<img src="editor-preview-button.png" alt="Drawing" style="width: 100%;"/>

#### _Optional: Allocating Experiment Traffic_
By default, an equal percentage of your traffic will see each variation. If you want to change from the default, you can adjust the targeting allocation from the Options menu.

<img src="editor-traffic-allocation.png" alt="Drawing" style="width: 100%;"/>

Now that you have your variations, you're ready to create some goals!
### Goals
We automatically track all view controller transitions and screen taps so that they can easily be used as goals. In order to select a particular transition or screen tap as a goal, open the "Goals" dialogue and click "New Goal" in the bottom right.

<img src="editor-add-goal.png" alt="Drawing" style="width: 100%;"/>

On this screen, you will see all the transitions and taps occurring in your app as you interact with it on your device. Select the one that you want to be your goal and click "Done". Optimizely will now track the percentage of your users in each variation that complete that action and the results will appear in our dashboard. If you're curious about the "Create Custom Goal Instead" button, jump ahead to [Custom Goals](#customgoals).

## Advanced Testing Info
For additional information about any of the experimental approaches below, see the full [API Documentation](../help/html/Classes/Optimizely.html).

### UISwizzling <a name="uiswizzling"></a>
The Optimizely editor becomes aware of views it can swizzle by looking for views that have an `optimizelyId` property. When a view with an `optimizelyId` becomes visible in the app, the SDK alerts the web editor of its existence, as well as the existence of all of its children. The `OptimizelyPrepareNibs.py` script assigns an `optimizelyId` automatically to views created with Interface Builder or Storyboards, but you need to set this property yourself for views created programmatically.

    UILabel *label = [[UILabel alloc] initWithFrame:...];
    label.optimizelyId = @"pricing-title-label";

For any views that you want to swizzle, you should give them a unique `optimizelyId`. All the subviews of that view will also automatically become visible to the editor, so there's no need to assign an `optimizelyId` to each subview. A good guideline is that you need to assign an `optimizelyId` to the view of each of your view controllers.
	
### Code blocks

This allows developers to execute different code paths based on the active experiment and variation. Users will be randomly bucketed into a particular variation and the variationId passed into the block will reflect their bucket. This is the most powerful method for creating experiments, but requires the app to be resubmitted to the app store.

To implement, please see the [Code Blocks API Reference](../help/html/Classes/Optimizely.html#//api/name/codeTest:withBlocks:defaultBlock:)

### Named variables

The values of named variables can be affected from the "Variables" tab in the editor. This tab shows all named variables **that have been used while the app is connected to the editor**. If a named variable is only used in a view that you have not visited yet, it will not appear in the list of named variables until you navigate to that view. There are three ways that the Optimizely editor becomes aware of variables it can change:

**Registered variables** are the explicit way of setting the value for variables. Variables are defined in the user's code as seen below, with a (unique) associated key. Once a variable is registered, variations can change the value of variables based on their key. For example, you can create an experiment that tests different values for gravity.

    NSNumber *gravity = [[Optimizely sharedInstance] numberForKey:@"gravity" defaultValue:@(9.8)];

**NSLocalizedString** allows for a less explicit way of changing strings, and requires less integration if the user has already localized their app. The Optimizely SDK automatically displays any `NSLocalizedStrings` in your app and enables you to change their value.

    NSString *buttonLabel = NSLocalizedString(@"Sign up!");

**Bound variables** allow you to set values on class properties. They rely on KVC/KVO.

    [[Optimizely sharedInstance] bindNumberForKey:@"retry-count" toKeyPath:@"maxRetries" onObject:foo];

### Custom Goals <a name="customgoals"></a>
Custom goals allow you to track events other than taps and view changes. There are two steps to creating a custom goal. The first step occurs in the web editor. Click "Goals", then "New Goal", and finally "Create Custom Goal". You will be prompted for a string to uniquely identify your custom goal. In order to track this goal, send this same string as a parameter to 

    [[Optimizely sharedInstance] trackEvent:(NSString *)]

You can optionally include revenue information with the goal:

    [[Optimizely sharedInstance] trackEvent:(NSString *) revenue:(NSInteger)]

For example, if we wanted a goal for users deleting a task with a swipe, we might create a custom goal "User Deleted Task" and then call `-trackEvent` with this string in our event handler as follows:

    - (void)userDidSwipeTask:(id)sender {
        [[Optimizely sharedInstance] trackEvent:@"User Deleted Task"];
        //The rest of your handler
    }

## Troubleshooting
**Q: My device is running the app but I can't see it in the editor.**

A: First, confirm your device is connected to the internet. If that turns out to be useless advice, make sure that the API token that you passed into `[Optimizely startOptimizelyWithAPIToken:@"YOUR-API-TOKEN" launchOptions:launchOptions];` matches what you see in the Project Code box within Optimizely.
//
//  CDVGLEngine.h
//  oem_apps_cad_models
//
//  Created by dtoplak on 16.04.13.
//
//

#import <Cordova/CDV.h>
#import "CDVGLKViewControllerBase.h"

@interface CDVRenderEngine : CDVPlugin

@property (nonatomic) CDVGLKViewControllerBase *glController;

+ (CGRect)rectFromDict:(NSDictionary*)dict;
- (void)initEngine:(CDVInvokedUrlCommand*)command;
- (void)resizeEngine:(CDVInvokedUrlCommand*)command;
- (void)hideEngine:(CDVInvokedUrlCommand*)command;

@end

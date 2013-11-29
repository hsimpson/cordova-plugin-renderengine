//
//  CDVGLEngine.m
//  oem_apps_cad_models
//
//  Created by dtoplak on 16.04.13.
//
//

#import "CDVRenderEngine.h"
#import "GLKViewControllerImpl.h"

@implementation CDVRenderEngine
@synthesize glController;


+ (CGRect)rectFromDict:(NSDictionary*)dict
{
  CGRect r = CGRectMake([[dict valueForKey:@"x"]floatValue],
                        [[dict valueForKey:@"y"]floatValue],
                        [[dict valueForKey:@"w"]floatValue],
                        [[dict valueForKey:@"h"]floatValue]);
  return r;
}

- (void)initEngine:(CDVInvokedUrlCommand*)command
{
  //NSLog(@"args=%@", [command arguments]);
  NSDictionary* arg0 = [command argumentAtIndex:0];
  //NSLog(@"arg0=%@", arg0);
  
  CGRect r = [CDVRenderEngine rectFromDict:arg0];
  if(r.size.width <= 0 || r.size.height <= 0)
  {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"width or height must be greater then 0!"] callbackId:command.callbackId];
    return;
  }
  
  if(self.glController == nil)
  {
    self.glController = [[GLKViewControllerImpl alloc] initWithWebView:self.webView behindWebView:YES frameRect:r];
  }
  
  self.glController.view.frame = r;
  self.glController.view.hidden = NO;
  
  
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)resizeEngine:(CDVInvokedUrlCommand*)command
{
  if(self.glController == nil)
  {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"engine not initialized!"] callbackId:command.callbackId];
    return;
  }
  
  //NSLog(@"args=%@", [command arguments]);
  NSDictionary* arg0 = [command argumentAtIndex:0];
  //NSLog(@"arg0=%@", arg0);
  
  CGRect r = [CDVRenderEngine rectFromDict:arg0];
  
  
  if(r.size.width <= 0 || r.size.height <= 0)
  {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"width or height must be greater then 0!"] callbackId:command.callbackId];
    return;
  }
 
  self.glController.view.frame = r;
  self.glController.view.hidden = NO;
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}


- (void)hideEngine:(CDVInvokedUrlCommand*)command
{
  if(self.glController == nil)
  {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"engine not initialized!"] callbackId:command.callbackId];
    return;
  }
  self.glController.view.hidden = YES;
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}



/*

- (void)loadZJV:(CDVInvokedUrlCommand*)command
{
  // run downloading and parsing in background:
  //[self.commandDelegate runInBackground:^{
  
    CDVPluginResult* pluginResult = nil;
    NSDictionary* arg0 = [command argumentAtIndex:0];
    NSLog(@"arg0=%@", arg0);
    
    NSString* zjvurl = [arg0 valueForKey:@"zjv_path"];
    NSString* zjvAbsoluteFilePath = @"";
    
    NSURL* url = [NSURL URLWithString:zjvurl];
    // ToDo: think about caching?
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if(error == nil) // good
    {
      // save data to disk
      zjvAbsoluteFilePath = NSTemporaryDirectory();
      zjvAbsoluteFilePath = [NSString stringWithFormat:@"%@.%@", zjvAbsoluteFilePath, @"/zjv.zjv"];
      [data writeToFile:zjvAbsoluteFilePath atomically:true];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else
    {
      zjvAbsoluteFilePath = [[NSBundle mainBundle] pathForResource:@"nocad" ofType:@"zjv"];
    }
    
    // hopefully everything is threadsafe :-)
    //self.glController.part_loading = YES;
    [self.glController loadZJV:zjvAbsoluteFilePath];
    //self.glController.part_loading = NO;
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  //}];
  
}

- (void)toggleRedCyan:(CDVInvokedUrlCommand*)command
{
  [self.glController toggleRedCyan];
}

- (void)saveScreenShot:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
  GLKView *view = (GLKView *)self.glController.view;
  
  UIImage *imgResult = [view snapshot];
  
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  NSData * binaryImageData = UIImagePNGRepresentation(imgResult);
  NSString* timeStampValue = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
  NSString* filename = [NSString stringWithFormat:@"screenshot3d_%@.png", timeStampValue];
  NSString* screenshotPath = [basePath stringByAppendingPathComponent:filename];
  
  [binaryImageData writeToFile:screenshotPath atomically:YES];
  
  NSMutableDictionary* responseDict = [NSMutableDictionary dictionary];
  if(1)
  {
    
    [responseDict setValue:screenshotPath forKey:@"screenshot_path"];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
  }
  else
  {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"failed to load ZJV"];
  }
  
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
 */

@end

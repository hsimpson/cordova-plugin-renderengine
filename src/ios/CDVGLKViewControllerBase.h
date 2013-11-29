//
//  CDVGLKViewControllerBase.h
//  CAD Models
//
//  Created by dtoplak on 20.11.13.
//
//

#import <GLKit/GLKit.h>

@interface CDVGLKViewControllerBase : GLKViewController
{
}

@property (nonatomic) EAGLContext* glContext;
@property (nonatomic, weak) UIWebView* webView;
@property (nonatomic) CGRect rect;

- (id)initWithWebView:(UIWebView*)theWebView behindWebView:(BOOL)behind frameRect:(CGRect)rect;
- (void)setupGL;
- (void)tearDownGL;

@end



@interface CDVGLKViewControllerReferenceImplemntation : CDVGLKViewControllerBase

@end

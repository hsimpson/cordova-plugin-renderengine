//
//  CDVGLKViewControllerBase.m
//  CAD Models
//
//  Created by dtoplak on 20.11.13.
//
//

#import "CDVGLKViewControllerBase.h"

@implementation CDVGLKViewControllerBase

@synthesize glContext;
@synthesize webView;
@synthesize rect = _rect;

#pragma mark View Lifecycle

- (id)initWithWebView:(UIWebView*)theWebView behindWebView:(BOOL)behind frameRect:(CGRect)rect
{
  self = [super init];
  self.webView = theWebView;
  self.rect = rect;
  
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  UIViewController *rootViewController = window.rootViewController;
  [rootViewController.view addSubview:self.view];
  
  if(behind)
  {
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [rootViewController.view sendSubviewToBack:self.view];
  }
  
  // add the _glController to root controller
  [rootViewController addChildViewController:self];
  
  [self didMoveToParentViewController:rootViewController];
  
  return self;
}

- (void) viewDidLoad
{
  [super viewDidLoad];
  
  self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  
  if (!self.glContext) {
    NSLog(@"Failed to create ES context");
  }
  
  GLKView *view = (GLKView *)self.view;
  view.context = self.glContext;
  //ToDo: don`t use multisampling on older devices
  view.drawableMultisample = GLKViewDrawableMultisample4X;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  
  [self setupGL];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  [self tearDownGL];
  
  if ([EAGLContext currentContext] == self.glContext) {
    [EAGLContext setCurrentContext:nil];
  }
  self.glContext = nil;
}

#pragma mark GL setup|update|draw|cleanup
- (void)setupGL
{
  [EAGLContext setCurrentContext:self.glContext];
}

- (void)update
{
 
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  
}

- (void)tearDownGL
{
  [EAGLContext setCurrentContext:self.glContext];
}

@end


/*
 * This is a reference implementation which draws a cube:
 * - using a Vertex Array Object (VAO) via OES_vertex_array_object extension (http://www.khronos.org/registry/gles/extensions/OES/OES_vertex_array_object.txt)
 * - using a perspective: with 35° FOVY, Z-Near = 4.0f and Z-Far = 10.0f
 *
 */

/* the cube:
 
 
    v5-----------v6
   / |          / |
  /  |         /  |
 v2----------v1   |
 |   |        |   |
 |   |        |   |
 |  v4--------|--v7
 | /          |  /
 |/           | /
 v3-----------v0
 
 
 */

typedef struct
{
  float Position[3];
  float Color[4];
} VERTEX;

const VERTEX VERTICES[] =
{
  // V0
  { { 1.0f, -1.0f, -1.0f}, {1.0f, 1.0f, 0.0f, 1.0f} }, // yellow
  // V1
  { { 1.0f,  1.0f, -1.0f}, {1.0f, 1.0f, 1.0f, 1.0f} }, // white
  // V2
  { {-1.0f,  1.0f, -1.0f}, {1.0f, 0.0f, 1.0f, 1.0f} }, // magenta
  // V3
  { {-1.0f, -1.0f, -1.0f}, {1.0f, 0.0f, 0.0f, 1.0f} }, // red
  // V4
  { {-1.0f, -1.0f,  1.0f}, {0.0f, 0.0f, 0.0f, 1.0f} }, // black
  // V5
  { {-1.0f,  1.0f,  1.0f}, {0.0f, 0.0f, 1.0f, 1.0f} }, // blue
  // V6
  { { 1.0f,  1.0f,  1.0f}, {0.0f, 1.0f, 1.0f, 1.0f} }, // cyan
  // V7
  { { 1.0f, -1.0f,  1.0f}, {0.0f, 1.0f, 0.0f, 1.0f} }  // green
};

const GLubyte INDICES[] = {
  /* Front face. */
  /* Bottom left */
  2, 0, 3,
  /* Top right */
  2, 1, 0,
  
  /* Left face */
  /* Bottom left */
  5, 3, 4,
  /* Top right */
  5, 2, 3,
  
  /* Top face */
  /* Bottom left */
  5, 1, 2,
  /* Top right */
  5, 6, 1,
  
  /* Right face */
  /* Bottom left */
  1, 7, 0,
  /* Top right */
  1, 6, 7,
  
  /* Back face */
  /* Bottom left */
  6, 4, 7,
  /* Top right */
  6, 5, 4,
  
  /* Bottom face */
  /* Bottom left */
  3, 7, 4,
  /* Top right */
  3, 0, 7
};

@interface CDVGLKViewControllerReferenceImplemntation ()
{
  GLuint _vbo;
  GLuint _ibo;
  GLuint _vao;
  float _rotation;
}

@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation CDVGLKViewControllerReferenceImplemntation

- (void)setupGL
{
  [super setupGL];
  glClearColor(0.0, 0.0, 0.0, 1.0f);
  
  self.effect = [[GLKBaseEffect alloc] init];
  self.effect.lightingType = GLKLightingTypePerPixel;
  
  // create end bind VAO
  glGenVertexArraysOES(1, &_vao);
  glBindVertexArrayOES(_vao);
  
  // create and bind VBO
  glGenBuffers(1, &_vbo);
  glBindBuffer(GL_ARRAY_BUFFER, _vbo);
  glBufferData(GL_ARRAY_BUFFER, sizeof(VERTICES), VERTICES, GL_STATIC_DRAW);
  
  // create and bind IBO
  glGenBuffers(1, &_ibo);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(INDICES), INDICES, GL_STATIC_DRAW);
  
  // New lines (were previously in draw)
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VERTEX), (const GLvoid *) offsetof(VERTEX, Position));
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(VERTEX), (const GLvoid *) offsetof(VERTEX, Color));

  // unbind VAO
  glBindVertexArrayOES(0);
  
  glEnable(GL_DEPTH_TEST);
}


- (void)update
{
  [super update];
  float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
  GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(35.0f), aspect, 4.0f, 10.0f);
  self.effect.transform.projectionMatrix = projectionMatrix;
  
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
  _rotation += 90 * self.timeSinceLastUpdate;
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(25), 1, 0, 0);
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 1, 0);
  self.effect.transform.modelviewMatrix = modelViewMatrix;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  [super glkView:view drawInRect:rect];
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  [self.effect prepareToDraw];
  
  glBindVertexArrayOES(_vao);
  glDrawElements(GL_TRIANGLES, sizeof(INDICES)/sizeof(INDICES[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)tearDownGL
{
  [super tearDownGL];
  
  glDeleteBuffers(1, &_vbo);
  glDeleteBuffers(1, &_ibo);
  glDeleteVertexArraysOES(1, &_vao);
  
  self.effect = nil;
}




@end

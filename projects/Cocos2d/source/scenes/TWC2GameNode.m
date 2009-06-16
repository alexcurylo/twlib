//
//  TWC2GameNode.m
//  SapusTongue
//
//  Created by Ricardo Quesada on 02/08/08.
//  Copyright 2008,2009 Sapus Media. All rights reserved.
//

//
// Game Node:
// The logic of the game is implemented here.
//   a State machine is used for the different states:
//		kGameWaiting  <-- Game is being initialized
//		kGameStart    <-- Game started... flip the Sapus
//		kGameFlying   <-- Sapus is flying
//		kGameOver     <-- Sapus stoped flyting
//		kGameTryAgain <-- Menu is displayed
//		kGameDrawTongue <-- PlayAgain... draw tongue and play "uh no"
//		kGameIsBeingReplaced <-- Game is restared... 

#import "TWC2GameNode.h"
#import "TWC2AppDelegate.h"

// cocos2d imports
#import "cocos2d.h"
#import "chipmunk.h"

// TIP:
//  When doing physics stuff start by playing with physics objects first
//    . circles, polygons, segments
//  And when you have it working then draw the sprites
//

// If DRAW_SHAPES == 1, the physics models will be drawn
#define DRAW_SHAPES 0

// local imports
#import "SoundEngineManager.h"
#import "TWC2GradientLayer.h"
/*
 #import "GameHUD.h"
#import "SelectCharNode.h"
#import "FloorNode.h"
#import "MountainNode.h"
*/


/*
// Position of the "bee".. where the tongue is attached to
#define kJointX 160
#define kJointY 160
*/

enum {
	kTagGradient = 1,
	kTagFloor = 2,
};

/*
// TIP:
//  The most difficult part with a physics engine is tunning it.
//  Use constants (or #defines) while tunning the engine, and modify these constants.

const float	kSapusTongueLength = 80.0f;
const float kSapusMass = 1.0f;
const float kForceFactor = 350.0f;
const float kSapusElasticity = 0.4f;
const float kSapusFriction = 0.8f;
const float kSapusOffsetY = 32;
// incremented by 4096 in v1.7.2. Lot of people is reaching the maximum score
const float kWallLength = 24576.0f;

const float kGravityRoll = -50.0f;
const float kGravityFly = -175.0f;

// EXPERIMENTAL TIP:
// Fixed time physics "step" in seconds
// The lower the number, the smoother the animation, but it consume more FPS
//
// WARNING: This number can't be much lower than this, else it is possible to enter
// in a never-ending-cycle that consume lot's of FPS
//
// WARNING: If you are planning to use this tip, test it very well on all the devices
//   * iPhone 1gen, 3G
//   * iPod Touch 1g, 2g
// 
// WHEN CAN YOU USE THIS TIP ?:
// When you know before hand that your physics simulation is constant
//  * No new bodies are added
// 
// By using this tip Sapus Tongue runs at 60 FPS and has an smoother physics simulation
//
#ifdef EXPERIMENTAL_PHYSICS_STEP
const float kPhysicsDelta = 0.0005f;

// if the delta is greater than this value, then something went wrong
// so we should update the physics engine ASAP.
const float kPhysicsDeltaSomethingWentWrong = 0.10f;
#endif
*/

static int totalScore = 0;

#define kAccelerometerFrequency 60

/*
enum {
	kCollTypeIgnore,
	kCollTypeSapus,
	kCollTypeFloor,
	kCollTypeWalls,
	kCallTypeBee,
};
*/

#pragma mark Chipmunk Callbacks

/*
 //
// Debug functions used to draw the shapes.
// Only used while debugging & testing the physics world
//
#ifdef DRAW_SHAPES
void drawCircleShape(cpShape *shape)
{
	cpBody *body = shape->body;
	cpCircleShape *circle = (cpCircleShape *)shape;
	cpVect c = cpvadd(body->p, cpvrotate(circle->c, body->rot));
	drawCircle( ccp(c.x, c.y), circle->r, body->a, 15, YES);
}

void drawSegmentShape(cpShape *shape)
{
	cpBody *body = shape->body;
	cpSegmentShape *seg = (cpSegmentShape *)shape;
	cpVect a = cpvadd(body->p, cpvrotate(seg->a, body->rot));
	cpVect b = cpvadd(body->p, cpvrotate(seg->b, body->rot));
	
	drawLine( ccp(a.x, a.y), ccp(b.x, b.y) );
}

void drawPolyShape(cpShape *shape)
{
	cpBody *body = shape->body;
	cpPolyShape *poly = (cpPolyShape *)shape;
	
	int num = poly->numVerts;
	cpVect *verts = poly->verts;
	
	CGPoint *vertices = malloc( sizeof(CGPoint)*poly->numVerts);
	if( ! vertices )
		return;
	
	for(int i=0; i<num; i++){
		cpVect v = cpvadd(body->p, cpvrotate(verts[i], body->rot));
		vertices[i] = v;
	}
	drawPoly( vertices, poly->numVerts, YES );
	
	free(vertices);
}
#endif // DRAW_SHAPES

static void
eachShape(void *ptr, void* instance)
{
//	TWC2GameNode *self = (TWC2GameNode*) instance;
	cpShape *shape = (cpShape*) ptr;
	Sprite *sprite = shape->data;
	if( sprite ) {
		cpVect c;
		cpBody *body = shape->body;
		
		c = cpvadd(body->p, cpvrotate(cpvzero, body->rot));
//		c = body->p;
		
		[sprite setPosition: c];
		[sprite setRotation: CC_RADIANS_TO_DEGREES( -body->a )];

	}
#if DRAW_SHAPES
	{
		switch(shape->klass->type){
			case CP_CIRCLE_SHAPE:
				drawCircleShape(shape);
				break;
			case CP_SEGMENT_SHAPE:
				drawSegmentShape(shape);
				break;
			case CP_POLY_SHAPE:
				drawPolyShape(shape);
				break;
			default:
				printf("Bad enumeration in drawObject().\n");
		}
	}
#endif

}
int collisionSapusFloor(cpShape *sapus, cpShape *floor, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data) {
	
	// play a vibrate "sound" if Sapus touches ground at a speed greater than 1000
	if( cpvlength(sapus->body->v) > 1000 )
		SoundEngine_Vibrate();

	if( cpvlength(sapus->body->v) > 250 )
		[[SoundEngineManager sharedManager] playSound:@"snd-gameplay-boing.caf"];
	
	// TIP:
	// return 1 means: "engine treat this collision as normal collision"
	// return 0 means: "ignore this collision"
	return 1;
}
*/

#pragma mark TWC2GameNode - Private interaces

@interface TWC2GameNode (Private)

-(void) initBackground;
-(void) initChipmunk;
/*
 -(void) initSapus;
-(void) initTongue;
-(void) initJoint;
-(void) initBackground;
-(void) initChipmunk;
-(void) initCollisionDetection;

-(void) updateDampedSpring: (cpFloat) dt;
-(void) removeJoint;
-(void) updateSapusAngle;
-(void) updateJointLength;
-(void) drawTongue;

-(void) updateRollingVars;
-(void) updateRollingFrames;
-(void) updateFlyingFrames: (ccTime) dt;

-(void) throwFinish;
 */

@end

@implementation TWC2GameNode

+ (int)score
{
	return totalScore;
}

+ (Scene *)scene
{
	Scene *s = [Scene node];
	
	id game = [TWC2GameNode node];
/*
   GameHUD *hud = [[GameHUD alloc] initWithGame:game];
	*/
   
/*
   [s addChild:hud z:1];
*/
	[s addChild:game];
	
/*
   [hud release];
*/
	
	return s;
}

#pragma mark TWC2GameNode - Init & Creation

-(id) init
{
	[super init];
	
	isTouchEnabled = YES;
	isAccelerometerEnabled = YES;

#if DRAW_SHAPES
    glEnable(GL_LINE_SMOOTH);
	 glEnable(GL_POINT_SMOOTH);
    glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
    glHint(GL_POINT_SMOOTH_HINT, GL_DONT_CARE);
#endif
	
	//SapusTongueAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];	
	TWAppDelegate().isPlaying = YES;
	
	[self initBackground];
/*
   [self initTongue];
*/
	[self initChipmunk];
/*
   [self initCollisionDetection];
*/
	
	[self schedule: @selector(delayStart:) interval:1.2f];
	[self schedule: @selector(step:)];
	
	totalScore = 0;
	
	// acceletometer hardware bug
	_accelValsRecieved = NO;
	_accelDelay = 0;
	
	return self;
}

-(void) initBackground
{
/*
	// tree
	Sprite *tree = [Sprite spriteWithFile:@"tree1.png"];
	tree.transformAnchor = cpvzero;
	[self addChild:tree z:-1];
*/

/*
	AtlasSpriteManager *mgr = [AtlasSpriteManager spriteManagerWithFile:@"sprite-sheet-ufo.png"];
	[self addChild:mgr z:-2];
	
	// ufos
	AtlasSprite *ufo1 = [AtlasSprite spriteWithRect:CGRectMake(0,0,138,84) spriteManager:mgr];
	[mgr addChild:ufo1];
	ufo1.position = cpv(1400,2000);	
		
	AtlasSprite *ufo2 = [AtlasSprite spriteWithRect:CGRectMake(0,168,195,87) spriteManager:mgr];
	[mgr addChild:ufo2];
	ufo2.position = cpv(900,2100);

	AtlasSprite *ufo3 = [AtlasSprite spriteWithRect:CGRectMake(176,0,81,160) spriteManager:mgr];
	[mgr addChild:ufo3];
	ufo3.position = cpv(400,2100);
*/
	
/*
 // create the tile map atlas
	// using an aliased texture
	// to prevent black lines
	[Texture2D saveTexParameters];
	[Texture2D setAliasTexParameters];

	// tile map
	TileMapAtlas *tilemap = [TileMapAtlas tileMapAtlasWithTileFile:@"tiles.png" mapFile:@"sapuslevel.tga" tileWidth:64 tileHeight:64];
	
	[Texture2D restoreTexParameters];

	[self addChild:tilemap z:-5];
	// release the internal map. Only needed if you are going
	// to read it or write it
    [tilemap releaseMap];
*/
   
	/*
    // floor
	FloorNode *floor = [FloorNode node];
	[self addChild:floor z:-6 tag:kTagFloor];	

	// mountains	
	MountainNode *mountain = [MountainNode node];
	[self addChild:mountain z:-7 parallaxRatio:cpv(0.3f,0.3f)];
    */
	
	// gradient
	TWC2GradientLayer *g = [TWC2GradientLayer layerWithColor:0];
	[g setBottomColor:0xb3e2e6ff topColor:0x000000ff];
	[g changeHeight:1600];
	[g changeWidth:480];
	[self addChild: g z:-10 tag:kTagGradient];	
}

- (void)initChipmunk
{

	cpInitChipmunk();
   
   twlog("finish off TWC2GameNode initChipmunk");
/*
	cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
	space = cpSpaceNew();
	cpSpaceResizeStaticHash(space, kWallLength, 30);
	cpSpaceResizeActiveHash(space, 100, 100);

	space->elasticIterations = space->iterations = 10;
	space->gravity = cpv(0, kGravityRoll);
	
	cpShape *shape;

	// pivot point. fly
	Sprite *fly;
	if( [SelectCharNode selectedChar] == 0 )
		fly = [Sprite spriteWithFile:@"fly.png"];
	else {
		fly = [Sprite spriteWithFile:@"branch.png"];
		fly.transformAnchor = cpv(19,30);
	}
	
	[self addChild:fly z:1];
	
	pivotBody = cpBodyNew(INFINITY, INFINITY);
	pivotBody->p =  cpv(kJointX,kJointY);
	shape = cpCircleShapeNew(pivotBody, 5.0f, cpvzero);
	shape->e = 0.9f;
	shape->u = 0.9f;
	shape->data = fly;
	cpSpaceAddStaticShape(space, shape);

	
	GLfloat wallWidth = 1;

	// floor
	shape = cpSegmentShapeNew(staticBody, cpv(-wallWidth,-wallWidth+1), cpv(kWallLength,-wallWidth), wallWidth+1);
	shape->e = 0.5f;
	shape->u = 0.9f;
	shape->collision_type = kCollTypeFloor;
	cpSpaceAddStaticShape(space, shape);
		
	// left
	shape = cpSegmentShapeNew(staticBody, cpv(-wallWidth,-wallWidth), cpv(-wallWidth,2000), wallWidth);
	shape->e = 0.2f;
	shape->u = 1.0f;
	cpSpaceAddStaticShape(space, shape);
	
	// right
	shape = cpSegmentShapeNew(staticBody, cpv(kWallLength,-wallWidth), cpv(kWallLength,2000), wallWidth);
	shape->e = 0.0f;
	shape->u = 1.5f;
	cpSpaceAddStaticShape(space, shape);
		
	[self initSapus];
	[self initJoint];
	
	// reposition sapus
	sapusBody->p.y = 30;
*/
}

/*
 -(void) initJoint {
	// TIP:
	// When dealing with joints it is OK to try the different kind of joints.
	// You can achieve different visual effects
	
	// The joint is used to attach Sapus to the tree
	// the joint is visually represented by the tongue (or tail)
	
//	joint = cpPinJointNew(sapusBody, pivotBody, cpvzero, cpvzero);
//	joint = cpGrooveJointNew(sapusBody, pivotBody, cpv(0, 40), cpv(0,100), cpv(0, 0));

	joint = cpPivotJointNew(sapusBody, pivotBody, cpv(kJointX, kJointY));
//	joint = cpSlideJointNew(sapusBody, pivotBody, cpvzero, cpvzero, 0, kSapusTongueLength);

}
*/

/*
-(void) initSapus
{
	// Using an AtlasSprite to render all the frames of the Monus/Sapus
	int sapusY = 0;
	AtlasSpriteManager *spriteManager = nil;
	if( [SelectCharNode selectedChar] == 0 ) {
		spriteManager = [[AtlasSpriteManager spriteManagerWithFile:@"sprite-sheet-sapus.png"] retain];
		sapusSprite = [[AtlasSprite spriteWithRect:CGRectMake(64*2, 64*0, 64, 64) spriteManager:spriteManager] retain];
		sapusY = 0;
	} else {
		spriteManager = [[AtlasSpriteManager spriteManagerWithFile:@"sprite-sheet-monus.png"] retain];
		sapusSprite = [[AtlasSprite spriteWithRect:CGRectMake(64*2, 64*0, 64, 64) spriteManager:spriteManager] retain];
		sapusY = 2;
	}

	[spriteManager addChild:sapusSprite];

		
	cpVect ta = sapusSprite.transformAnchor;
	ta.y = kSapusOffsetY;
	sapusSprite.transformAnchor = ta;

	// Roll Frame
	AtlasAnimation *animRoll = [AtlasAnimation animationWithName:@"roll" delay:0.2f];
	[animRoll addFrameWithRect:CGRectMake(64*2, 64*sapusY, 64, 64)];	
	[sapusSprite addAnimation:animRoll];

	AtlasAnimation *animFly = [AtlasAnimation animationWithName:@"fly" delay:0.2f];
	[animFly addFrameWithRect: CGRectMake(64*0, 64*0, 64, 64)];
	[animFly addFrameWithRect: CGRectMake(64*1, 64*0, 64, 64)];
	[animFly addFrameWithRect: CGRectMake(64*2, 64*0, 64, 64)];
	[animFly addFrameWithRect: CGRectMake(64*3, 64*0, 64, 64)];
	[animFly addFrameWithRect: CGRectMake(64*0, 64*1, 64, 64)];
	[animFly addFrameWithRect: CGRectMake(64*3, 64*0, 64, 64)];
	[animFly addFrameWithRect: CGRectMake(64*2, 64*0, 64, 64)];
	[animFly addFrameWithRect: CGRectMake(64*1, 64*0, 64, 64)];
	[sapusSprite addAnimation:animFly];
	
	// monus
	if( [SelectCharNode selectedChar] == 1 ) {
		AtlasAnimation *animNoTail = [AtlasAnimation animationWithName:@"notail" delay:0.2f];
		[animNoTail addFrameWithRect: CGRectMake(64*0, 64*2, 64, 64)];
		[animNoTail addFrameWithRect: CGRectMake(64*1, 64*2, 64, 64)];
		[animNoTail addFrameWithRect: CGRectMake(64*2, 64*2, 64, 64)];
		[animNoTail addFrameWithRect: CGRectMake(64*3, 64*2, 64, 64)];
		[animNoTail addFrameWithRect: CGRectMake(64*0, 64*3, 64, 64)];
		[animNoTail addFrameWithRect: CGRectMake(64*3, 64*2, 64, 64)];
		[animNoTail addFrameWithRect: CGRectMake(64*2, 64*2, 64, 64)];
		[animNoTail addFrameWithRect: CGRectMake(64*1, 64*2, 64, 64)];
		[sapusSprite addAnimation:animNoTail];		
	}

	
	[self addChild:spriteManager z:-1];
	

	cpFloat radius = 12;
	
	// Sapus / Monus is simulated using 5 circles.
	// (imagine a pentagon, and with a circle in each of it's vertices)
	//
	// TIP:
	// According to my expirience it is easier and faster to model objects using circles
	// than using custom polygons.

	cpFloat moment = cpMomentForCircle(kSapusMass/5.0f, 0, radius, cpv(0,(64-radius)-kSapusOffsetY) );
	moment += cpMomentForCircle(kSapusMass/5.0f, 0, radius, cpv(-14,3+radius-kSapusOffsetY) );
	moment += cpMomentForCircle(kSapusMass/5.0f, 0, radius, cpv(14,3+radius-kSapusOffsetY) );
	moment += cpMomentForCircle(kSapusMass/5.0f, 0, radius, cpv(22,29+radius-kSapusOffsetY) );
	moment += cpMomentForCircle(kSapusMass/5.0f, 0, radius, cpv(-22,29+radius-kSapusOffsetY) );

	sapusBody = cpBodyNew(kSapusMass, moment);
	
	sapusBody->p = pivotBody->p;
	sapusBody->p.y = pivotBody->p.y - kSapusTongueLength;
//	sapusBody->p.y = 30;

	cpSpaceAddBody(space, sapusBody);
	
	
	//
	// The position/elasticity/friction of the 5 circles
	//
//	cpShape *shape = cpPolyShapeNew(sapusBody, numVertices, verts, cpvzero);
	cpShape *shape = cpCircleShapeNew(sapusBody, radius, cpv(0,(64-radius)-kSapusOffsetY) );
	shape->e = kSapusElasticity;
	shape->u = kSapusFriction;
	shape->collision_type = kCollTypeSapus;	
	shape->data = sapusSprite;
	cpSpaceAddShape(space, shape);

	shape = cpCircleShapeNew(sapusBody, radius, cpv(-14,3+radius-kSapusOffsetY) );
	shape->e = kSapusElasticity;
	shape->u = kSapusFriction;
	shape->collision_type = kCollTypeSapus;	
	cpSpaceAddShape(space, shape);

	shape = cpCircleShapeNew(sapusBody, radius, cpv(14,3+radius-kSapusOffsetY) );
	shape->e = kSapusElasticity;
	shape->u = kSapusFriction;
	shape->collision_type = kCollTypeSapus;	
	cpSpaceAddShape(space, shape);
	
	shape = cpCircleShapeNew(sapusBody, radius, cpv(22,29+radius-kSapusOffsetY) );
	shape->e = kSapusElasticity;
	shape->u = kSapusFriction;
	shape->collision_type = kCollTypeSapus;	
	cpSpaceAddShape(space, shape);

	shape = cpCircleShapeNew(sapusBody, radius, cpv(-22,29+radius-kSapusOffsetY) );
	shape->e = kSapusElasticity;
	shape->u = kSapusFriction;
	shape->collision_type = kCollTypeSapus;	
	cpSpaceAddShape(space, shape);
	
}
*/

/*
-(void) initTongue {
	if( [SelectCharNode selectedChar] == 0 )
		tongue = [[TextureMgr sharedTextureMgr] addImage: @"SapusTongue.png"];
	else
		tongue = [[TextureMgr sharedTextureMgr] addImage: @"MonusTail.png"];
	[tongue retain];
}
*/

/*
-(void) initCollisionDetection {
	cpSpaceAddCollisionPairFunc(space, kCollTypeSapus, kCollTypeFloor, &collisionSapusFloor, self);
}
*/

- (void)dealloc
{	
	//SapusTongueAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];	
	TWAppDelegate().isPlaying = NO;
/*	
	[sapusSprite release];
	[tongue release];
	cpSpaceFreeChildren(space);
	cpSpaceFree(space);
	*/
	
	[super dealloc];
}

//
// The heavy part of init and the UIKit controls are initialized after the transition is finished.
// This trick is used to:
//    * create a smooth transition (load heavy resources after the transition is finished)
//    * show UIKit controls after the transition to simulate that they transition like any other control
//
-(void) delayStart: (ccTime) dt
{
   (void)dt;
   
	[self unschedule:_cmd];
	state = kGameStart;

   /*
	[self addJoint];
*/
   
	// to prevent artifacts while rendering tiles
//	[[Director sharedDirector] set2Dprojection];
//	[[Director sharedDirector] setDepthTest: NO];
}

-(void) onEnter
{
	[super onEnter];

	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
}

#pragma mark TWC2GameNode - Main Loop

-(void) step: (ccTime) delta
{
   (void)delta;
   
/*
	cpBodyResetForces(sapusBody);

 //	cpVect impulse = cpvmult(force, 10);
	cpVect f = cpvmult(force, kForceFactor);

	if( state == kGameStart ) {
		
		cpBodyApplyForce(sapusBody, f, cpvzero);		
		[self updateRollingFrames];
		[self updateRollingVars];

	} else if( state == kGameFlying ) {
		totalScore = sapusBody->p.x;

		// TIP:
		// A physics engine has lots of variables.
		// Here I'm reducing the angular speed when Sapus/Monus
		// is rotation while it is flying.
		//
		// If you comment this line you will see that sapus
		// rotates much faster (obtain better scores)
		sapusBody->t = -(sapusBody->w) * sapusBody->i / 4.0f;
		
		[self updateFlyingFrames: delta];
		if( cpvlength(sapusBody->v) <= 1.0f && sapusBody->p.y <= 70 ) {
			[self throwFinish];
		}
		
		// XXX BUG: since we don't have continous collition detection
		// Sapus/Monus can pass through the floor.
		// To prevent this, we just re position the Monus/Sapus if 
		// it's position is lower than 20
		if( sapusBody->p.y < 20 ) {
			sapusBody->p.y = 70;
		}
	}

	// EXPERIMENTAL TIP:
	// Try to always pass a fixed delta in the simulation
	// This article explains a good way to achieve it:
	// http://gafferongames.com/game-physics/fix-your-timestep/
	// This is also valid for chipmunk
#ifdef EXPERIMENTAL_PHYSICS_STEP
	physicsAccumulator += delta;
	if( delta > kPhysicsDeltaSomethingWentWrong ) {
		cpSpaceStep(space, delta);
	} else while( physicsAccumulator >= kPhysicsDelta ) {
		cpSpaceStep(space, kPhysicsDelta);
		physicsAccumulator -= kPhysicsDelta;
	}
#else
	int steps = 7;
	cpFloat dt = delta/(cpFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}	
#endif
	
	// update screen position
	if( sapusBody->p.x > 260 )
		position.x = -(sapusBody->p.x - 260);
	else
		position.x = 0;
	if( sapusBody->p.y > 244 )
		position.y = -(sapusBody->p.y - 244);
	else
		position.y = 0;
	

	// TIP:
	//  Sometimes the accelerometer does not respond (this is a known iPhone bug)
	//  This is the workaround:
	if(_accelValsRecieved == NO) {
		_accelDelay++;
		if(_accelDelay >= 60) {
			_accelDelay = 0;
			[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
			[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
			[[UIAccelerometer sharedAccelerometer] setDelegate:self];
		}
	}	

	// update gradient & floor X position
	CocosNode *gradient = [self getChildByTag:kTagGradient];
	CocosNode *floor = [self getChildByTag:kTagFloor];
	cpVect p = position;
	p.x = -position.x;
	p.y = position.y;
	gradient.position = p;
	floor.position = p;
 
 */
}

-(void) updateDampedSpring: (cpFloat) dt
{
   (void)dt;
   /*
	cpDampedSpring(sapusBody, pivotBody, cpvzero, cpvzero, 75, 200.0f, 50.0f, dt);
    */
}

/*
-(void) updateSapusAngle {
	cpVect diff = cpvsub(pivotBody->p,sapusBody->p);
	cpFloat a = cpvtoangle(diff);
	sapusBody->a = a - (float)M_PI_2;
}
*/

/*
-(void) updateJointLength {
	cpSlideJoint *j = (cpSlideJoint*) joint;	
	cpFloat v = cpvlength( sapusBody->v );
	
	j->max = kSapusTongueLength + (v / 13.0f);
	j->max = MAX(j->max, kSapusTongueLength);
	j->max = MIN(j->max, kSapusTongueLength+70);
}
*/

/*
-(void) updateRollingVars {
	
	// velocity
	throwVelocity = cpvlength( sapusBody->v );

	// angle
	cpVect diff = cpvsub(pivotBody->p,sapusBody->p);
	cpFloat a = cpvtoangle(diff);
	throwAngle = CC_RADIANS_TO_DEGREES(a);
}
*/

/*
-(void) updateRollingFrames {
	[sapusSprite setDisplayFrame:@"roll" index:0];
	displayFrame = 0;
}
*/

/*
-(void) updateFlyingFrames: (ccTime) dt {
	
	if( cpvlength(sapusBody->v) > 100 ) {
		flyingDeltaAccum += dt;

		int idx = flyingDeltaAccum  / 0.06f;
		[sapusSprite setDisplayFrame:@"fly" index: idx%8];
		displayFrame = idx % 8;
	}
}
*/

-(void) draw
{
/*
 glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	cpSpaceHashEach(space->activeShapes, &eachShape, self);
	cpSpaceHashEach(space->staticShapes, &eachShape, self);
	
//	drawPointDeprecated( kJointX,kJointY);
	
	if( state == kGameStart || state == kGameDrawTongue )
		[self drawTongue];
*/
}

/*
 -(void) drawTongue {
	
	//
	// TIP:
	// The tongue (or tail) is drawn
	// using a GL Quad from the mouth to the pivot point
	// You can strech, enlarge any texture using a Quad.
	//
	GLfloat	 coordinates[] = {  0,				tongue.maxT,
								tongue.maxS,	tongue.maxT,
								0,				0,
								tongue.maxS,	0  };
	

	cpVect sapusV = sapusBody->p;
	float angle = cpvtoangle( cpvsub(pivotBody->p, sapusV) );
	float x = sinf(angle);
	float y = -cosf(angle);

	float ys = sinf( sapusBody->a + (float)M_PI_2);
	float xs = cosf( sapusBody->a + (float)M_PI_2);

	float tongueLen = 11;
	if( [SelectCharNode selectedChar] == 0 )
		tongueLen = 15;
	sapusV.x = sapusV.x + tongueLen*xs;
	sapusV.y = sapusV.y + tongueLen*ys;	
	
	GLfloat	vertices[] = {	sapusV.x - x*1.5f,		sapusV.y - y*1.5f,		0.0f,
							sapusV.x + x*1.5f,		sapusV.y + y*1.5f,		0.0f,
							pivotBody->p.x - x*1.5f,	pivotBody->p.y - y*1.5f,	0.0f,
							pivotBody->p.x + x*1.5f,	pivotBody->p.y + y*1.5f,	0.0f };
	
	glEnableClientState( GL_VERTEX_ARRAY);
	glEnableClientState( GL_TEXTURE_COORD_ARRAY );
	
	glEnable( GL_TEXTURE_2D);
	
	
	glBindTexture(GL_TEXTURE_2D, tongue.name );
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisable( GL_TEXTURE_2D);	
	glDisableClientState(GL_VERTEX_ARRAY );
	glDisableClientState( GL_TEXTURE_COORD_ARRAY );


//	glColor4ub(224,32,32,255);
//	drawLineDeprecated(sapusBody->p.x + 16*xs,
//			 sapusBody->p.y + 16*ys,
//			 pivotBody->p.x,
//			 pivotBody->p.y);
//	glColor4ub(255,255,255,255);
}
*/

/*
-(void) addJoint {
	cpSpaceAddJoint(space, joint);
	jointAdded = YES;
	state = kGameStart;
	totalScore = 0;
	space->gravity = cpv(0, kGravityRoll);

}
*/

/*
-(void) removeJoint {
	cpSpaceRemoveJoint(space, joint);
	jointAdded = NO;
	state = kGameFlying;
	space->gravity = cpv(0, kGravityFly);

	[sapusSprite setDisplayFrame:@"fly" index:2];
	
	if( cpvlength(sapusBody->v) > 630 ) {
		int r = CCRANDOM_0_1() * 6;
		switch (r) {
			case 0:
				[[SoundEngineManager sharedManager] playSound:@"snd-gameplay-mama.caf"];
				break;
			case 1:
				[[SoundEngineManager sharedManager] playSound:@"snd-gameplay-geronimo.caf"];
				break;
			case 2:
				[[SoundEngineManager sharedManager] playSound:@"snd-gameplay-yaaa.caf"];
				break;
			case 3:
				[[SoundEngineManager sharedManager] playSound:@"snd-gameplay-argh.caf"];
				break;
			case 4:
				[[SoundEngineManager sharedManager] playSound:@"snd-gameplay-yupi.caf"];
				break;
			case 5:
				[[SoundEngineManager sharedManager] playSound:@"snd-gameplay-waka.caf"];
				break;				
				
		}
	}
}
*/

- (void)throwFinish
{
	state = kGameOver;
}


#pragma mark TWC2GameNode - Input

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)event;

	UITouch *touch = [touches anyObject];	
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[Director sharedDirector] convertCoordinate: location];
	
   /*
#define kBorder 2
	if( location.x > kBorder && location.x < (480-kBorder) && location.y > kBorder && location.y < (320-kBorder) ) {
		if( state == kGameStart ) {
			if( jointAdded ) {
				[self removeJoint];
			} else {
				[self addJoint];
			}
			return kEventHandled;
		}
	}
    */
   
   
	return kEventIgnored;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
   (void)acceleration;
   (void)accelerometer;

	static float prevX=0, prevY=0;
	
	_accelValsRecieved = YES;

#define kFilterFactor 0.05f
	
	if (state == kGameStart)
   {
		float accelX = (float)acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
		float accelY = (float)acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
		prevX = accelX;
		prevY = accelY;
		
		// landscape mode
/*
 force = cpv( (float)-acceleration.y, (float)acceleration.x);			
*/
	}
   else if (state == kGameFlying)
   {
/*
 force = cpvzero;
 */
	}
}

@end


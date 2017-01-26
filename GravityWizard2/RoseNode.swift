//
//  RoseNode.swift
//  GravityWizard2
//
//  Created by scott mehus on 1/15/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import SpriteKit

fileprivate struct PhysicsDefinitions {
    struct ContactTest {
        static let full = PhysicsCategory.Ground | PhysicsCategory.Rock | PhysicsCategory.GravityProjectile
        static let noGround = PhysicsCategory.Rock | PhysicsCategory.GravityProjectile
    }
    
    struct ActionKeys {
        static let walkAction = "WalkAction"
    }
}

class RoseNode: SKSpriteNode, GravityStateTracker {

    var isGrounded = true
    var previousVelocity: CGVector?
    
    var gravityState: GravityState = .ground {
        didSet {
            guard gravityState != oldValue else { return }
            animate(with: gravityState)
        }
    }
    
    func face(towards direction: Direction) {
        switch direction {
        case .left:
            xScale = -1.0
        case .right:
            xScale = 1.0
        default: break
        }
    }
    
    func jump(towards point: CGPoint) {
        
        var xValue = 0
        if point.x > position.x {
            xValue = 50
        } else {
            xValue = -50
        }
        let jumpVector = CGVector(dx: xValue, dy: 1200)
        physicsBody!.applyImpulse(jumpVector)
    }
    
    func hardLanding() {
        guard gravityState == .falling else { return }
        gravityState = .landing
        physicsBody?.velocity = CGVector.zero
        
        let landAction = SKAction.animate(with: [SKTexture(imageNamed: Images.roseHardLanding)], timePerFrame: 0.2)
        let wait = SKAction.afterDelay(0.5, runBlock: runIdleAnimation)
        run(SKAction.sequence([landAction, wait]))
    }
    
    func walk(towards direction: Direction) {
        face(towards: direction)
        let walkAction = SKAction.repeatForever(SKAction.moveBy(x: direction.walkingXVector, y: 0, duration: 0.1))
        run(SKAction.group([walkAction,  walkingAnimation()]), withKey: PhysicsDefinitions.ActionKeys.walkAction)
    }
    
    func stop() {
        removeAction(forKey: PhysicsDefinitions.ActionKeys.walkAction)
        
    }
    
    fileprivate func animate(with state: GravityState) {
        guard gravityState != .landing else { return }
        switch state {
        case .falling:
            runFallingAnimation()
        case .pull:
            runPullAnimation()
        default: return
        }
    }
    
    fileprivate func walkingAnimation() -> SKAction {
        var textures = [SKTexture]()
        for i in 0...5 {
            textures.append(SKTexture(imageNamed: "rose-walking-\(i)"))
        }

        return SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.2, resize: false, restore: true))
    }
    
    fileprivate func runFallingAnimation() {
        removeAction(forKey: gravityState.animationKey)
        let textureImage = SKTexture(imageNamed: Images.roseFalling)
        let textures = [textureImage]
        
        let pullAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        
        let rotateAction = SKAction.rotate(toAngle: 0, duration: 0.2, shortestUnitArc: true)
        run(SKAction.group([pullAnimation, rotateAction]), withKey: gravityState.animationKey)
    }
    
    fileprivate func runIdleAnimation() {
        removeAction(forKey: gravityState.animationKey)
        let textureImage = SKTexture(imageNamed: Images.roseIdle)
        let textures = [textureImage]
        
        let pullAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        run(pullAnimation, withKey: gravityState.animationKey)

    }
    
    fileprivate func runPullAnimation() {
        removeAction(forKey: gravityState.animationKey)
        let textureImage = SKTexture(imageNamed: Images.rosePulled)
        let textures = [textureImage]

        let pullAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        run(pullAnimation, withKey: gravityState.animationKey)
    }

    fileprivate func calculateState(withDelta deltaTime: Double) {
        guard let body = physicsBody else { return }
        if body.velocity.dy < -20 {
            gravityState = .falling
        } else if body.velocity.dy > 50 || body.velocity.dx > 50 || body.velocity.dx < -50 {
            
            
            if body.velocity.dx > 0 {
                face(towards: .right)
                let angle = body.velocity.angle
                let action = SKAction.rotate(toAngle: angle, duration: 0.2, shortestUnitArc: true)
                run(action)
            } else if body.velocity.dx < 0 {
                face(towards: .left)
                let df = body.velocity.angle.radiansToDegrees() + 180
                let angle = df.degreesToRadians()
                let action = SKAction.rotate(toAngle: angle, duration: 0.2, shortestUnitArc: true)
                run(action)
            }
            
            gravityState = .pull
        } else {
            gravityState = .ground
            zRotation = 0
        }
    }
}

extension RoseNode: GameLoopListener {
    func update(withDelta deltaTime: Double) {
        guard let body = physicsBody else { return }
        guard previousVelocity != body.velocity else { return }
        previousVelocity = body.velocity
        calculateState(withDelta: deltaTime)
    }
}

extension RoseNode: LifecycleListener {
    func didMoveToScene() {
        xScale = 1.0
        setPhysicsBody()
    }
}

extension RoseNode {
    fileprivate func setPhysicsBody() {
        let image = #imageLiteral(resourceName: "rose-physics-texture")
        let newtext = SKTexture(image: image)
        physicsBody = SKPhysicsBody(texture: newtext, size: newtext.size())
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.Hero
        physicsBody?.contactTestBitMask = PhysicsDefinitions.ContactTest.full
        physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Rock | PhysicsCategory.Edge
        physicsBody?.fieldBitMask = PhysicsCategory.RadialGravity
        physicsBody?.restitution = 0.0
        physicsBody?.density = 1.0
        physicsBody?.friction = 1.0
    }
}

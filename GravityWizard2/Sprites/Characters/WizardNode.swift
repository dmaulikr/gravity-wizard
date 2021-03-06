//
//  WizardNode.swift
//  GravityWizard2
//
//  Created by scott mehus on 12/20/16.
//  Copyright © 2016 scott mehus. All rights reserved.
//

import SpriteKit

class WizardNode: SKSpriteNode, GravityStateTracker {
    
    var isGrounded = true
    
    var gravityState: GravityState = .ground {
        didSet {
            guard gravityState != oldValue else { return }
            animate(with: gravityState)
        }
    }
    
    func face(towards direction: Direction) {
        switch direction {
        case .left:
            xScale = -abs(xScale)
        case .right:
            xScale = abs(xScale)
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
    
    fileprivate func animate(with state: GravityState) {
        switch state {
        case .climbing:
            runClimbingAnimation()
        case .falling:
            runFallingAnimation()
        case .ground:
            runIdleState()
        default: break
        }
    }
    
    fileprivate func runFallingAnimation() {
        removeAction(forKey: gravityState.animationKey)
        var textures = [SKTexture]()
        for i in 6...10 {
            let texture = SKTexture(imageNamed: "Jump (\(i))")
            textures.append(texture)
        }
        
        let fallingAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        run(fallingAnimation, withKey: GravityState.falling.animationKey)
    }
    
    fileprivate func runClimbingAnimation() {
        removeAction(forKey: gravityState.animationKey)
        var textures = [SKTexture]()
        for i in 1...5 {
            let texture = SKTexture(imageNamed: "Jump (\(i))")
            textures.append(texture)
        }
        
        let jumpAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        run(jumpAnimation, withKey: gravityState.animationKey)
    }
    
    fileprivate func runIdleState() {
        removeAction(forKey: gravityState.animationKey)
        var textures = [SKTexture]()
        for i in 1...10 {
            textures.append(SKTexture(imageNamed: "Idle (\(i))"))
        }
        
        let idleAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        run(SKAction.repeatForever(idleAnimation), withKey: gravityState.animationKey)
    }
    
}

extension WizardNode: LifecycleListener {
    func didMoveToScene() {
        let newSize = texture!.size()
        physicsBody = SKPhysicsBody(rectangleOf: newSize)
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.Hero
        physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Rock | PhysicsCategory.GravityProjectile
        physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Rock | PhysicsCategory.Edge
        physicsBody?.fieldBitMask = PhysicsCategory.RadialGravity
        
    }
}

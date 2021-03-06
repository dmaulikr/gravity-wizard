//
//  BloodNode.swift
//  GravityWizard2
//
//  Created by scott mehus on 12/21/16.
//  Copyright © 2016 scott mehus. All rights reserved.
//

import SpriteKit

class BloodNode: SKSpriteNode {
    
    let removeAction = SKAction.removeFromParent()
    let wait2 = SKAction.wait(forDuration: 2.0)
    let flattenAction = SKAction.scaleX(by: 6.0, y: 0.3, duration: 0.05)
    let blublAction = SKAction.scaleX(by: 1.0, y: 2.0, duration: 0.1)

    class func generateBloodNode() -> BloodNode? {
        guard let scene = SKScene(fileNamed: "Blood") else { return nil }
        guard let node = scene.childNode(withName: "//Blood") as? BloodNode else { return nil}
        node.zPosition = 10
        node.setupGravity()
        return node
    }
    
    func hitGround() {
        physicsBody?.categoryBitMask = PhysicsCategory.None
        run(SKAction.sequence([flattenAction, wait2, removeAction]))
    }
    
    fileprivate func setupGravity() {
        
        physicsBody?.allowsRotation = false
        physicsBody?.friction = 0.2
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = PhysicsCategory.Blood
        physicsBody?.collisionBitMask = PhysicsCategory.Ground
        physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        physicsBody?.fieldBitMask = PhysicsCategory.None
    }
}

extension BloodNode: LifecycleListener {
    func didMoveToScene() {

    }
}

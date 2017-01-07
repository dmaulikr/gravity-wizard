//
//  TreasureChestNode.swift
//  GravityWizard2
//
//  Created by scott mehus on 1/7/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import SpriteKit

class TreasureChestNode: SKSpriteNode {
    
}

extension TreasureChestNode: LifecycleListener {
    func didMoveToScene() {
        physicsBody?.categoryBitMask = PhysicsCategory.TreasureChest
        physicsBody?.contactTestBitMask = PhysicsCategory.Wizard
        physicsBody?.collisionBitMask = PhysicsCategory.None
        physicsBody?.fieldBitMask = PhysicsCategory.None
    }
}

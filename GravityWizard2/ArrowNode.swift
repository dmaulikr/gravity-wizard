//
//  ArrowNode.swift
//  GravityWizard2
//
//  Created by scott mehus on 12/31/16.
//  Copyright © 2016 scott mehus. All rights reserved.
//

import SpriteKit

class ArrowNode: SKSpriteNode {
    
    var isInFlight: Bool = false
    
    init() {
        let texture = SKTexture(pixelImageNamed: Images.arrow_small)
        super.init(texture: texture, color: .white,
                   size: texture.size())
        name = "Arrow"
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width/2, height: texture.size().height/2))
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = PhysicsCategory.Arrow
        physicsBody?.contactTestBitMask = PhysicsCategory.Edge | PhysicsCategory.Ground
        physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Ground
        physicsBody?.fieldBitMask = PhysicsCategory.None
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArrowNode: InFlightTrackable {
    
    func collide() {
        
    }
}

//
//  Level2.swift
//  GravityWizard2
//
//  Created by scott mehus on 1/7/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import SpriteKit

class Level2: GameScene {
    
    var currentLevel: Level {
        return .two
    }
    
    override func levelCompleted() {
        guard let successLevel = LevelCompleteLabel.createLabel(), let scene = scene else { return }
        successLevel.position = scene.zeroAnchoredCenter()
        successLevel.move(toParent: scene)
        
        let presentScene = SKAction.afterDelay(2.0) {
            guard let nextLevel = self.currentLevel.nextLevel()?.levelScene() else { return }
            nextLevel.scaleMode = self.scaleMode
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
            self.view?.presentScene(nextLevel, transition: transition)
            
        }
        
        run(presentScene)
    }
}

extension Level2 {
    
    override func didSimulatePhysics() {
        updateFollowNodePosition(followNode: light, originNode: rose)
    }
}

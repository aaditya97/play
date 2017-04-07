//
//  BattleScene.swift
//  Play
//
//  Created by admin on 07/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import UIKit
import SpriteKit

class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    var pokemon : Pokemon!
    
    override func didMove(to view: SKView) {
        //print("Welcome to the Battle!")
        //print(pokemon.name)
        
        //Background Code
        let battleBg = SKSpriteNode(imageNamed: "bggg")
        battleBg.size = self.size
        battleBg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        battleBg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        battleBg.zPosition = -1
        // adds node to the scene
        self.addChild(battleBg)
        
    }
    
}

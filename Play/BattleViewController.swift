//
//  BattleViewController.swift
//  Play
//
//  Created by admin on 07/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {
    
    var pokemon : Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view = SKView()
        
        let skview = self.view as! SKView
        skview.showsFPS = false
        skview.showsNodeCount = false
        skview.ignoresSiblingOrder = false
        
        scene.pokemon = pokemon
        scene.scaleMode = .aspectFit
        
        skview.presentScene(scene)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    }

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
    var pokemonSprite : SKSpriteNode!
    var pokeballSprite : SKSpriteNode!
    
    
    //define constants
    let kPokemonSize = CGSize(width: 100, height: 100)
    let kPokeballSize = CGSize(width: 80, height: 80)
    
    //define bitcategories
    let kPokeballCategory : UInt32 = 0x1 << 0
    let kPokemonCategory : UInt32 = 0x1 << 1
    let kEdgeCategory : UInt32 = 0x1 << 2
    
    //physics variable setup
    var velocity : CGPoint = CGPoint.zero
    var touchPoint : CGPoint = CGPoint()
    var canThrowPokeball : Bool = false
    
    
    //other variables
    var startCount = false
    var maxTime = 20
    var myTime = 20
    var pokemonCaught = false
    var timeLabel = SKLabelNode(fontNamed: "Helvetica")
    
    
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
        
        self.makeMessageWith(imageName: "battle")
        
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 2.0)
        self.perform(#selector(setupPokeball), with: nil, afterDelay: 2.0)
        
        //physics body setup
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = kEdgeCategory
        
        //physics time label
        self.timeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
        self.addChild(timeLabel)
        
        self.physicsWorld.contactDelegate = self
        
        self.startCount = true
        
    }
    func setupPokemon() {
        self.pokemonSprite = SKSpriteNode(imageNamed: pokemon.imageFileName!)
        self.pokemonSprite.size = kPokemonSize
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.pokemonSprite.zPosition = 1
        
        
        //pokemon physics
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        self.pokemonSprite.physicsBody?.isDynamic = false
        self.pokemonSprite.physicsBody?.affectedByGravity = false
        self.pokemonSprite.physicsBody?.mass = 5.0
        
        // movements
        let moveRight = SKAction.moveBy(x: 100, y: 0, duration: 3.0)
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        self.pokemonSprite.run(SKAction.repeatForever(sequence))
        
        
        //bitmarks
        self.pokemonSprite.physicsBody?.categoryBitMask = kPokemonCategory
        self.pokemonSprite.physicsBody?.collisionBitMask = kEdgeCategory
        self.pokemonSprite.physicsBody?.contactTestBitMask = kPokeballCategory
        
        self.addChild(pokemonSprite)
        
    }
        func setupPokeball(){
        self.pokeballSprite = SKSpriteNode(imageNamed: "pokeball")
        self.pokeballSprite.size = kPokeballSize
        self.pokeballSprite.position = CGPoint(x: self.size.width/2, y: 50)
        self.pokeballSprite.zPosition = 1
        
            
            //setup pokeball physics
            self.pokeballSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokeballSprite.frame.size.width/2)
            self.pokeballSprite.physicsBody?.affectedByGravity = true
            self.pokeballSprite.physicsBody?.isDynamic = true
            self.pokeballSprite.physicsBody?.mass = 0.5
            
            //bitmarks
            self.pokeballSprite.physicsBody?.categoryBitMask = kPokeballCategory
            self.pokeballSprite.physicsBody?.contactTestBitMask = kPokemonCategory
            self.pokeballSprite.physicsBody?.collisionBitMask = kPokemonCategory | kEdgeCategory
            
            self.addChild(pokeballSprite)
            
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if self.pokeballSprite.frame.contains(location!){
            self.canThrowPokeball = true
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
            let touch = touches.first
            let location = touch?.location(in: self)
            self.touchPoint = location!
            
            if self.canThrowPokeball {
                throwPokeball()
                
            }
    }
    
    func throwPokeball () {
        self.canThrowPokeball = false
        let dt : CGFloat = 1.0/50
        let distance = CGVector(dx: self.touchPoint.x - self.pokeballSprite.position.x, dy: self.touchPoint.y - self.pokeballSprite.position.y)
        let  velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
        self.pokeballSprite.physicsBody?.velocity = velocity
        
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case kPokemonCategory | kPokeballCategory :
            print("Pokemon has been caught")
            self.pokemonCaught = true
            endgame()
        default :
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.startCount{
            self.maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
            
        }
        self.myTime = self.maxTime - Int(currentTime)
        self.timeLabel.text = "\(self.myTime)"
        if self.myTime<=0 {
            endgame()
        }
    }
    
    
    func endgame() {
        self.pokeballSprite.removeFromParent()
        self.pokemonSprite.removeFromParent()
        
        if pokemonCaught {
            self.makeMessageWith(imageName: "Gotcha")
            self.pokemon.timeCaught += 1
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

        }else {
            self.makeMessageWith(imageName: "footprints")
            
        }
        
        self.perform(#selector(endbattle), with: nil, afterDelay: 3.0)
    }
    
    func endbattle() {
        NotificationCenter.default.post(name: NSNotification.Name("CloseBattle"), object: nil)
    }
    
    func makeMessageWith(imageName : String){
        let message = SKSpriteNode (imageNamed: imageName)
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        message.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()]))
        
        self.addChild(message)
    }

}


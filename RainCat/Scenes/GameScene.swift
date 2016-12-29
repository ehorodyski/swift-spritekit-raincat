//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Modified by Eric Horodyski on 12/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // Private Variables
    private var lastUpdateTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.5
    private let backgroundNode = BackgroundNode()

    // Public Variables
    public let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    // Interface Overrides
    override func sceneDidLoad() {
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.lastUpdateTime = 0
        self.backgroundNode.setup(size: size)
        
        addChild(backgroundNode)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        // Update the Spawn Timer
        currentRainDropSpawnTime += dt

        // Add a raindrop after the delta time is greater than rainDropSpawnRate
        if (currentRainDropSpawnTime > rainDropSpawnRate) {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }
        
        self.lastUpdateTime = currentTime
    }
    
    // Public Methods
    public func didBegin(_ contact: SKPhysicsContact) {
        
        // Detect when a rain drop collides with the edge of any object then remove the ability to collide
        if(contact.bodyA.categoryBitMask == RainDropCategory) {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if(contact.bodyB.categoryBitMask == RainDropCategory) {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        // Remove the raindrop from memory
        if(contact.bodyA.categoryBitMask == WorldCategory) {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if(contact.bodyB.categoryBitMask == WorldCategory) {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }

    
    // Private Methods
    private func spawnRaindrop() {
        let raindrop = SKSpriteNode(texture: raindropTexture)
        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
        let yPosition = size.height + raindrop.size.height
        
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        raindrop.zPosition = 2
        
        addChild(raindrop)
    }
    
}

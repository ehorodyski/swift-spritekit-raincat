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
    private var lastUpdateTime: TimeInterval = 0
    private var currentRainDropSpawnTime: TimeInterval = 0
    private var rainDropSpawnRate: TimeInterval = 0.5
    private var foodEdgeMargin: CGFloat = 75.0
    private let backgroundNode = BackgroundNode()
    private let umbrellaNode = UmbrellaSprite.newInstance()
    private var catNode: CatSprite!
    private var foodNode: FoodSprite!

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
        
        umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
        umbrellaNode.zPosition = 4
        
        addChild(backgroundNode)
        addChild(umbrellaNode)
        
        spawnCat()
        spawnFood()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
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
        umbrellaNode.update(deltaTime: dt)
        catNode.update(deltaTime: dt, foodLocation: foodNode.position)
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
        
        // Handle Cat contact
        if(contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory) {
            handleCatCollision(contact: contact)
            return
        }
        
        // Handle Food contact
        if(contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory) {
            handleFoodHit(contact: contact)
            return
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
        raindrop.physicsBody?.density = 0.5
        raindrop.zPosition = 2
        
        addChild(raindrop)
    }
    
    private func spawnCat() {
        
        // If cat node is already initialized, remove it.
        if let currentCat = catNode, children.contains(currentCat) {
            catNode.removeFromParent()
            catNode.removeAllActions()
            catNode.physicsBody = nil
        }
        
        // Spawn the cat node.
        catNode = CatSprite.newInstance()
        catNode.position = CGPoint(x: umbrellaNode.position.x, y: umbrellaNode.position.y - 30)
        
        addChild(catNode)
    }
    
    private func spawnFood() {
        
        // If food is already initialized, remove it.
        if let currentFood = foodNode, children.contains(currentFood) {
            foodNode.removeFromParent()
            foodNode.removeAllActions()
            foodNode.physicsBody = nil
        }
        
        foodNode = FoodSprite.newInstance()
        
        var randomPosition: CGFloat = CGFloat(arc4random())
        randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2)
        randomPosition += foodEdgeMargin
        
        foodNode.position = CGPoint(x: randomPosition, y: size.height)
        
        addChild(foodNode)
    }
    
    private func handleCatCollision(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask == CatCategory) {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case RainDropCategory:
            catNode.hitByRain()
        case WorldCategory:
            spawnCat()
        default:
            print("Something hit the cat")
        }
    }
    
    private func handleFoodHit(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        var foodBody: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask == FoodCategory) {
            otherBody = contact.bodyB
            foodBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            foodBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
        case CatCategory:
            // TODO: Increment Points
            print("Fed cat")
            fallthrough
        case WorldCategory:
            foodBody.node?.removeFromParent()
            foodBody.node?.physicsBody = nil
            spawnFood()
        default:
            print("Something else touched the food")
        }
    }
    
}

//
//  CatSprite.swift
//  RainCat
//
//  Created by Eric on 1/1/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

public class CatSprite: SKSpriteNode {
    
    // Constants
    private let MOVEMENT_SPEED: CGFloat = 100
    private let MAX_FLAIL_TIME: TimeInterval = 2
    private let ROTATE_ACTION_KEY = "action_rotate"
    private let WALKING_ACTION_KEY = "action_walking"
    private let WALKING_FRAMES = [SKTexture(imageNamed: "cat_one"), SKTexture(imageNamed: "cat_two")]
    
    // Private Variables
    private var timeSinceLastHit: TimeInterval = 2
    
    // Static Functions
    public static func newInstance() -> CatSprite {
        let catSprite = CatSprite(imageNamed: "cat_one")
        
        catSprite.zPosition = 5
        catSprite.physicsBody = SKPhysicsBody(circleOfRadius: catSprite.size.width / 2)
        catSprite.physicsBody?.categoryBitMask = CatCategory
        catSprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldCategory
        
        return catSprite
    }
    
    // Public Methods
    public func update(deltaTime: TimeInterval, foodLocation: CGPoint) {
        // Update last hit interval
        self.timeSinceLastHit += deltaTime
        
        // If the time since last hit is greater than or equal the cool-down time, set the animation
        if(self.timeSinceLastHit >= MAX_FLAIL_TIME) {
            // Rotate cat back into position
            if(zRotation != 0 && action(forKey: ROTATE_ACTION_KEY) == nil) {
                run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: ROTATE_ACTION_KEY)
            }
            
            // Initialize walking cat animation
            if action(forKey: WALKING_ACTION_KEY) == nil {
                    run(SKAction.repeatForever(
                        SKAction.animate(with: WALKING_FRAMES, timePerFrame: 0.1, resize: false, restore: true)),
                        withKey: WALKING_ACTION_KEY)
            }
        }
        
        // Move cat in interval and flip x-axis if needed.
        if (foodLocation.y > position.y && abs(foodLocation.x - position.x) < 2) {
            self.physicsBody?.velocity.dx = 0
            removeAction(forKey: WALKING_ACTION_KEY)
            texture = WALKING_FRAMES[1]
        } else if(foodLocation.x < position.x) {
            // The food is to the left of the cat.
            position.x -= MOVEMENT_SPEED * CGFloat(deltaTime)
            xScale = -1
        } else {
            // The food is to the right of the cat.
            position.x += MOVEMENT_SPEED * CGFloat(deltaTime)
            xScale = 1
        }
        // Keep the cat on the floor.
        self.physicsBody?.angularVelocity = 0
    }
    
    public func hitByRain() {
        self.timeSinceLastHit = 0
        removeAction(forKey: WALKING_ACTION_KEY)
    }
}

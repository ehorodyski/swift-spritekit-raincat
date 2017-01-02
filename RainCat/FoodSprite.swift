//
//  FoodSprite.swift
//  RainCat
//
//  Created by Eric on 1/1/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

public class FoodSprite: SKSpriteNode {

    // Static Methods
    public static func newInstance() -> FoodSprite {
        let foodDish = FoodSprite(imageNamed: "food_dish")
        
        foodDish.physicsBody = SKPhysicsBody(rectangleOf: foodDish.size)
        foodDish.physicsBody?.categoryBitMask = FoodCategory
        foodDish.physicsBody?.contactTestBitMask = WorldCategory | RainDropCategory | CatCategory
        foodDish.zPosition = 5
        
        return foodDish
    }
    
}

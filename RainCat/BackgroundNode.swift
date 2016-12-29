//
//  BackgroundNode.swift
//  RainCat
//
//  Created by Eric on 12/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class BackgroundNode: SKNode {
    
    // Public Functions
    public func setup(size: CGSize) {
        
        let yPos: CGFloat = size.height * 0.10
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0.3
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = RainDropCategory
    }

}

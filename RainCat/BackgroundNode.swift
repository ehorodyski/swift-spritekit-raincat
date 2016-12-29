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
        let skyNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: size ))
        let groundSize = CGSize(width: size.width, height: size.height * 0.35)
        let groundNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: groundSize))
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0.3
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = RainDropCategory
        
        skyNode.fillColor = SKColor(red: 0.38, green: 0.60, blue: 0.65, alpha: 1.0)
        skyNode.strokeColor = SKColor.clear
        skyNode.zPosition = 0
        
        groundNode.fillColor = SKColor(red: 0.99, green: 0.92, blue: 0.55, alpha: 1.0)
        groundNode.strokeColor = SKColor.clear
        groundNode.zPosition = 1
        
        addChild(skyNode)
        addChild(groundNode)
    }

}

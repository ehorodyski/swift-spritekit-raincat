//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by Eric on 12/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class UmbrellaSprite : SKSpriteNode {

    public static func newInstance() -> UmbrellaSprite {
        let umbrella = UmbrellaSprite(imageNamed: "umbrella")
        let path = UIBezierPath()
        
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
        path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
        path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))

        umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        umbrella.physicsBody?.isDynamic = false
        umbrella.physicsBody?.restitution = 0.9
        
        return umbrella
    }

}

//
//  Actor.swift
//  Engine
//
//  Created by Nick Lockwood on 09/07/2019.
//  Copyright © 2019 Nick Lockwood. All rights reserved.
//

public protocol Actor {
    var radius: Double { get }
    var position: Vector { get set }
    var isDead: Bool { get }
}

public extension Actor {
    var rect: Rect {
        let halfSize = Vector(x: radius, y: radius)
        return Rect(min: position - halfSize, max: position + halfSize)
    }

    func intersection(with map: Tilemap) -> Vector? {
        let actorRect = self.rect
        let minX = Int(actorRect.min.x), maxX = Int(actorRect.max.x)
        let minY = Int(actorRect.min.y), maxY = Int(actorRect.max.y)
        for y in minY ... maxY {
            for x in minX ... maxX where map[x, y].isWall {
                let wallRect = Rect(
                    min: Vector(x: Double(x), y: Double(y)),
                    max: Vector(x: Double(x + 1), y: Double(y + 1))
                )
                if let intersection = actorRect.intersection(with: wallRect) {
                    return intersection
                }
            }
        }
        return nil
    }

    func intersection(with door: Door) -> Vector? {
        return rect.intersection(with: door.rect)
    }

    func intersection(with world: World) -> Vector? {
        if let intersection = intersection(with: world.map) {
            return intersection
        }
        for door in world.doors {
            if let intersection = intersection(with: door) {
                return intersection
            }
        }
        return nil
    }

    func intersection(with actor: Actor) -> Vector? {
        if isDead || actor.isDead {
            return nil
        }
        return rect.intersection(with: actor.rect)
    }

    mutating func avoidWalls(in world: World) {
        var attempts = 10
        while attempts > 0, let intersection = intersection(with: world) {
            position -= intersection
            attempts -= 1
        }
    }
}

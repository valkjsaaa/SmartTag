//
//  ShortestPath.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/31/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import Foundation

func ShortestPath(graph: [[Bool]], start: (Int, Int), end: (Int,Int)) -> [(Int, Int)]? {
    guard graph[start.0][start.1] && graph[end.0][end.1] else {
        return nil
    }
    let height = graph.count
    let width = graph[0].count
    func nearbyPoints(_ point: (Int, Int)) -> [(Int, Int)] {
        let (x, y) = point
        let surroundingPoints = [(x, y - 1),
                                 (x - 1, y), (x + 1, y),
                                 (x, y + 1)]
        return surroundingPoints.filter { (point) -> Bool in
            let (x, y) = point
            return x > 0 && x < width && y > 0 && y < height
        }
    }
    let unreached = (-1, -1)
    var map = [[(Int, Int)]].init(repeating: [(Int, Int)].init(repeating: unreached, count: width), count: height)
    var queue = [start]
    map[start.0][start.1] = start
    while !queue.isEmpty {
        let thisPoint = queue.first!
        if thisPoint == end {
            break
        }
        let availablePoints = nearbyPoints(thisPoint).filter({ (point) -> Bool in
            return map[point.0][point.1] == unreached && graph[point.0][point.1] == true
        })
        for point in availablePoints {
            map[point.0][point.1] = thisPoint
            queue.append(point)
        }
        queue.removeFirst()
    }
    var currentPoint = map[end.0][end.1]
    if currentPoint == unreached {
        return nil
    }
    var pathPoints = [end]
    while currentPoint != map[currentPoint.0][currentPoint.1] {
        pathPoints.append(currentPoint)
        currentPoint = map[currentPoint.0][currentPoint.1]
    }
    pathPoints.append(currentPoint)
    return pathPoints
}

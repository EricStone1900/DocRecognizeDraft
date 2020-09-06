//
//  MMCropView.swift
//  Scanpro1
//
//  Created by song on 2019/6/23.
//  Copyright © 2019年 song. All rights reserved.
//

import UIKit

class MMCropView: UIView {
    let kCropButtonSize: CGFloat = 30.0
//    private var touchOffset: CGPoint?
    private var a,b,c,d: CGPoint!
    
    //middle
    private var e,f,g,h: CGPoint!
    private var frameMoved = false ,middlePoint = false
    private var currentIndex: Int = 0,previousIndex: Int = 0
    private var k: Int = 0
    
    var activePoint: UIView?
    var pointA,pointB,pointC,pointD: UIView!
    
    //middle points
    var pointE,pointF,pointG,pointH: UIView!
    var points = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        pointA = UIView(frame: CGRect.zero)
//        pointA.alpha = 0.5
//        pointB = UIView()
//        pointB.alpha = 0.5
//        pointC = UIView()
//        pointC.alpha = 0.5
//        pointD = UIView()
//        pointD.alpha = 0.5
//
//        //middle Points
//        pointE = UIView()
//        pointE.alpha = 0.5
//        pointF = UIView()
//        pointF.alpha = 0.5
//        pointG = UIView()
//        pointG.alpha = 0.5
//        pointH = UIView()
//        pointH.alpha = 0.5
        pointA = UIView(frame: CGRect.zero)
        pointA.alpha = 0.5
        pointB = UIView(frame: CGRect.zero)
        pointB.alpha = 0.5
        pointC = UIView(frame: CGRect.zero)
        pointC.alpha = 0.5
        pointD = UIView(frame: CGRect.zero)
        pointD.alpha = 0.5
        
        //middle Points
        pointE = UIView(frame: CGRect.zero)
        pointE.alpha = 0.5
        pointF = UIView(frame: CGRect.zero)
        pointF.alpha = 0.5
        pointG = UIView(frame: CGRect.zero)
        pointG.alpha = 0.5
        pointH = UIView(frame: CGRect.zero)
        pointH.alpha = 0.5
        
        pointA.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        pointB.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        pointC.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        pointD.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        
        pointE.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        pointF.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        pointG.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        pointH.layer.cornerRadius = CGFloat(kCropButtonSize/2)
        
        self.addSubview(pointA)
        self.addSubview(pointB)
        self.addSubview(pointC)
        self.addSubview(pointD)
        self.addSubview(pointE)
        self.addSubview(pointF)
        self.addSubview(pointG)
        self.addSubview(pointH)
        
        //8个按钮数组顺序（下-》上）
        points.append(pointD)
        points.append(pointC)
        points.append(pointB)
        points.append(pointA)
        
        points.append(pointE)
        points.append(pointF)
        points.append(pointG)
        points.append(pointH)
        
        //color
        pointA.backgroundColor = .gray
        pointB.backgroundColor = .gray
        pointC.backgroundColor = .gray
        pointD.backgroundColor = .gray
        
        pointE.backgroundColor = .gray
        pointF.backgroundColor = .gray
        pointG.backgroundColor = .gray
        pointH.backgroundColor = .gray
        
        setupPoints()
        self.clipsToBounds = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.contentMode = .redraw
        setupButtons()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: public open
    func frameEdited() -> Bool {
        return frameMoved
    }
    
    func resetFrame() {
        setupPoints()
        self.setNeedsDisplay()
        self.draw(self.bounds)
        setupButtons()
    }
    
    func coordinatesForPoint(point:Int, scaleFactor:CGFloat) -> CGPoint {
        var tmp = CGPoint(x: 0, y: 0)
        switch point {
        case 1:
            tmp = CGPoint(x: ((pointA?.frame.origin.x)!+15) / scaleFactor, y: ((pointA?.frame.origin.y)!+15) / scaleFactor)
        case 2:
            tmp = CGPoint(x: ((pointB?.frame.origin.x)!+15) / scaleFactor, y: ((pointB?.frame.origin.y)!+15) / scaleFactor)
        case 3:
            tmp = CGPoint(x: ((pointC?.frame.origin.x)!+15) / scaleFactor, y: ((pointC?.frame.origin.y)!+15) / scaleFactor)
        case 4:
            tmp = CGPoint(x: ((pointD?.frame.origin.x)!+15) / scaleFactor, y: ((pointD?.frame.origin.y)!+15) / scaleFactor)
        default: break
        }
        return tmp

    }
    
    func coordinatesForPointIndex(point: Int) -> CGPoint {
        var tmp = CGPoint(x: 0, y: 0)
        switch point {
        case 1:
            tmp = a
        case 2:
            tmp = b
        case 3:
            tmp = c
        case 4:
            tmp = d
        default: break
        }
        return tmp
    }
    
    func bottomLeftCornerToCGPoint(point:CGPoint) {
        a = point
        needsRedraw()
    }
    
    func bottomRightCornerToCGPoint(point:CGPoint) {
        b = point
        needsRedraw()
    }
    
    func topRightCornerToCGPoint(point:CGPoint) {
        c = point
        needsRedraw()
    }
    
    func topLeftCornerToCGPoint(point:CGPoint) {
        d = point
        needsRedraw()
    }
    
    func checkangle(index: Int) {
        let points = getAllPoints()
        var p1:CGPoint!
        var p2:CGPoint!
        var p3:CGPoint!
        k = 0
        
        for (index, _) in points.enumerated() {
            switch index {
            case 0:
                p1 = points[0]
                p2 = points[1]
                p3 = points[3]
            case 1:
                p1 = points[1]
                p2 = points[2]
                p3 = points[0]
            case 2:
                p1 = points[2]
                p2 = points[3]
                p3 = points[1]
            default:
                p1 = points[3]
                p2 = points[0]
                p3 = points[2]
            }
            let ab = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
            let cb = CGPoint(x: p2.x - p3.x, y: p2.y - p3.y)
            let dot = (ab.x * cb.x + ab.y * cb.y)// dot product
            let cross = (ab.x * cb.y - ab.y * cb.x) // cross product
            let alpha = atan2(cross, dot)
            
            if (-1 * (Double)(floor(alpha*180.0/3.14 + 0.5))) < 0 {
                k += 1
            }
            
        }
        
        if k>=2 {
            swapTwoPoints()
        }
        
        previousIndex = currentIndex
    }
    
    private func swapTwoPoints() {
        if k==2 {
            print("Swicth  2")
            if checkForHorizontalIntersection() {
                let temp0 = points[0].frame
                let temp3 = points[3].frame
                points[0].frame = temp3
                points[3].frame = temp0
                checkangle(index: 0)
                cornerControlsMiddle()
                self.setNeedsDisplay()
            }
            if checkForVerticalIntersection() {
                let temp0 = points[2].frame
                let temp3 = points[3].frame
                points[2].frame = temp3
                points[3].frame = temp0
                checkangle(index: 0)
                cornerControlsMiddle()
                self.setNeedsDisplay()
            }
        }else {
            print("Swicth More then 2")
            let temp2 = points[2].frame
            let temp0 = points[0].frame
            if temp2.size == .zero || temp0.size == .zero {
                print("size wei 0")
            }
            points[0].frame = temp2
            points[2].frame = temp0
            checkangle(index: 0)
            cornerControlsMiddle()
            self.setNeedsDisplay()
        }
        
    }

    private func checkForHorizontalIntersection() -> Bool {
        let line1 = CGLineMake(CGPoint(x: points[0].frame.origin.x, y: points[0].frame.origin.y), CGPoint(x: points[1].frame.origin.x, y: points[1].frame.origin.y))
        
        let line2 = CGLineMake(CGPoint(x: points[2].frame.origin.x, y: points[2].frame.origin.y), CGPoint(x: points[3].frame.origin.x, y: points[3].frame.origin.y))
        
        let temp = CGLinesIntersectAtPoint(line1, line2)
        //https://stackoverflow.com/questions/24028450/infinity-in-swift-lang
        let infinity = CGFloat.infinity
        if temp.x != infinity && temp.y != infinity{
            return true
        }
        return false
        
    }
    
    private func checkForVerticalIntersection() -> Bool {
        let line3 = CGLineMake(CGPoint(x: points[0].frame.origin.x, y: points[0].frame.origin.y), CGPoint(x: points[3].frame.origin.x, y: points[3].frame.origin.y))
        
        let line4 = CGLineMake(CGPoint(x: points[2].frame.origin.x, y: points[2].frame.origin.y), CGPoint(x: points[1].frame.origin.x, y: points[1].frame.origin.y))
        
        let temp = CGLinesIntersectAtPoint(line3, line4)
        //https://stackoverflow.com/questions/24028450/infinity-in-swift-lang
        let infinity = CGFloat.infinity
        if temp.x != infinity && temp.y != infinity{
            return true
        }
        return false
        
    }
    
    //MARK: Support methods
    func findPointAtLocation(location: CGPoint) {
        activePoint?.backgroundColor = .blue
        activePoint = nil
        var smallestDistance = CGFloat.infinity
        var i = 0
        for point in points {
            //https://stackoverflow.com/questions/48671062/convert-swift-2-3-to-swift-4?noredirect=1&lq=1
            let extentedFrame = point.frame.insetBy(dx: -20, dy: -20)
            if extentedFrame.contains(location) {
                let distanceToThis = distanceBetween(first: point.frame.origin, last: location)
                print("Distance:\(distanceToThis)")
                if distanceToThis < smallestDistance {
                    activePoint = point
                    smallestDistance = distanceToThis
                    currentIndex = i
                    if i == 4 || i == 5 || i == 6 || i == 7 {
                        middlePoint = true
                    }else {
                        middlePoint = false
                    }
                }
            }
            i += 1
        }
        guard let activePoint = activePoint else {
            return
        }
        activePoint.backgroundColor = .red
        print("Active Point:\(activePoint)")

    }
    
    func moveActivePointToLocation(locationPoint: CGPoint) {
        var newX = locationPoint.x
        var newY = locationPoint.y
        if newX < self.bounds.origin.x {
            newX = self.bounds.origin.x
        }else if newX > self.frame.width {
            newX = self.frame.width
        }
        
        if newY < self.bounds.origin.y {
            newY = self.bounds.origin.y
        }else if newY > self.frame.height {
            newY = self.frame.height
        }
        let locationPoint = CGPoint(x: newX, y: newY)
        if activePoint != nil && !middlePoint {
            activePoint?.frame = CGRect(x: locationPoint.x - kCropButtonSize/2, y: locationPoint.y - kCropButtonSize/2, width: kCropButtonSize, height: kCropButtonSize)
            cornerControlsMiddle()
        }else {
            if checkForNeighbouringPoints(index: currentIndex) != 0 {
                movePointsForMiddle(locationPoint: locationPoint)
            }
        }
        self.setNeedsDisplay()
    }
    
    private func distanceBetween(first:CGPoint,last:CGPoint) -> CGFloat {
        var xDist = last.x - first.x
        if xDist<0 {
            xDist = -1 * xDist
        }
        var yDist = last.y - first.y
        if yDist<0 {
            yDist = -1 * yDist
        }
        return sqrt((xDist*xDist) + (yDist * yDist))
    }
    
    private func setupPoints() {
        a = CGPoint(x: 0 + 0, y: self.bounds.height - 0)
        b = CGPoint(x: self.bounds.width - 0, y: self.bounds.height - 0)
        c = CGPoint(x: self.bounds.width - 0, y: 0 + 0)
        d = CGPoint(x: 0 + 0, y: 0 + 0)
        
        e = CGPoint(x: (a.x+b.x)/2, y: a.y)
        f = CGPoint(x: b.x, y: 0 + (b.y + c.y)/2)
        g = CGPoint(x: (c.x + d.x)/2, y: 0 + c.y)
        h = CGPoint(x: a.x, y: 0 + (a.y + d.y)/2)
        
    }
    
    private func setupButtons() {
        pointD.frame = CGRect(x: d.x - CGFloat(kCropButtonSize/2),y: d.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
        pointC.frame = CGRect(x: c.x - CGFloat(kCropButtonSize/2),y: c.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
        pointB.frame = CGRect(x: b.x - CGFloat(kCropButtonSize/2),y: b.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
        pointA.frame = CGRect(x: a.x - CGFloat(kCropButtonSize/2),y: a.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
        
        pointE.frame = CGRect(x: e.x - CGFloat(kCropButtonSize/2),y: e.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
        pointF.frame = CGRect(x: f.x - CGFloat(kCropButtonSize/2),y: f.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
        pointG.frame = CGRect(x: g.x - CGFloat(kCropButtonSize/2),y: g.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
        pointH.frame = CGRect(x: h.x - CGFloat(kCropButtonSize/2),y: h.y - CGFloat(kCropButtonSize/2), width: kCropButtonSize, height: kCropButtonSize)
    }
    
    private func getAllPoints() -> [CGPoint] {
        var p = [CGPoint]()
        
//        for itemView in self.points {
//            print("item =\(itemView)")
//            let point = CGPoint(x: itemView.frame.origin.x + kCropButtonSize/2, y: itemView.frame.origin.y + kCropButtonSize/2)
//            p.append(NSValue(cgPoint: point))
//        }
        for (_, value) in points.enumerated() {
            let point = CGPoint(x: value.frame.origin.x + kCropButtonSize/2, y: value.frame.origin.y + kCropButtonSize/2)
            p.append(point)
        }
        return p
    }
    
    func squareButtonWithWidth(width:Int) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: width), false, 0)
        let blank = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blank
    }
    
    private func needsRedraw() {
        self.setNeedsDisplay()
        setupButtons()
        cornerControlsMiddle()
        self.draw(self.bounds)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            print("error...")
            return
        }

        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
        if checkForNeighbouringPoints(index: currentIndex) >= 0 {
            frameMoved = true
            context.setStrokeColor(red: 0.1294, green: 0.588, blue: 0.9529, alpha: 1.0)
        }else {
            frameMoved = false
            context.setStrokeColor(red: 0.9568, green: 0.262, blue: 0.211, alpha: 1.0)
        }
        context.setLineJoin(.round)
        context.setLineWidth(4.0)
        
        let boundingRect = context.boundingBoxOfClipPath
        context.addRect(boundingRect)
        context.fill(boundingRect)
        
        let pathRef = CGMutablePath.init()
        pathRef.move(to: CGPoint(x: pointA.frame.origin.x + 15, y: pointA.frame.origin.y + 15))
        pathRef.addLine(to: CGPoint(x: pointB.frame.origin.x + 15, y: pointB.frame.origin.y + 15))
        pathRef.addLine(to: CGPoint(x: pointC.frame.origin.x + 15, y: pointC.frame.origin.y + 15))
        pathRef.addLine(to: CGPoint(x: pointD.frame.origin.x + 15, y: pointD.frame.origin.y + 15))
        
        pathRef.closeSubpath()
        context.addPath(pathRef)
        context.strokePath()
        context.setBlendMode(.clear)
        
        context.addPath(pathRef)
        context.fillPath()
        context.setBlendMode(.normal)
        
    }
    
    
    //MARK: Condition For Valid Rect
    private func checkForNeighbouringPoints(index:Int) -> Double {
        let points = getAllPoints()
        var p1:CGPoint!
        var p2:CGPoint!
        var p3:CGPoint!
        for (index, _) in points.enumerated() {
            switch index {
            case 0:
                p1 = points[0]
                p2 = points[1]
                p3 = points[3]
            case 1:
                p1 = points[1]
                p2 = points[2]
                p3 = points[0]
            case 2:
                p1 = points[2]
                p2 = points[3]
                p3 = points[1]
            default:
                p1 = points[3]
                p2 = points[0]
                p3 = points[2]
            }
            let ab = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
            let cb = CGPoint(x: p2.x - p3.x, y: p2.y - p3.y)
            let dot = (ab.x * cb.x + ab.y * cb.y)// dot product
            let cross = (ab.x * cb.y - ab.y * cb.x) // cross product
            let alpha = atan2(cross, dot)
            
            if (-1 * (Double)(floor(alpha*180.0/3.14 + 0.5))) < 0 {
                return (-1 * (Double)(floor(alpha*180.0/3.14 + 0.5)))
            }
           
        }
        return 0
    }
    
    //Corner Touch
    private func cornerControlsMiddle() {
        pointE?.frame = CGRect(x: (pointA!.frame.origin.x + pointB!.frame.origin.x)/2, y: (pointA!.frame.origin.y + pointB!.frame.origin.y)/2, width: kCropButtonSize, height: kCropButtonSize)
        pointG?.frame = CGRect(x: (pointC!.frame.origin.x + pointD!.frame.origin.x)/2, y: (pointC!.frame.origin.y + pointD!.frame.origin.y)/2, width: kCropButtonSize, height: kCropButtonSize)
        pointF?.frame = CGRect(x: (pointB!.frame.origin.x + pointC!.frame.origin.x)/2, y: (pointB!.frame.origin.y + pointC!.frame.origin.y)/2, width: kCropButtonSize, height: kCropButtonSize)
        pointH?.frame = CGRect(x: (pointA!.frame.origin.x + pointD!.frame.origin.x)/2, y: (pointA!.frame.origin.y + pointD!.frame.origin.y)/2, width: kCropButtonSize, height: kCropButtonSize)
    }
    
    ////Middle Touch
    private func movePointsForMiddle(locationPoint:CGPoint) {
        switch currentIndex {
        case 4:
            // 2 and 3
            pointA?.frame = CGRect(x: pointA!.frame.origin.x, y: locationPoint.y - kCropButtonSize/2, width: kCropButtonSize, height: kCropButtonSize)
            pointB?.frame = CGRect(x: pointB!.frame.origin.x, y: locationPoint.y - kCropButtonSize/2, width: kCropButtonSize, height: kCropButtonSize)
        case 5:
            // 1 and 2
            pointB?.frame = CGRect(x: locationPoint.x - kCropButtonSize/2, y: pointB!.frame.origin.y, width: kCropButtonSize, height: kCropButtonSize)
            pointC?.frame = CGRect(x: locationPoint.x - kCropButtonSize/2, y: pointC!.frame.origin.y, width: kCropButtonSize, height: kCropButtonSize)
        case 6:
            // 3 and 4
            pointC?.frame = CGRect(x: pointC!.frame.origin.x, y: locationPoint.y - kCropButtonSize/2, width: kCropButtonSize, height: kCropButtonSize)
            pointD?.frame = CGRect(x: pointD!.frame.origin.x, y: locationPoint.y - kCropButtonSize/2, width: kCropButtonSize, height: kCropButtonSize)
        case 7:
            // 1 and 4
            pointA?.frame = CGRect(x: locationPoint.x - kCropButtonSize/2, y: pointA!.frame.origin.y, width: kCropButtonSize, height: kCropButtonSize)
            pointD?.frame = CGRect(x: locationPoint.x - kCropButtonSize/2, y: pointD!.frame.origin.y, width: kCropButtonSize, height: kCropButtonSize)
        default:
            break
        }
        cornerControlsMiddle()
    }
}

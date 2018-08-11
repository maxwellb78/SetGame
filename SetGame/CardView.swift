//
//  CardView.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/28/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var symbol: Int = 2 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var shading: Int = 2 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var color: Int = 1 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var numberOfSymbols: Int = 2 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var superViewBackgroundColor: UIColor = UIColor.clear {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var isSelected: Bool = false {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var cardNumber: Int = 0
    private var cardBackgroundColor: UIColor = UIColor.white
    private var selectedColor: UIColor = UIColor.red
    
    
    
    override func draw(_ rect: CGRect) {
        //set the background of the view to the same color as the super view
        let background = UIBezierPath(rect: bounds)
        background.addClip()
        superViewBackgroundColor.setFill()
        superViewBackgroundColor.setStroke()
        background.lineWidth = 0
        background.stroke()
        background.fill()
        
        //Used a rounded rectangle to get the card
        let roundedRect = UIBezierPath(roundedRect: roundedRectBounds, cornerRadius: cornerRadius)
        if isSelected {
            selectedColor.setStroke()
            roundedRect.lineWidth = 8.0
            roundedRect.stroke()
        }
        cardBackgroundColor.setFill()
        roundedRect.fill()

        
        //the Rects for the symbols and add the shapes
        let rects = rectForSymbol(numberOfSymbols)
        for rect in rects {
            var path = UIBezierPath()
            switch symbol {
            case 0: path = polygon(rect)
            case 1: path = oval(rect)
            case 2: path = circle(rect)
            default: break
            }
            path.lineWidth = 2.0
            symbolColor().setStroke()
            
            //Adding the Shading
            UIGraphicsGetCurrentContext()?.saveGState()
            path.addClip()
            shading(path, rect)
            path.stroke()
            UIGraphicsGetCurrentContext()?.restoreGState()
            
        }
        
    }
    
    private func rectForSymbol(_ rectLoc: Int) -> [CGRect] {
        let symbolRectHeight = cardRectWithinRoundedRect.height / 3
        var rects = [CGRect]()
        switch rectLoc {
        case 0:
            rects.append(CGRect(x: cardRectWithinRoundedRect.minX, y: cardRectWithinRoundedRect.minY + symbolRectHeight, width: cardRectWithinRoundedRect.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset))
        case 1:
            rects.append(CGRect(x: cardRectWithinRoundedRect.minX, y: cardRectWithinRoundedRect.minY + (symbolRectHeight / 2), width: cardRectWithinRoundedRect.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset))
            rects.append(CGRect(x: cardRectWithinRoundedRect.minX, y: cardRectWithinRoundedRect.minY + (symbolRectHeight / 2) + symbolRectHeight, width: cardRectWithinRoundedRect.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset))

        case 2:
            rects.append(CGRect(x: cardRectWithinRoundedRect.minX, y: cardRectWithinRoundedRect.minY, width: cardRectWithinRoundedRect.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset))
            rects.append(CGRect(x: cardRectWithinRoundedRect.minX, y: cardRectWithinRoundedRect.minY + symbolRectHeight, width: cardRectWithinRoundedRect.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset))
            rects.append(CGRect(x: cardRectWithinRoundedRect.minX, y: symbolRectHeight * 2 + cardRectWithinRoundedRect.minY, width: cardRectWithinRoundedRect.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset))
        default:
            break
        }
        return rects
    }
    
    private func polygon(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: rect.minX, y: rect.height / 2 + rect.minY))
        path.addLine(to: CGPoint(x: rect.width / 2 + rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height / 2 + rect.minY))
        path.addLine(to: CGPoint(x: rect.width / 2 + rect.minX, y: rect.maxY))
        path.close()

        return path
    }
    
    private func oval(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: rect)
        return path
    }
    
    private func circle(_ rect: CGRect) -> UIBezierPath{
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.height / 2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        return path
    }
    
    
    private func shading(_ path: UIBezierPath,_ rect: CGRect){
        switch shading {
        // Just outline
        case 0:
            cardBackgroundColor.setFill()
        // Filled In
        case 1:
            symbolColor().setFill()
            path.fill()
        // Filled with Lines
        case 2:
            fillWithLines(path, rect)
        default:
            cardBackgroundColor.setFill()
        }
    }
    
    private func fillWithLines(_ path: UIBezierPath,_ rect: CGRect){
        var topX = rect.minX
        
        for _ in 1...Int((rect.width / ViewRatios.fillWithLinesSpacing) + 10) {
            topX += ViewRatios.fillWithLinesSpacing
            path.move(to: CGPoint(x: topX, y: rect.minY))
            path.addLine(to: CGPoint(x: topX - ViewRatios.fillWithLinesSpacing - 25, y: rect.maxY))
        }
        
    }

    
    private func test (_ rect: CGRect,_ aColor: UIColor) {
        let path = UIBezierPath(rect: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = aColor.cgColor
        shapeLayer.fillColor = cardBackgroundColor.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    private func symbolColor() -> UIColor {
        switch color {
        case 0:
            return UIColor.green
        case 1:
            return UIColor.red
        case 2:
            return UIColor.purple
        default:
            return UIColor.black
        }
    }

    //Change the display if someting chagned like the Accessibility slider in General settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
}

extension CardView {
    private struct SizeRatio {
        static let conrnerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffSetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.63
        static let roundRectOffsetRatio: CGFloat = 0.97
        static let cardRectWithinRoundedRectOffset: CGFloat = 0.95
        static let symbolRectOffset: CGFloat = 0.90
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffSetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.conrnerFontSizeToBoundsHeight
    }
    private var roundedRectBounds: CGRect {
        return bounds.zoom(by: SizeRatio.roundRectOffsetRatio)
    }
    private var cardRectWithinRoundedRect: CGRect {
        return roundedRectBounds.zoom(by: SizeRatio.cardRectWithinRoundedRectOffset)
    }
    
    struct ViewRatios {
        static let cardAspectRatio: CGFloat = 0.71
        static let fillWithLinesSpacing: CGFloat = 10
    }

}


extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

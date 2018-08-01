//
//  CardView.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/28/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var symbol: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var shading: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var color: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var numberOfSymbols: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout() } }
    var superViewBackgroundColor: UIColor = UIColor.clear {didSet {setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        
        //set the background of the view to the same color as the super view
        let background = UIBezierPath(rect: bounds)
      //  background.addClip()
        superViewBackgroundColor.setFill()
        background.fill()
        
        //Used a rounded rectangle to get the card
        let roundedRect = UIBezierPath(roundedRect: roundedRectBounds, cornerRadius: cornerRadius)
      //  roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        let symbolRectHeight = roundedRectBounds.height / 3
        let oneSymbolRect = CGRect(x: roundedRectBounds.minX, y: roundedRectBounds.minY, width: roundedRectBounds.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset)

        let twoSymbolRect = CGRect(x: roundedRectBounds.minX, y: symbolRectHeight, width: roundedRectBounds.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset)

        let threeSymbolRect = CGRect(x: roundedRectBounds.minX, y: symbolRectHeight * 2, width: roundedRectBounds.width, height: symbolRectHeight).zoom(by: SizeRatio.symbolRectOffset)

//        print(oneSymbolRect)
//        print(twoSymbolRect)
//        print(threeSymbolRect)
//
        let rect = UIBezierPath(rect: oneSymbolRect)

        let rect2 = UIBezierPath(rect: twoSymbolRect)

        let rect3 = UIBezierPath(rect: threeSymbolRect)

        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = rect.cgPath
        shapeLayer1.fillColor = UIColor.blue.cgColor
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = rect2.cgPath
        shapeLayer2.fillColor = UIColor.red.cgColor
        
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = rect3.cgPath
        shapeLayer3.fillColor = UIColor.green.cgColor
        
        self.layer.addSublayer(shapeLayer1)
        self.layer.addSublayer(shapeLayer2)
        self.layer.addSublayer(shapeLayer3)
        
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
    
    private func symbolRect()  {
        let symbolRectHeight = roundedRectBounds.height / 3

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

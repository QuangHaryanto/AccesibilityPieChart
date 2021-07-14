//
//  BackgroundView.swift
//  Accessibility Chart
//
//  Created by Haryanto Salim on 11/07/21.
//https://www.raywenderlich.com/19164942-core-graphics-tutorial-patterns-and-playgrounds

import UIKit

@IBDesignable
class BackgroundView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    // 1
    @IBInspectable var lightColor: UIColor = .orange
    @IBInspectable var darkColor: UIColor = .yellow
    @IBInspectable var patternSize: CGFloat = 200
    
    override func draw(_ rect: CGRect) {
        // 2
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("\(#function):\(#line) Failed to get current context.")
        }
        
        // 3
        context.setFillColor(darkColor.cgColor)
        
        // 4
        context.fill(rect)
        
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        // Insert code here
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        
        guard let drawingContext = UIGraphicsGetCurrentContext() else {
            fatalError("\(#function):\(#line) Failed to get current context.")
        }
        
        // Set the fill color for the new context
        darkColor.setFill()
        drawingContext
            .fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        let trianglePath = UIBezierPath()
        // 1
        trianglePath.move(to: CGPoint(x: drawSize.width / 2, y: 0))
        // 2
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height / 2))
        // 3
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height / 2))
        
        // 4
        trianglePath.move(to: CGPoint(x: 0, y: drawSize.height / 2))
        // 5
        trianglePath.addLine(to: CGPoint(x: drawSize.width / 2, y: drawSize.height))
        // 6
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height))
        
        // 7
        trianglePath.move(to: CGPoint(x: drawSize.width, y: drawSize.height / 2))
        // 8
        trianglePath.addLine(to: CGPoint(x: drawSize.width / 2, y: drawSize.height))
        
        // 9
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height))
        
        lightColor.setFill()
        trianglePath.fill()
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("""
            \(#function):\(#line) Failed to \
            get an image from current context.
            """)
        }
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image).setFill()
        context.fill(rect)
    }
    
    
}

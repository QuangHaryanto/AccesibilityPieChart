//
//  PieChartView.swift
//  Accessibility Chart
//
//  Created by Haryanto Salim on 10/07/21.
//https://stackoverflow.com/questions/35752762/making-a-pie-chart-using-core-graphics
//https://github.com/hamishknight/Pie-Chart-View

import UIKit

struct Segment {

    // the color of a given segment
    var color: UIColor

    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat
    
    var name: String
}

class PieChartView: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var currentSegment: Segment? {
        didSet {
            _accessibilityElements = nil

            if let currSegment = currentSegment, let carouselAccessibilityElement = carouselAccessibilityElement {
                carouselAccessibilityElement.currentSegment = currSegment
                
//                if let superView = self.parentViewController as? ViewController {
//                    superView.currentlyFocusedSegment = currentSegment
//                }
            }
        }
    }
    
    /// An array of structs representing the segments of the pie chart
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay() // re-draw view when the values get set
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
        if !segments.isEmpty {
            currentSegment = segments.first
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        // get current context
        let ctx = UIGraphicsGetCurrentContext()

        // radius is the half the frame's width or height (whichever is smallest)
        let radius = min(frame.size.width, frame.size.height) * 0.5

        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)

        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = segments.reduce(0, {$0 + $1.value})

        // the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
        var startAngle = -CGFloat.pi * 0.5

        for segment in segments { // loop through the values array

            // set fill color to the segment color
            ctx?.setFillColor(segment.color.cgColor)

            // update the end angle of the segment
            let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)

            // move to the center of the pie chart
            ctx?.move(to: viewCenter)

            // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            // fill segment
            ctx?.fillPath()
            
            ctx?.move(to: viewCenter)
            ctx?.setFillColor(UIColor.systemBackground.cgColor)
            ctx?.addArc(center: viewCenter, radius: radius * (0.5), startAngle: startAngle, endAngle: endAngle, clockwise: false)

            // fill segment
            ctx?.fillPath()

            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
        }
    }

    // MARK: Accessibility

    var carouselAccessibilityElement: PieChartCarouselAccessibilityElement?
    
    private var _accessibilityElements: [Any]?
    
    override var accessibilityElements: [Any]?{
        get{
            guard _accessibilityElements == nil else {
                return _accessibilityElements
            }

            guard let currSegment = currentSegment else {
                return _accessibilityElements
            }

            let carouselAccessibilityElement: PieChartCarouselAccessibilityElement
            
            if let theCarouselAccessibilityElement = self.carouselAccessibilityElement {
                carouselAccessibilityElement = theCarouselAccessibilityElement
            } else {
                carouselAccessibilityElement = PieChartCarouselAccessibilityElement(
                    accessibilityContainer: self,
                    segment: currSegment
                )
                carouselAccessibilityElement.accessibilityFrameInContainerSpace = self.frame
                self.carouselAccessibilityElement = carouselAccessibilityElement
            }

            return _accessibilityElements
        }
        set{
            _accessibilityElements = newValue
        }
    }
    
}

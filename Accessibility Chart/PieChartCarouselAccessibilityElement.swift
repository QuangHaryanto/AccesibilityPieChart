//
//  PieChartCarouselAccessibilityElement.swift
//  Accessibility Chart
//
//  Created by Haryanto Salim on 12/07/21.
//

import UIKit

class PieChartCarouselAccessibilityElement: UIAccessibilityElement {
    
    var currentSegment: Segment? {
        didSet{
            if let currSegment = currentSegment{
                currentSegment = currSegment
            }
        }
    }
    
    init(accessibilityContainer container: Any, segment: Segment) {
        super.init(accessibilityContainer: container)
        
        currentSegment = segment
    }
    
    override var accessibilityLabel: String?{
        get{
            return "Pie Chart"
        }
        set{
            super.accessibilityLabel = newValue
        }
    }
    
    override var accessibilityValue: String?{
        get{
            if let currSegment = currentSegment {
                return currSegment.name
            }
            return super.accessibilityValue
        }
        set{
            super.accessibilityValue = newValue
        }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits{
        get{
            return .adjustable
        }
        set{
            super.accessibilityTraits = newValue
        }
    }
    
    private func moveNextSegment() -> Bool{
        guard let container = accessibilityContainer as? PieChartView else{
            return false
        }
        
        guard let currSegment = currentSegment  else {
            return false
        }
        
        let firstIdx = 0
        let firstSegment = container.segments[0]
        for idx in firstIdx ..< container.segments.count {
            if container.segments[idx].name != currSegment.name{
                //bole lanjut ke idx berikutnya
            } else {
                if idx == container.segments.count - 1 { //idx terakhir
                    container.currentSegment = firstSegment //idx di set ke item pertama
                } else {
                    container.currentSegment = container.segments[idx + 1] //idx di set item selanjutnya
                }
                return true
            }
        }
        return true
    }
    
    private func movePrevSegment() -> Bool{
        guard let container = accessibilityContainer as? PieChartView else{
            return false
        }
        
        guard let currSegment = currentSegment  else {
            return false
        }
        
        let lastIdx = container.segments.count - 1
        let lastSegment = container.segments[lastIdx]
        for idx in lastIdx...0 {
            if container.segments[idx].name != currSegment.name {
                //bole lanjut ke index sebelumnya
            } else {
                if idx == 0 { //idx pertama
                    container.currentSegment = lastSegment //idx di set item terakhir
                } else {
                    container.currentSegment = container.segments[idx - 1] //idx di set ke item sebelumnya
                }
                return true
            }
        }
        return true
    }
    
    override func accessibilityIncrement() {
        _ = moveNextSegment()
    }
    
    override func accessibilityDecrement() {
        _ = moveNextSegment()
    }
    
    
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        print("scroll detected")
        if direction == .left {
            return moveNextSegment()
        } else if direction == .right {
            return movePrevSegment()
        }
        return false
    }
}

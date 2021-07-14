//
//  ViewController.swift
//  Accessibility Chart
//
//  Created by Haryanto Salim on 10/07/21.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class ViewController: UIViewController {
    
    //    @IBOutlet var pieChartView2: PieChartView2!
    var pieChartView: PieChartView?
    
    
    var currentlyFocusedSegment: Segment? = nil {
        // Every time we update our segment object, we need to relay that change to all the views that care.
        didSet {
            pieChartView?.carouselAccessibilityElement = PieChartCarouselAccessibilityElement(accessibilityContainer: self, segment: (pieChartView?.segments.first)!)
            pieChartView?.currentSegment = currentlyFocusedSegment
//            pieChartView?.accessibilityLabel = currentlyFocusedSegment?.name
//            pieChartView?.accessibilityValue = "\(String(describing: currentlyFocusedSegment?.value ?? 0))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (#function)
        // Do any additional setup after loading the view.pie
        self.pieChartView = PieChartView()
        
        pieChartView?.isAccessibilityElement = true
        
        let segments = [
            Segment(color: .systemRed, value: 20, name: "red"),
            Segment(color: .systemBlue, value: 30, name: "blue"),
            Segment(color: .systemGreen, value: 10, name: "green"),
            Segment(color: .systemYellow, value: 40, name: "yellow")
        ]
        pieChartView?.segments = segments
        
        if !((pieChartView?.segments.isEmpty)!) {
            pieChartView?.carouselAccessibilityElement = PieChartCarouselAccessibilityElement(accessibilityContainer: self, segment: (pieChartView?.segments.first)!)
            currentlyFocusedSegment = pieChartView?.segments.first
            pieChartView?.currentSegment = pieChartView?.segments.first
            
            
        }
        
    }
    
    @IBAction
    func pressButton(sender:UIButton){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.0) {
                self.pieChartView?.segments.popLast()
                self.pieChartView?.segments.popLast()
                self.pieChartView?.segments.append(Segment(color: .systemYellow, value: 15, name: "yellow"))
                self.pieChartView?.segments.append(Segment(color: .systemGreen, value: 15, name: "green"))
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print (#function)
//        pieChartView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)

        //start accessibility config
        
        guard let pieChartView = pieChartView else {
            return
        }
        
        view.addSubview(pieChartView)
        
//        let margins = view.layoutMarginsGuide
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            pieChartView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            pieChartView.topAnchor.constraint(equalTo: guide.topAnchor),
            pieChartView.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.5),
            pieChartView.heightAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.5)
        ])
    }
    
}


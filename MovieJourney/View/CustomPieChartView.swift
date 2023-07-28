//
//  CustomPieChartView.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import Foundation
import RealmSwift
import UIKit


class CustomPieChartView: UIView {
    // Array to hold the data entries for the pie chart
    var dataEntries: [DataEntry] = [] {
        didSet {
            // When dataEntries is set, mark the view for redrawing to update the pie chart
            setNeedsDisplay()
        }
    }
    
    // Override the draw function to perform custom drawing on the view
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Call the drawPieChart function to draw the pie chart
        drawPieChart()
       
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
    }
    
    // Function to draw the pie chart
    private func drawPieChart() {
        // Calculate the center and radius of the pie chart
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        
        // Calculate the total value of all data entries to determine the angles of the slices
        let totalValue = dataEntries.reduce(0) { $0 + $1.value }
        
        // Initialize the start angle for the first slice
        var startAngle: CGFloat = 0

        // Loop through each data entry and draw the corresponding pie slice
        for entry in dataEntries {
            // Calculate the end angle for the current slice
            let endAngle = startAngle + 2 * .pi * (entry.value / totalValue)
            
            // Create a path for the slice and add it to the view
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            
            // Set the fill color for the slice and fill it
            entry.color.setFill()
            path.fill()
            
            // Calculate the center angle for the label and its position
            let labelCenterAngle = (startAngle + endAngle) / 2
            let labelRadius = radius / 2
            let labelCenter = CGPoint(x: center.x + labelRadius * cos(labelCenterAngle),
                                      y: center.y + labelRadius * sin(labelCenterAngle))
            
            // Create a label for the data entry and add it to the view
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            label.center = labelCenter
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = entry.categoryName
            addSubview(label)
            
            // Update the start angle for the next slice
            startAngle = endAngle
        }
        
        // Add a title label for the pie chart
        let title = UILabel(frame: CGRect(x: -150, y: -80, width: 600, height: 30))
        title.textAlignment = .center
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.text = "Distribution of Watched Movies by Genre"
        addSubview(title)
    }
}

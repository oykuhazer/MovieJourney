//
//  GraphViewController.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import UIKit
import RealmSwift

class GraphViewController: UIViewController {

    var customPieChartView: CustomPieChartView!
    var graphViewModel = GraphViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.1, green: 0.7, blue: 0.0, alpha: 1.0)
        setupCustomPieChartView()
        fetchData()
    }
    
    
    private func setupCustomPieChartView() {
        let pieChartWidth: CGFloat = 300
        let pieChartHeight: CGFloat = 300
        let pieChartX: CGFloat = (view.bounds.width - pieChartWidth) / 2
        let pieChartY: CGFloat = (view.bounds.height - pieChartHeight) / 2

        customPieChartView = CustomPieChartView(frame: CGRect(x: pieChartX, y: pieChartY + 50, width: pieChartWidth, height: pieChartHeight))
        view.addSubview(customPieChartView)
    }
    
    // Function to fetch data using the view model and update the custom pie chart view
    private func fetchData() {
        graphViewModel.fetchData { [weak self] dataEntries in
            DispatchQueue.main.async {
                self?.customPieChartView.dataEntries = dataEntries
            }
        }
    }
   
}

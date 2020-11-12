//
//  ChartsView.swift
//  Exchanger
//
//  Created by Oskar Figiel on 05/11/2020.
//

import UIKit
import Charts

final class ChartView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        let safeArea = self.layoutMarginsGuide

        addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true

        addSubview(chart)
        chart.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5).isActive = true
        chart.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        chart.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var segmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: TimeFrame.allCases.map({ "\($0.rawValue)" }))
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()

    public var chart: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
}

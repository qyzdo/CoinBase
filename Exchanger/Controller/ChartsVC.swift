//
//  ChartsVC.swift
//  Exchanger
//
//  Created by Oskar Figiel on 05/11/2020.
//

import UIKit
import Charts

final class ChartsVC: UIViewController {

    // MARK: - Properties
    var identifier: Int!

    private var chartView: ChartView {
        return view as! ChartView
    }

    // MARK: - Lifecycle methods

    override func loadView() {
        self.view = ChartView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    private func loadData() {
        let provider = ServiceProvider<CoinsService>()

        provider.load(service: .coin(identifier: String(identifier)), decodeType: SingleCoinModel.self) { result in
            switch result {
            case .success(let resp):
                self.setupChart(array: resp.data.history)
            case .failure(let error):
                print(error.localizedDescription)
            case .empty:
                print("No data")
            }
        }
    }

    private func getPrices(array: [History]) -> [Double] {
        let prices = array.map({ $0.price })
        return prices.compactMap(Double.init)
    }

    private func getTimeStamp(array: [History]) -> [Int] {
        let prices = array.map({ $0.timestamp })
        return prices.compactMap(Int.init)
    }

    private func setupChart(array: [History]) {
        let pricesArray = getPrices(array: array)
        let timestampsArray = getTimeStamp(array: array)
        var lineChartEntry = [ChartDataEntry]()

        for iterator in 0..<pricesArray.count {
            let yyy = pricesArray[iterator]
            let xxx = Double(timestampsArray[iterator])
            let value = ChartDataEntry(x: xxx, y: yyy)
            lineChartEntry.append(value)

        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Price")
        line1.colors = [NSUIColor.init(red: 0/255, green: 191/255, blue: 255/255, alpha: 1.0)]
        line1.fill = Fill.fillWithColor(UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0))
        line1.drawFilledEnabled = true
        line1.circleRadius = CGFloat.init(3.0)
        line1.setCircleColor(UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0))
        line1.valueTextColor = UIColor.black

        let data = LineChartData()
        data.addDataSet(line1)

        let xFormatter = XAxisNameFormaterWithTime()
        chartView.chart.xAxis.valueFormatter = xFormatter

        let yFormatter = YAxisValueFormatter()
        chartView.chart.leftAxis.valueFormatter = yFormatter
        chartView.chart.rightAxis.valueFormatter = yFormatter

        chartView.chart.data = data
        chartView.chart.chartDescription?.text = "My awesome chart"
    }
}

final class XAxisNameFormater: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.yyy"

        return formatter.string(from: Date(timeIntervalSince1970: value/1000))
    }
}

final class YAxisValueFormatter: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        return "\(value)$"
    }
}

final class XAxisNameFormaterWithTime: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM-HH:mm"

        return formatter.string(from: Date(timeIntervalSince1970: value/1000))
    }

}

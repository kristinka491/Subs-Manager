//
//  StatisticsViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 14.11.2022.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!

    private let realmDataStore = RealmDataStore.shared
    private var subscriptionType: SubscriptionEnum?
    private var userSubscriptions: [UserSubscription]?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeChart(dataPoints: userSubscriptions?.map { $0.subscriptionName } ?? [],
                       values: userSubscriptions?.compactMap { Double($0.amount) } ?? [])
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func setUp(with model: [UserSubscription]?) {
        userSubscriptions = model
    }

    private func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i],
                                              label: dataPoints[i],
                                              data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: userSubscriptions?.count ?? 0)
        pieChartDataSet.entryLabelFont = UIFont(name: "Hiragino Mincho ProN", size: 13)
        pieChartDataSet.entryLabelColor = .black
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartView.data = pieChartData
        setUpPieChart()
    }

    private func setUpPieChart() {
        pieChartView.legend.enabled = false
        pieChartView.holeRadiusPercent = 0.4
        pieChartView.data?.setValueTextColor(.black)
        if let valueFont = UIFont(name: "Hiragino Mincho ProN", size: 13) {
            pieChartView.data?.setValueFont(valueFont)
        }
    }

    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors = [UIColor]()
        userSubscriptions?.forEach { model in
            if let color = SubscriptionEnum(rawValue: model.subscriptionName)?.color {
                colors.append(color)
            }
        }
    return colors
    }
}

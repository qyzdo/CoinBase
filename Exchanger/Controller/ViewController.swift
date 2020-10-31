//
//  ViewController.swift
//  Exchanger
//
//  Created by Oskar Figiel on 29/10/2020.
//

import UIKit

final class ViewController: UIViewController {

    private let titles = ["item 1", "item 2", "item 3", "item 4", "item 5"]
    private var inputField: UITextField!
    private var resultField: UILabel!

    private var mainScreenView: MainScreenView {
        return view as! MainScreenView
    }

    // MARK: - Lifecycle methods
    override func loadView() {
        self.view = MainScreenView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainScreenView.pickerView.delegate = self
        mainScreenView.pickerView.dataSource = self
        mainScreenView.inputValueField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        inputField = mainScreenView.inputValueField
        resultField = mainScreenView.resultValueField
    }

    // MARK: - User interaction methods
    @objc private func textFieldDidChange() {

        guard let number = inputField.text else {
            print("No number")
            resultField.text = ""
            return
        }

        guard let numberDouble = Double(number) else {
            print("Cant change number")
            resultField.text = ""
            return
        }

        convertPrice(price: numberDouble, rate: 2.01)
    }

    // MARK: - Functions
    private func convertPrice(price: Double, rate: Double) {
        resultField.text = String(price * rate)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Picker view methods
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
}

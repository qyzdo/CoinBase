//
//  ViewController.swift
//  Exchanger
//
//  Created by Oskar Figiel on 29/10/2020.
//

import UIKit
import Kingfisher

final class MainVC: UIViewController {

    // MARK: - Properties
    private var titles = [String]()
    private var coins = [CoinElement]()
    private var inputField: UITextField!
    private var resultField: UILabel!
    private var selectedRow = 0 {
        didSet {
            setLabelCurrencies()
            setImage()
            mainView.pickerValueField.text = titles[selectedRow]
            unwrapAndConvert()
        }
    }

    private var invertConversion = false {
        didSet {
            setLabelCurrencies()
            unwrapAndConvert()
        }
    }

    private var mainView: MainScreenView {
        return view as! MainScreenView
    }

    // MARK: - Lifecycle methods
    override func loadView() {
        self.view = MainScreenView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        mainView.pickerValueField.inputView = mainView.pickerView
        inputField = mainView.inputValueField
        resultField = mainView.resultValueField

        addActions()
        loadData()
    }

    private func addActions() {
        inputField.addTarget(self, action: #selector(inputTextFieldDidChange), for: .editingChanged)
        mainView.invertValuesSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        mainView.chartsButton.addTarget(self, action: #selector(openChartsButtonClicked), for: .touchUpInside)
        resultField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resultFieldClicked)))
    }

    private func setDelegates() {
        mainView.pickerView.delegate = self
        mainView.pickerView.dataSource = self
    }

    // MARK: - Get data
    func loadData() {
        let provider = ServiceProvider<CoinsService>()

        provider.load(service: .coins, decodeType: CoinModel.self) { result in
            switch result {
            case .success(let resp):
                self.coins = resp.data.coins
                for number in resp.data.coins {
                    self.titles.append(number.name)
                }
                self.mainView.pickerView.reloadAllComponents()
                self.selectedRow = 0
            case .failure(let error):
                print(error.localizedDescription)
            case .empty:
                print("No data")
            }
        }
    }

    // MARK: - User interaction methods

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc private func openChartsButtonClicked() {
        let chartsVC = ChartsVC()
        chartsVC.identifier = coins[selectedRow].identifier
        navigationController?.pushViewController(chartsVC, animated: true)
    }

    @objc private func inputTextFieldDidChange() {
        unwrapAndConvert()
    }

    @objc private func switchChanged() {
        if mainView.invertValuesSwitch.isOn {
            invertConversion = true
        } else {
            invertConversion = false
        }
    }

    @objc private func resultFieldClicked() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = resultField.text
        self.showToast(message: "Copied to clipboard", seconds: 0.5)
    }

    // MARK: - Functions
    private func setImage() {
        let url = URL(string: coins[selectedRow].iconUrl)
        mainView.imageView.kf.indicatorType = .activity
        var processor: ImageProcessor

        if coins[selectedRow].iconType == "pixel" {
            processor = DownsamplingImageProcessor(size: mainView.imageView.bounds.size)
        } else {
            processor = SVGImgProcessor() |> DownsamplingImageProcessor(size: mainView.imageView.bounds.size)
        }

        mainView.imageView.kf.setImage(with: url,
                                       options: [
                                               .processor(processor),
                                               .scaleFactor(UIScreen.main.scale),
                                               .transition(.fade(1)),
                                               .cacheOriginalImage
                                           ])
    }

    private func convertPrice(value: Double, price: String) {
        var formattedString = ""
        guard let priceDouble = Double(price) else {
            print("Cant change number")
            return
        }
        if invertConversion == false {
            formattedString = String(format: "%.10f", value / priceDouble)

        } else {
            formattedString = String(format: "%.10f", value * priceDouble)
        }
        resultField.text = formattedString
    }

    private func unwrapAndConvert() {
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

        convertPrice(value: numberDouble, price: coins[selectedRow].price)
    }

    private func setLabelCurrencies() {
        let currentCoin = coins[selectedRow]
        let price = String(format: "%.6f", Double(currentCoin.price)!)
        mainView.currentPriceLabel.text = "1 \(currentCoin.symbol) = $\(price)"
        if invertConversion == true {
            mainView.inputValueLabel.text = currentCoin.symbol
            mainView.resultValueLabel.text = "$"
        } else {
            mainView.resultValueLabel.text = currentCoin.symbol
            mainView.inputValueLabel.text = "$"
        }
    }
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {

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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}

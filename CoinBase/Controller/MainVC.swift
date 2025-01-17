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
    private let formatter = NumberFormatter()

    private var selectedRow = 0 {
        didSet {
            setLabelCurrencies()
            setImage()
            mainView.pickerValueField.text = titles[selectedRow]
            if mainView.inputValueField.text?.trimmingCharacters(in: .whitespaces) != "" {
                unwrapAndConvert()
            }
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

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupFormatter()
        mainView.pickerValueField.inputView = mainView.pickerView
        inputField = mainView.inputValueField
        resultField = mainView.resultValueField

        addActions()
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc private func openChartsButtonClicked() {
        let chartsVC = ChartsVC()

        guard coins.indices.contains(selectedRow) else {
            return
        }

        chartsVC.coinModel = coins[selectedRow]
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

    private func setupFormatter() {
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
    }

    private func convertPrice(value: Double, price: String) {
        var result = 0.0

        guard let priceDouble = Double(price) else {
            print("Cant change number")
            return
        }

        if invertConversion == false {
            result = value / priceDouble

        } else {
            result = value * priceDouble
        }

        let numberNS = NSNumber(value: result)
        let formattedNumber = formatter.string(from: numberNS)

        resultField.text = formattedNumber

    }

    private func unwrapAndConvert() {
        guard let numberString = inputField.text else {
            print("No number")
            resultField.text = ""
            return
        }

        guard let number = formatter.number(from: numberString) else {
            print("Wrong number")
            resultField.text = ""
            return
        }

        let numberDouble = Double(truncating: number)

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

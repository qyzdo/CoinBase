//
//  MainScreenView.swift
//  Exchanger
//
//  Created by Oskar Figiel on 29/10/2020.
//

import UIKit

final class MainScreenView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        let safeArea = self.layoutMarginsGuide

        addSubview(pickerView)
        pickerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pickerView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 5).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        addSubview(currentPriceLabel)
        currentPriceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        currentPriceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 5).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true

        stackView.addArrangedSubview(inputValueLabel)
        stackView.addArrangedSubview(inputValueField)
        inputValueField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        stackView.addArrangedSubview(resultValueLabel)
        stackView.addArrangedSubview(resultValueField)
        resultValueField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private var inputValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "$"
        return label
    }()

    public var inputValueField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray5
        textField.clearButtonMode = .always
        textField.keyboardType = .decimalPad
        return textField
    }()

    private var resultValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "BTC"
        return label
    }()

    public var resultValueField: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray5
        return label
    }()
}

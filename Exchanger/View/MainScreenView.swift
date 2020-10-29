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

        addSubview(myLabel)
        myLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        myLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello world"
        return label
    }()
}

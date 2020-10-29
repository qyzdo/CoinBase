//
//  ViewController.swift
//  Exchanger
//
//  Created by Oskar Figiel on 29/10/2020.
//

import UIKit

final class ViewController: UIViewController {

    var mainScreenView: MainScreenView {
        return view as! MainScreenView
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainScreenView.myLabel.text = "yay"
    }

    override func loadView() {
        self.view = MainScreenView()
    }

}

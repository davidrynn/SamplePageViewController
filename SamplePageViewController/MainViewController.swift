//
//  MainViewController.swift
//  SamplePageViewController
//
//  Created by David Rynn on 7/19/19.
//  Copyright © 2019 David Rynn. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "This is the MAIN APP!"
        view.addSubview(label)
        view.backgroundColor = .white
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        let button = UIButton()
        button.setTitle("Start Over", for: .normal)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(80)
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(startOver), for: .touchUpInside)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func startOver() {
        let controller1 = SampleViewController()
        controller1.view.backgroundColor = #colorLiteral(red: 0.9555206895, green: 0.9556805491, blue: 0.9554995894, alpha: 1)
        let controller2 = SampleTextViewController()
        controller2.view.backgroundColor = #colorLiteral(red: 0.8806003928, green: 0.9414284229, blue: 0.9402227402, alpha: 1)
        let controller3 = SampleViewController()
        controller3.view.backgroundColor = #colorLiteral(red: 0.9555206895, green: 0.9556805491, blue: 0.9554995894, alpha: 1)
        let controller4 = SampleTextInputViewController()
        controller4.view.backgroundColor = #colorLiteral(red: 0.8806003928, green: 0.9414284229, blue: 0.9402227402, alpha: 1)
                let listener = SamplePageInteractor()
        let root = SamplePageContainerViewController([controller1, controller2, controller3, controller4], listener: listener)
        listener.presenter = root
        navigationController?.pushViewController(root, animated: true)
    }

}

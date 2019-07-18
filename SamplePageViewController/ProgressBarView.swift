//
//  ProgressBarView.swift
//  SamplePageViewController
//
//  Created by David Rynn on 7/18/19.
//  Copyright © 2019 David Rynn. All rights reserved.
//

import UIKit
import SnapKit

class ProgressBarView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let progressBar = UIProgressView(progressViewStyle: .default)
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        addSubview(progressBar)
        backgroundColor = .white
        progressBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(4)
        }
        progressBar.trackTintColor = .gray
        progressBar.progressTintColor = .blue
        
        let logo = UIImageView(image: #imageLiteral(resourceName: "yourCompanyLogo"))
        logo.contentMode = .scaleAspectFit
        addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
    }
    
}


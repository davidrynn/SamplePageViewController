//
//  SamplePageContainerViewController.swift
//  SamplePageViewController
//
//  Created by David Rynn on 7/17/19.
//  Copyright © 2019 David Rynn. All rights reserved.
//

import UIKit
import SnapKit

protocol PageContainerDelegate: class {
    func didTapNextButton()
    func didTapBackButton()
}

class SamplePageContainerViewController: UIViewController {
    
    // MARK: Properties
    
    private let pageController: SamplePageViewController
    private let pages: [ButtonTappableViewController]
    private let header = ProgressBarView()
    private lazy var progrss = Progress(totalUnitCount: Int64(pageController.pages.count))
    private let nextButton = UIButton()
    private let backButton = UIButton()
    
    weak var delegate: PageContainerDelegate?
    
    // MARK: Initialization
    
    init(_ pages: [ButtonTappableViewController]) {
        self.pages = pages
        self.pageController = SamplePageViewController(viewControllers: pages)
        self.delegate = self.pageController
        super.init(nibName: nil, bundle: nil)
        pageController.backNextDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(pageController)
        view.addSubview(header)
        view.addSubview(pageController.view)
        setupHeader()
        setupPageConstraints()
        updateProgress()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.layer.masksToBounds = false
        header.layer.shadowColor = UIColor.black.cgColor
        header.layer.shadowOpacity = 0.5
        header.layer.shadowRadius = 5
        header.layer.shadowPath = UIBezierPath(rect: header.bounds).cgPath
    }
    // MARK: Setups
    
    func setupHeader() {
        setupHeaderConstraints()
        setupHeaderButtons()

        view.bringSubviewToFront(header)
    }
    
    func setupHeaderConstraints() {
        header.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    func setupHeaderButtons() {
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.setTitle("Next", for: .normal)
        backButton.setTitle("Back", for: .normal)
        nextButton.setTitleColor(.red, for: .normal)
        backButton.setTitleColor(.red, for: .normal)
        header.addSubview(nextButton)
        header.addSubview(backButton)
        nextButton.snp.makeConstraints { make in
            make.trailing.height.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.width.equalTo(60)
        }
        backButton.snp.makeConstraints{ make in
            make.leading.height.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.width.equalTo(60)
        }
        backButton.isHidden = true
    }
    
    func setupPageConstraints() {
        pageController.view.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    @objc func didTapNext() {
        delegate?.didTapNextButton()
    }
    
    @objc func didTapBack() {
        delegate?.didTapBackButton()
    }
    
}

extension SamplePageContainerViewController: BackNextDelegate {
    func updateProgress() {
        progrss.completedUnitCount = Int64(pageController.currentIndex + 1)
        header.progressBar.setProgress(Float(progrss.fractionCompleted), animated: true)
    }

    func showNextButton() {
        nextButton.isHidden = false
    }
    
    func hideNextButton() {
        nextButton.isHidden = true
    }
    
    func showBackButton() {
        backButton.isHidden = false
    }
    
    func hideBackButton() {
        backButton.isHidden = true
    }
}



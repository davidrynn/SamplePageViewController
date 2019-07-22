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

protocol SamplePageListener: class {
    func didTapCTA(data: String)
}

class SamplePageContainerViewController: UIViewController {
    
    // MARK: Properties
    
    private let pageController: SamplePageViewController
    private let pages: [ButtonTappableViewController]
    private lazy var progrss = Progress(totalUnitCount: Int64(pageController.pages.count))
    private let header = ProgressBarView()
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    private let listener: SamplePageListener
    
    weak var delegate: PageContainerDelegate?
    
    // MARK: Initialization
    
    init(_ pages: [ButtonTappableViewController], listener: SamplePageListener) {
        self.pages = pages
        self.pageController = SamplePageViewController(viewControllers: pages)
        self.delegate = self.pageController
        self.listener = listener
        super.init(nibName: nil, bundle: nil)
        pageController.pageDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(pageController)
        view.addSubview(header)
        header.addSubview(nextButton)
        header.addSubview(backButton)
        view.addSubview(pageController.view)
        setupConstraints()
        backButton.isHidden = true
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
    
    // MARK: Constraints
    
    private func setupConstraints() {
        setupHeaderConstraints()
        setupHeaderButtonsConstraints()
        setupPageConstraints()
    }
    
    private func setupHeaderConstraints() {
        header.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func setupHeaderButtonsConstraints() {

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
    }
    
    private func setupPageConstraints() {
        pageController.view.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    // MARK: Actions
    
    @objc func didTapNext() {
        delegate?.didTapNextButton()
    }
    
    @objc func didTapBack() {
        delegate?.didTapBackButton()
    }
    
}

// MARK: - Delegate Methods

extension SamplePageContainerViewController: SamplePageControllerDelegate {
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
    
    func ctaTapped(data: String) {
        listener.didTapCTA(data: data)
    }
}

extension SamplePageContainerViewController: SamplePresenter {
    func callCompleted(responseData: String) {
        let alertVC = UIAlertController(title: "Complete",
                                        message: "Congratulations \(responseData), you have finished.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            let main = MainViewController()
            self.navigationController?.pushViewController(main, animated: true)
        })
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}



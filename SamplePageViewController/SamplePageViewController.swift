//
//  SamplePageViewController.swift
//  SamplePageViewController
//
//  Created by David Rynn on 7/15/19.
//  Copyright © 2019 David Rynn. All rights reserved.
//

import UIKit
import SnapKit

protocol BackNextDelegate: class {
    func hideNextButton()
    func showNextButton()
    func hideBackButton()
    func showBackButton()
    func updateProgress()
}

class SamplePageViewController: UIPageViewController {
    
    // MARK: Properties
    
    var interactor: SamplePageInteractor?
    
    var pages: [ButtonTappableViewController] = [] {
        didSet {
            pageControl.numberOfPages = pages.count
        }
    }
    
    weak var backNextDelegate: BackNextDelegate?
    
    var currentIndex: Int {
        get {
            if let currentPage = viewControllers?.first as? ButtonTappableViewController, let cIndex = pages.firstIndex(of: currentPage) {
                return cIndex
            }
            return 0
        }
    }
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .gray
        control.currentPage = 0
        control.addTarget(self, action: #selector(didTapControl(_:)), for: .touchUpInside)
        return control
    }()
    
    init(viewControllers: [ButtonTappableViewController]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pages = viewControllers
        pages.forEach { $0.delegate = self }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupPages()
        setupControl()
        setupBox()
        dataSource = self
        delegate = self
    }
    
    func setupControl() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupPages() {
        guard let first = pages.first else { return }
        pages.forEach { $0.delegate = self }
        setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }
    
    func setupBox() {
        let box = UIImageView(image: #imageLiteral(resourceName: "yourCompanyLogo"))
        box.contentMode = .scaleAspectFit
        box.backgroundColor = .clear
        view.addSubview(box)
        box.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(60)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    
    // MARK: Actions
    
    @objc func didTapControl(_ control: UIPageControl) {
        setPage(pageIndex: control.currentPage)
    }
    
    func setPage(pageIndex: Int) {
        guard pageIndex < pages.count else { return }
        if currentIndex == pageIndex { return }
        let direction: UIPageViewController.NavigationDirection = currentIndex < pageIndex ? .forward : .reverse
        let controller = pages[pageIndex]
        self.setViewControllers([controller], direction: direction, animated: true, completion: { _ in
            if self.pageControl.currentPage != pageIndex { self.pageControl.currentPage = pageIndex }
        })
        backNextDelegate?.updateProgress()
    }
    
    @objc func goToNextPage() {
        setPage(pageIndex: currentIndex + 1)
        showHideNextButton()
    }
    
    @objc func goBack() {
        setPage(pageIndex: currentIndex - 1)
        showHideBackButton()
        
    }
    
    func showHideBackButton() {
        if currentIndex == 0 {
            backNextDelegate?.hideBackButton()
        }
        backNextDelegate?.showNextButton()
    }
    
    func showHideNextButton() {
        if currentIndex == pages.count - 1 {
            backNextDelegate?.hideNextButton()
        }
        backNextDelegate?.showBackButton()
    }
    
    
}
// MARK: - Extensions
extension SamplePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ButtonTappableViewController, let previousIndex = pages.firstIndex(of: vc), (previousIndex - 1) >= 0 else {
            return nil
        }
        return pages[previousIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ButtonTappableViewController, let previousIndex = pages.firstIndex(of: vc), (previousIndex + 1) < pages.count else {
            return nil
        }
        return pages[previousIndex + 1]
    }
}

extension SamplePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageControl.currentPage = currentIndex
        backNextDelegate?.updateProgress()
        showHideNextButton()
        showHideBackButton()
    }
    
}

extension SamplePageViewController: ButtonTapable {
    func didTapButton() {
        goToNextPage()
    }
}

extension SamplePageViewController: PageContainerDelegate {
    
    func didTapNextButton() {
        goToNextPage()
    }
    
    func didTapBackButton() {
        goBack()
    }
    
}


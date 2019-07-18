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
    
    lazy var controller1: SampleViewController =  {
        let controller = SampleViewController()
        controller.view.backgroundColor = #colorLiteral(red: 0.937792182, green: 0.9379492402, blue: 0.9377716184, alpha: 1)
        controller.delegate = self
        return controller
    }()
    lazy var controller2: SampleTextViewController = {
        let controller = SampleTextViewController()
        controller.delegate = self
        controller.view.backgroundColor = #colorLiteral(red: 0.8979107738, green: 0.9543939233, blue: 0.9568721652, alpha: 1)
        return controller
    }()
    lazy var controller3: SampleViewController =  {
        let controller = SampleViewController()
        controller.delegate = self
        controller.view.backgroundColor = #colorLiteral(red: 0.937792182, green: 0.9379492402, blue: 0.9377716184, alpha: 1)
        return controller
    }()
    lazy var controller4: SampleTextInputViewController = {
        let controller = SampleTextInputViewController()
        controller.delegate = self
        controller.view.backgroundColor = #colorLiteral(red: 0.8979107738, green: 0.9543939233, blue: 0.9568721652, alpha: 1)
        return controller
    }()
    
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
        guard let first = pages.first else {
            pages = [controller1, controller2, controller3, controller4]
            setViewControllers([controller1], direction: .forward, animated: true, completion: nil)
            return
        }
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
        if currentIndex == pages.count - 1 {
            backNextDelegate?.hideNextButton()
        }
        backNextDelegate?.showBackButton()
    }
    
    @objc func goBack() {
        setPage(pageIndex: currentIndex - 1)
        if currentIndex == 0 {
            backNextDelegate?.hideBackButton()
        }
        backNextDelegate?.showNextButton()
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
        if currentIndex == (pages.count - 1) {
            backNextDelegate?.hideNextButton()
            backNextDelegate?.showBackButton()
            return
        }
        if currentIndex == 0 {
            backNextDelegate?.hideBackButton()
            backNextDelegate?.showNextButton()
            return
        }
        backNextDelegate?.showNextButton()
        backNextDelegate?.showBackButton()
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


// MARK: - Sample SubClasses

protocol ButtonTapable: class {
    func didTapButton()
}

class ButtonTappableViewController: UIViewController {
    weak var delegate: ButtonTapable?
    
    @objc func didTap() {
        delegate?.didTapButton()
    }
    
}

class SampleViewController: ButtonTappableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("BUTTON!", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make -> Void in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.center.equalTo(self.view)
        }
    }
}

class SampleTextViewController: ButtonTappableViewController {
    
    override func viewDidLoad() {
        let textViewWidth = view.frame.width - 160
        let textViewX = view.frame.width / 2 - textViewWidth / 2
        let textView = UITextView(frame: CGRect(x: textViewX, y: 0, width: textViewWidth, height: view.frame.height))
        view.addSubview(textView)
        textView.text = "Lorem ipsum dolor sit amet, in amet gravida ac exercitation sed, turpis cursus tortor egestas wisi sapien condimentum, dapibus nullam cras. Amet ac magna eget laoreet, fermentum nam dolore sapien faucibus suscipit, in in vivamus maecenas, semper nam quis neque in sed lectus. Egestas habitant auctor, vestibulum etiam orci, mauris ullamcorper tempor at, sed lacinia. Non fermentum earum nunc dapibus consequat, pede viverra ad varius mauris duis, commodo maecenas luctus at sed in, wisi faucibus proin vestibulum mauris neque tristique, mauris tincidunt nec mauris viverra eleifend pellentesque. Eu sed in rutrum, ultrices phasellus quis, sodales scelerisque nec, donec dictum pede integer adipiscing. Neque elit ultrices mauris fermentum, nostra quis phasellus integer libero.\nAdipiscing ante blanditiis mi, fermentum faucibus at aliquam rhoncus laoreet, sed quis id. Per rutrum eros arcu elementum integer quis, ipsum sit elementum ultricies wisi, at ornare at vehicula tincidunt. In viverra do eget, eros orci vitae nullam vel consequatur, id et congue aliquet proin, dui vitae nullam morbi, morbi vestibulum sit tempor sapien. Viverra vestibulum elementum phasellus sit odio, sed lectus quis. Tempor mi donec hymenaeos magna penatibus amet. Mattis torquent euismod, suscipit iaculis laoreet vel donec dolore ac, donec litora vel, a et amet. At sociis sed justo est pulvinar, nisl elit, id a amet et blandit sociosqu. Morbi hendrerit, vestibulum interdum a nibh, et consequat architecto iusto ac pulvinar, donec aenean. Montes gravida, venenatis proin eu dolor faucibus ut.\nSollicitudin justo velit parturient lorem. Elit aliquet sed posuere velit. Dolor justo donec a, vulputate amet ut non fermentum, nascetur rhoncus eget nunc et, tortor gravida etiam luctus, urna vestibulum bibendum placerat suscipit tellus. Eget vulputate consequuntur ante condimentum, orci sed proin blandit purus rerum, convallis tincidunt egestas, nibh sed, quisque donec eros eget eget. Cursus luctus nostra urna iaculis. Ultrices porttitor laoreet nec vestibulum. Tellus duis fringilla libero quam, odio parturient congue. Ligula nonummy lacus molestie, habitant non lacinia, fermentum sit congue. In mollis vitae in, dolor consectetur quam ligula turpis, ullamcorper enim maecenas erat ac morbi, sapien etiam ut. Morbi autem, at ornare nibh neque ipsum tempus nulla, dolor mattis est varius, condimentum dictum semper at lectus nec, ac felis. Et vestibulum quam nonummy, non hac eligendi.\nIn nulla volutpat lorem montes elit. Vel suspendisse lorem tortor eos, gravida parturient per tellus vestibulum ligula a, aenean sit suspendisse montes, amet porta pretium nunc aenean et. Nec mauris, habitasse lacus sollicitudin tortor lectus, pharetra et vel vehicula turpis aliquam, urna elit. Diam rutrum. Molestie consectetuer sagittis, nec eget aut fringilla mi mollis, habitasse vestibulum tellus ac velit amet justo, mauris tristique lectus leo dicta, in nullam mi. Auctor montes odio, consequat tempor vivamus rhoncus turpis nisl, urna elit parturient pulvinar pellentesque fusce. A ullamcorper pretium tincidunt donec. Sem velit mauris pharetra erat aliquam mauris, eleifend dolor vivamus in tristique magna mi, id interdum sed scelerisque purus vel, hendrerit convallis nam etiam curabitur curabitur taciti, sed eleifend at."
        
        let buttonHeight: CGFloat = 44
        let contentInset: CGFloat = 0
        
        //inset the textView
        textView.textContainerInset = UIEdgeInsets(top: contentInset, left: contentInset, bottom: (buttonHeight+contentInset*2) + buttonHeight, right: contentInset)
        
        let button = UIButton(frame: CGRect(x: (textViewWidth / 2) - 50 , y: textView.contentSize.height - (buttonHeight * 2) - contentInset, width: 100, height: buttonHeight))
        
        button.setTitle("BUTTON", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        textView.addSubview(button)

        
        
    }
    
}

class SampleTextInputViewController: ButtonTappableViewController {
    let firstNameField = UITextField()
    let lastNameField = UITextField()
    
    let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(doneButton)
        firstNameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        firstNameField.placeholder = "First Name"
        firstNameField.backgroundColor = .white
        lastNameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)
        }
        lastNameField.placeholder = "Last Name"
        lastNameField.backgroundColor = .white
        doneButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        doneButton.setTitle("DONE", for: .normal)
        doneButton.backgroundColor = .white
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    override func didTap() {
        let alertVC = UIAlertController(title: "Complete",
                                        message: "Congratulations, you have finished.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}

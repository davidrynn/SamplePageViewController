//
//  SamplePageViewController.swift
//  SamplePageViewController
//
//  Created by David Rynn on 7/15/19.
//  Copyright © 2019 David Rynn. All rights reserved.
//

import UIKit
import SnapKit

class SamplePageViewController: UIPageViewController {
    
    // MARK: Properties
    
    var interactor: SamplePageInteractor?
    
    let headerHeight = 100

    lazy var controller1: SampleViewController =  {
        let controller = SampleViewController(offset: headerHeight)
        controller.view.backgroundColor = .green
        controller.delegate = self
        return controller
    }()
    lazy var controller2: SampleTextViewController = {
        let controller = SampleTextViewController(offset: headerHeight)
        controller.delegate = self
        return controller
    }()
    lazy var controller3: SampleViewController =  {
        let controller = SampleViewController(offset: headerHeight)
        controller.delegate = self
        controller.view.backgroundColor = .red
        return controller
    }()
    lazy var controller4: SampleTextInputViewController = {
        let controller = SampleTextInputViewController(offset: headerHeight)
        controller.delegate = self
        return controller
    }()
    var pages: [ButtonTappableViewController] = [] {
        didSet {
            pageControl.numberOfPages = pages.count
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
    
    let nextButton = UIButton()
    let backButton = UIButton()
    
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
        //attempting to add space above pages for potential header
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height - 200
        view.frame = CGRect(x: 0, y: 200, width: newWidth, height: newHeight)
        // end
        view.backgroundColor = .orange
        setupPages()
        setupControl()
        setupBox()
        setupHeader()
        dataSource = self
        delegate = self
    }
    
    func setupControl() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
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
        let box = UIView()
        box.backgroundColor = .purple
        view.addSubview(box)
        box.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(60)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func setupHeader() {
        let header = UIView()
        header.backgroundColor = .magenta
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.width.centerX.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        nextButton.addTarget(self, action: #selector(goToNextPage), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        nextButton.setTitle("Next", for: .normal)
        backButton.setTitle("Back", for: .normal)
        header.addSubview(nextButton)
        header.addSubview(backButton)
        nextButton.snp.makeConstraints { make in
            make.trailing.height.top.equalToSuperview()
            make.width.equalTo(60)
        }
        backButton.snp.makeConstraints{ make in
            make.leading.height.top.equalToSuperview()
            make.width.equalTo(60)
        }
        backButton.isHidden = true
    }
    
    // MARK: Actions
    
    @objc func didTapControl(_ control: UIPageControl) {
        setPage(pageIndex: control.currentPage)
    }
    
    func setPage(pageIndex: Int) {
        guard let currentController = viewControllers?.first as? ButtonTappableViewController, let currentIndex = pages.firstIndex(of: currentController), pageIndex < pages.count else { return }
        if currentIndex == pageIndex { return }
        let direction: UIPageViewController.NavigationDirection = currentIndex < pageIndex ? .forward : .reverse
        let controller = pages[pageIndex]
        self.setViewControllers([controller], direction: direction, animated: true, completion: { _ in
            if self.pageControl.currentPage != pageIndex { self.pageControl.currentPage = pageIndex }
        })
    }
    
    @objc func goToNextPage() {
        guard let current = viewControllers?.first as? ButtonTappableViewController, let currentIndex = pages.firstIndex(of: current) else {
            return
        }
        setPage(pageIndex: currentIndex + 1)
        if currentIndex + 2 >= pages.count {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        backButton.isHidden = false
        
    }
    
    @objc func goBack() {
        guard let current = viewControllers?.first as? ButtonTappableViewController, let currentIndex = pages.firstIndex(of: current) else {
            return
        }
        setPage(pageIndex: currentIndex - 1)
        if currentIndex - 1 <= 0 {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
        nextButton.isHidden = false
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
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let current = viewControllers?.first as? ButtonTappableViewController, let index = pages.firstIndex(of: current) {
            pageControl.currentPage = index
            if index == (pages.count - 1) {
                nextButton.isHidden = true
                return
            }
            if index == 0 {
                backButton.isHidden = true
                return
            }
            nextButton.isHidden = true
            backButton.isHidden = false
        }
    }

    
}

extension SamplePageViewController: ButtonTapable {
    func didTapButton() {
        goToNextPage()
    }
}

protocol ButtonTapable: class {
    func didTapButton()
}

class ButtonTappableViewController: UIViewController {
    weak var delegate: ButtonTapable?
    
    let headerOffset: Int
    let mainView = UIView()
    
    init(offset: Int) {
        headerOffset = offset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.backgroundColor = .yellow
        mainView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.centerY.equalToSuperview().offset(headerOffset)
            make.height.equalToSuperview().offset(headerOffset)
        }
    }

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
        mainView.addSubview(button)
        button.snp.makeConstraints { make -> Void in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.center.equalTo(self.view)
        }
    }
}

class SampleTextViewController: ButtonTappableViewController {

    override func viewDidLoad() {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Lorem ipsum dolor sit amet, in amet gravida ac exercitation sed, turpis cursus tortor egestas wisi sapien condimentum, dapibus nullam cras. Amet ac magna eget laoreet, fermentum nam dolore sapien faucibus suscipit, in in vivamus maecenas, semper nam quis neque in sed lectus. Egestas habitant auctor, vestibulum etiam orci, mauris ullamcorper tempor at, sed lacinia. Non fermentum earum nunc dapibus consequat, pede viverra ad varius mauris duis, commodo maecenas luctus at sed in, wisi faucibus proin vestibulum mauris neque tristique, mauris tincidunt nec mauris viverra eleifend pellentesque. Eu sed in rutrum, ultrices phasellus quis, sodales scelerisque nec, donec dictum pede integer adipiscing. Neque elit ultrices mauris fermentum, nostra quis phasellus integer libero.\nAdipiscing ante blanditiis mi, fermentum faucibus at aliquam rhoncus laoreet, sed quis id. Per rutrum eros arcu elementum integer quis, ipsum sit elementum ultricies wisi, at ornare at vehicula tincidunt. In viverra do eget, eros orci vitae nullam vel consequatur, id et congue aliquet proin, dui vitae nullam morbi, morbi vestibulum sit tempor sapien. Viverra vestibulum elementum phasellus sit odio, sed lectus quis. Tempor mi donec hymenaeos magna penatibus amet. Mattis torquent euismod, suscipit iaculis laoreet vel donec dolore ac, donec litora vel, a et amet. At sociis sed justo est pulvinar, nisl elit, id a amet et blandit sociosqu. Morbi hendrerit, vestibulum interdum a nibh, et consequat architecto iusto ac pulvinar, donec aenean. Montes gravida, venenatis proin eu dolor faucibus ut.\nSollicitudin justo velit parturient lorem. Elit aliquet sed posuere velit. Dolor justo donec a, vulputate amet ut non fermentum, nascetur rhoncus eget nunc et, tortor gravida etiam luctus, urna vestibulum bibendum placerat suscipit tellus. Eget vulputate consequuntur ante condimentum, orci sed proin blandit purus rerum, convallis tincidunt egestas, nibh sed, quisque donec eros eget eget. Cursus luctus nostra urna iaculis. Ultrices porttitor laoreet nec vestibulum. Tellus duis fringilla libero quam, odio parturient congue. Ligula nonummy lacus molestie, habitant non lacinia, fermentum sit congue. In mollis vitae in, dolor consectetur quam ligula turpis, ullamcorper enim maecenas erat ac morbi, sapien etiam ut. Morbi autem, at ornare nibh neque ipsum tempus nulla, dolor mattis est varius, condimentum dictum semper at lectus nec, ac felis. Et vestibulum quam nonummy, non hac eligendi.\nIn nulla volutpat lorem montes elit. Vel suspendisse lorem tortor eos, gravida parturient per tellus vestibulum ligula a, aenean sit suspendisse montes, amet porta pretium nunc aenean et. Nec mauris, habitasse lacus sollicitudin tortor lectus, pharetra et vel vehicula turpis aliquam, urna elit. Diam rutrum. Molestie consectetuer sagittis, nec eget aut fringilla mi mollis, habitasse vestibulum tellus ac velit amet justo, mauris tristique lectus leo dicta, in nullam mi. Auctor montes odio, consequat tempor vivamus rhoncus turpis nisl, urna elit parturient pulvinar pellentesque fusce. A ullamcorper pretium tincidunt donec. Sem velit mauris pharetra erat aliquam mauris, eleifend dolor vivamus in tristique magna mi, id interdum sed scelerisque purus vel, hendrerit convallis nam etiam curabitur curabitur taciti, sed eleifend at."
        mainView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(200)
            
        }
        let buttonHeight: CGFloat = 44
        let contentInset: CGFloat = 8
        
        //inset the textView
        textView.textContainerInset = UIEdgeInsets(top: contentInset, left: contentInset, bottom: (buttonHeight+contentInset*2), right: contentInset)
        
        let button = UIButton()
        //setup your button here
        button.setTitle("BUTTON", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        //Add the button to the text view
        textView.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(textView.snp.bottom)
        }
        
        
    }
    
}

class SampleTextInputViewController: ButtonTappableViewController {
    let firstNameField = UITextField()
    let lastNameField = UITextField()
    
    let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addSubview(firstNameField)
        mainView.addSubview(lastNameField)
        mainView.addSubview(doneButton)
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
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        doneButton.setTitle("DONE", for: .normal)
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


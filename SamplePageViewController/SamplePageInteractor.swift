//
//  SamplePageInteractor.swift
//  SamplePageViewController
//
//  Created by David Rynn on 7/16/19.
//  Copyright © 2019 David Rynn. All rights reserved.
//

import Foundation

protocol SamplePresenter: class {
    func callCompleted(responseData: String)
}

class SamplePageInteractor: SamplePageListener {
    
    weak var presenter: SamplePresenter?
    
    func didTapCTA(data: String) {
        //network code here, mocking network call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.presenter?.callCompleted(responseData: data)
        }
    }
}

//
//  SignUpViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/23/23.
//

import Foundation
import RxCocoa
import RxSwift

class SignUpViewModel: ViewModel {
    
    let fullNameRelay = BehaviorRelay(value: "")
    let emailRelay = BehaviorRelay(value: "")
    let passwordRelay = BehaviorRelay(value: "")
    let confirmPasswordRelay = BehaviorRelay(value: "")
    
    private let checkboxState = BehaviorRelay<Bool>(value: false)
    var checkboxStateObsevable: Observable<Bool> { checkboxState.asObservable() }
    
    func changeCheckboxState() {
        let state = !checkboxState.value
        checkboxState.accept(state)
    }
    
}


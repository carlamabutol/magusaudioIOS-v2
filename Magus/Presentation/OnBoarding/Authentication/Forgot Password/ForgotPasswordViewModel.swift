//
//  ForgotPasswordViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/27/23.
//

import Foundation
import RxSwift
import RxCocoa

class ForgotPasswordViewModel: ViewModel {
    
    let emailRelay = BehaviorRelay<String>(value: "")
    
}

//
//  ChangePasswordViewModel.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import Foundation
import RxSwift
import RxRelay

class ChangePasswordViewModel: ViewModel {
    
    let currentPasswordRelay = BehaviorRelay(value: "")
    let enterNewPasswordRelay = BehaviorRelay(value: "")
    let confirmNewPasswordRelay = BehaviorRelay(value: "")
    
    let contain8CharacterRelay = BehaviorRelay<ChangePasswordViewModel.PasswordRequirementModel>(
        value: .init(
            imageName: .check,
            text: LocalizedStrings.ChangePassword.contain8Characters
        )
    )
    
    override init() {
        super.init()
        currentPasswordRelay.asObservable()
            .subscribe { currentPassword in
                Logger.info(currentPassword, topic: .presentation)
            }
            .disposed(by: disposeBag)
        enterNewPasswordRelay.asObservable()
            .subscribe { newPassword in
                Logger.info(newPassword, topic: .presentation)
            }
            .disposed(by: disposeBag)
        confirmNewPasswordRelay.asObservable()
            .subscribe { confirmedPassword in
                Logger.info(confirmedPassword, topic: .presentation)
            }
            .disposed(by: disposeBag)
    }
    
}

extension ChangePasswordViewModel {
    struct PasswordRequirementModel {
        let imageName: ImageAsset
        let text: String
    }
}

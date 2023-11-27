//
//  AlertViewModel.swift
//  Magus
//
//  Created by Jomz on 8/10/23.
//

import Foundation

enum AlertModel {
    case loading(Bool)
    case alertModal(AlertViewModel)
}

struct AlertViewModel {
    let title: String
    let message: String
    let image: ImageAsset?
    let actionHandler: () -> ()
    
    init(title: String, message: String, image: ImageAsset? = nil, actionHandler: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.image = image
        self.actionHandler = actionHandler
    }
    
}

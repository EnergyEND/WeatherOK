//
//  KeyboardObserver.swift
//  WeatherOK
//
//  Created by MAC on 19.03.2023.
//

import Foundation
import SwiftUI


//MARK: Observer for change textField style:

class KeyboardObserver: ObservableObject {
    @Published var textOffset : CGFloat = 275
    @Published var textShadow : CGFloat = 0
    @Published var textOpacity : CGFloat = 1
    @Published var textFieldIsPressed = false

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] is CGRect else { return }
        textOffset = 250 //160
        textShadow = 30
        textOpacity = 0
        textFieldIsPressed = true
    }

    @objc func keyboardWillHide(notification: Notification) {
        textOffset = 275
        textShadow = 0
        textOpacity = 1
        textFieldIsPressed = false
    }
}

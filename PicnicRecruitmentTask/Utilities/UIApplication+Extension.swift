//
//  UIApplication+Extension.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import UIKit

// An extension on UIApplication to be able to dismiss the keyboard
// Since SwiftUI natively does not support keyboard dismiss functionality
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

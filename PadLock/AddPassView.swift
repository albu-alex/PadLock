//
//  AddPassView.swift
//  PadLock
//
//  Created by Alex Albu on 12.05.2023.
//

import UIKit
import SwiftUI
import PassKit

struct AddPassView: UIViewControllerRepresentable {
    typealias UIViewControllerType = PKAddPassesViewController
    
    var pass: PKPass
    
    func makeUIViewController(context: Context) -> PKAddPassesViewController {
        let passViewController = PKAddPassesViewController(pass: pass)
        return passViewController!
    }
    
    func updateUIViewController(_ uiViewController: PKAddPassesViewController, context: Context) {
        // Not needed
    }
}

//
//  ContentViewModel.swift
//  PadLock
//
//  Created by Alex Albu on 12.05.2023.
//

import SwiftUI
import PassKit

class ContentViewModel: ObservableObject {
    @ObservedObject var nfcReader = NFCReader()
    @ObservedObject var nfcWriter = NFCWriter()
    
    @Published var reading: String = "test"
    @Published var pkPass: PKPass?
    @Published var isPassAdded = false
    
    func read() {
        nfcReader.read()
        reading = nfcReader.msg
    }
    
    func write() {
        nfcWriter.msg = UUID().uuidString
        nfcWriter.write()
    }
    
    func addToWallet() {
        HTTPClient.get(url: URL(string: "http://localhost:3000/generate-pass")!) { [weak self] data, response, error in
            guard let self else { return }
            self.pkPass = try? PKPass(data: data!)
            self.isPassAdded = true
        }
    }
}

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
    @Published var isLoading = false
    
    func read() {
        nfcReader.read()
        reading = nfcReader.msg
    }
    
    func write() {
        nfcWriter.msg = UUID().uuidString
        nfcWriter.write()
    }
    
    func addToWallet() {
        isLoading = true
        HTTPClient.get(url: URL(string: Environment.production + "/generate-pass")!) { [weak self] data, response, error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.pkPass = try? PKPass(data: data!)
                self.isLoading = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isPassAdded = true
            }
        }
    }
}

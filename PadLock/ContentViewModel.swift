//
//  ContentViewModel.swift
//  PadLock
//
//  Created by Alex Albu on 12.05.2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @ObservedObject var nfcReader = NFCReader()
    @ObservedObject var nfcWriter = NFCWriter()
    
    @Published var reading: String = "test"
    
    func read() {
        nfcReader.read()
        reading = nfcReader.msg
    }
    
    func write() {
        nfcWriter.msg = UUID().uuidString
        nfcWriter.write()
    }
}

//
//  SwiftNFC.swift
//  PadLock
//
//  Created by Alex Albu on 12.05.2023.
//

import SwiftUI
import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var startAlert = "Hold your iPhone near the tag."
    @Published var endAlert = ""
    @Published var msg = ""
    @Published var raw = ""
    
    private var session: NFCNDEFReaderSession?
    
    func read() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("Error")
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = startAlert
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            self.msg = messages.map {
                $0.records.map {
                    String(decoding: $0.payload, as: UTF8.self)
                }.joined(separator: "\n")
            }.joined(separator: " ")
            
            self.raw = messages.map {
                $0.records.map {
                    "\($0.typeNameFormat) \(String(decoding: $0.type, as: UTF8.self)) \(String(decoding: $0.identifier, as: UTF8.self)) \(String(decoding: $0.payload, as: UTF8.self))"
                }.joined(separator: "\n")
            }.joined(separator: " ")
            
            session.alertMessage = self.endAlert != "" ? self.endAlert : "Read \(messages.count) NDEF Messages, and \(messages[0].records.count) Records."
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Session did invalidate with error: \(error)")
        self.session = nil
    }
}

class NFCWriter: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var startAlert = "Hold your iPhone near the tag."
    @Published var endAlert = ""
    @Published var msg = ""
    @Published var type = "T"
    
    private var session: NFCNDEFReaderSession?
    
    func write() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("Error")
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = startAlert
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "Detected more than 1 tag. Please try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }
        
        let tag = tags.first!
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the status of tag."
                    session.invalidate()
                    return
                }
                
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Read only tag detected."
                    session.invalidate()
                case .readWrite:
                    let payload: NFCNDEFPayload?
                    if self.type == "T" {
                        payload = NFCNDEFPayload(
                            format: .nfcWellKnown,
                            type: Data("\(self.type)".utf8),
                            identifier: Data(),
                            payload: Data("\(self.msg)".utf8)
                        )
                    } else {
                        payload = NFCNDEFPayload.wellKnownTypeURIPayload(string: "\(self.msg)")
                    }
                    let message = NFCNDEFMessage(records: [payload].compactMap({ $0 }))
                    tag.writeNDEF(message) { (error: Error?) in
                        if let error = error {
                            session.alertMessage = "Write to tag fail: \(error)"
                        } else {
                            session.alertMessage = self.endAlert != "" ? self.endAlert : "Write \(self.msg) to tag successful."
                        }
                        session.invalidate()
                    }
                @unknown default:
                    session.alertMessage = "Unknown tag status."
                    session.invalidate()
                }
            }
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Session did invalidate with error: \(error)")
        self.session = nil
    }
}

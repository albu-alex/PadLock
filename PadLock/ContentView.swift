//
//  ContentView.swift
//  PadLock
//
//  Created by Alex Albu on 12.05.2023.
//

import SwiftUI
import PassKit

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome to PadLock")
                .foregroundColor(Colors.pink)
                .font(.title)
                .bold()
            Spacer()
            Text(viewModel.reading)
                .foregroundColor(Colors.blue)
                .font(.body)
            Spacer()
            Button("Write") {
                viewModel.write()
            }
            Spacer()
            AddPassToWalletButton {
                viewModel.read()
            }
            .frame(height: 60)
            .padding(.horizontal, 28)
        }
        .padding()
        .background(Colors.lightBlue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
            Text("PadLock - Yonder")
                .foregroundColor(Colors.pink)
                .font(.title)
                .bold()
            Spacer()
            
            ZStack {
                Colors.blue
                    .cornerRadius(10)
                    .opacity(0.1)
                    .padding(.all, 20)
                    .blur(radius: 10)
                
                Text(viewModel.reading)
                    .foregroundColor(Colors.blue)
                    .font(.body)
                    .padding()
            }
            Spacer()
            
            VStack(spacing: 24) {
                ActionButton(title: "Write", image: "square.and.arrow.down") {
                    viewModel.write()
                }
                
                ActionButton(title: "Read", image: "square.and.arrow.up") {
                    viewModel.read()
                }
                
                AddPassToWalletButton {
                    viewModel.addToWallet()
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .sheet(isPresented: $viewModel.isPassAdded) {
                    AddPassView(pass: viewModel.pkPass!)
                }
            }
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

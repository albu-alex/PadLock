//
//  ActionButton.swift
//  PadLock
//
//  Created by Alex Albu on 13.05.2023.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: action) {
                HStack {
                    Image(systemName: image)
                        .foregroundColor(.white)
                    
                    Spacer()

                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 60)
                }
                .padding(.horizontal, 92)
            }
            .background(Colors.blue)
            .cornerRadius(6)
            .padding(.leading, 16)
        }
        .frame(height: 60)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "Add to Wallet", image: "square.and.arrow.up") {
            // Preview action
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.white)
    }
}

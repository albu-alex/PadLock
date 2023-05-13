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
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: action) {
                HStack {
                    Spacer()
                    Image(systemName: image)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(height: 60)
                    Spacer()
                }
            }
            .background(backgroundColor)
            .cornerRadius(6)
            .padding(.horizontal, 20)
        }
        .frame(height: 60)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "Add to Wallet", image: "square.and.arrow.up", backgroundColor: Colors.blue) {
            // Preview action
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.white)
    }
}

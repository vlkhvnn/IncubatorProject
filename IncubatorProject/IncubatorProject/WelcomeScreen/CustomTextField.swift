//
//  CustomTextField.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 17.07.2023.
//

import Foundation
import SwiftUI
import iPhoneNumberField

struct PhoneTextField: View {
    var hint: String
    @Binding var text: String
    @FocusState var isEnabled: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("+7 ")
                iPhoneNumberField(hint, text: $text)
                    .font(UIFont(size: 17, weight: .light, design: .monospaced))
                    .clearButtonMode(.whileEditing)
                    .placeholderColor(Color(.blue))
                    .prefixHidden(false)
                    .maximumDigits(10)
                    .focused($isEnabled)
            }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.2))
                Rectangle()
                    .fill(.black)
                    .frame(width: isEnabled ? nil : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: isEnabled)
                
            }.frame(height: 2)
            
        }
        
    }
}

struct CustomTextField : View {
    var hint: String
    @Binding var text: String
    
    @FocusState var isEnabled: Bool
    var contentType : UITextContentType = .telephoneNumber
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField(hint, text: $text)
                .keyboardType(.numberPad)
                .textContentType(contentType)
                .focused($isEnabled)
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.2))
                Rectangle()
                    .fill(.black)
                    .frame(width: isEnabled ? nil : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: isEnabled)
                
            }.frame(height: 2)
            
        }
    }
}

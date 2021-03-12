//
//  File.swift
//  
//
//  Created by Dave Glassco on 1/20/21.
//

import SwiftUI

struct NDCustomKeyboard: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var returnText: String
    @Binding var showCustomBar: Bool
    
    var placeholder: String?

    func makeUIView(context: Context) -> UITextView {
        let textView =  UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isUserInteractionEnabled = true
        textView.text = placeholder
        textView.backgroundColor = UIColor.clear
        textView.returnKeyType = .default
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.text = text
        textView.delegate = context.coordinator
        textView.layoutManager.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
//        if isFirstResponder && !context.coordinator.isFirstResponder  {
//            uiView.becomeFirstResponder()
//            context.coordinator.isFirstResponder = true
//        }
    }
    
    func makeCoordinator() -> NDCustomKeyboard.Coordinator {
        return Coordinator(text: $text, returnText: $returnText, showCustomBar: $showCustomBar)
    }
    
    class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate {

        @Binding var text: String
        @Binding var returnText: String
        @Binding var showCustomBar: Bool

        init(text: Binding<String>, returnText: Binding<String>, showCustomBar: Binding<Bool>) {
            _text = text
            _returnText = returnText
            _showCustomBar = showCustomBar
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            $text.wrappedValue = uiView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.becomeFirstResponder()
            showCustomBar = true
        }
            
        func textViewDidEndEditing(_ textView: UITextView) {
            self.returnText = textView.text ?? ""
            textView.resignFirstResponder()
            showCustomBar = false
        }
        
        
        func textView( _ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                if (text == "\n") {
                    textView.resignFirstResponder()
                    return false
                }
                return true
            }
    }
}



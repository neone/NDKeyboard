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
    @Binding var isFirstResponder: Bool
    @Binding var showCustomBar: Bool
    @Binding var calculatedHeight: CGFloat
    
    var hideKeyboard: () -> Void
    var returnMethod: () -> Void
    
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
        if isFirstResponder && !context.coordinator.isFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.isFirstResponder = true
        }
    }
    
    func makeCoordinator() -> NDCustomKeyboard.Coordinator {
        return Coordinator(text: $text, returnText: $returnText, isFirstResponder: $isFirstResponder, showCustomBar: $showCustomBar, height: $calculatedHeight, hideKeyboard: hideKeyboard, returnMethod: returnMethod)
    }
    
    class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate {

        @Binding var text: String
        @Binding var returnText: String
        @Binding var isFirstResponder: Bool
        @Binding var showCustomBar: Bool
        var calculatedHeight: Binding<CGFloat>
        var hideKeyboard: () -> Void
        var returnMethod: () -> Void

        init(text: Binding<String>, returnText: Binding<String>, isFirstResponder: Binding<Bool>, showCustomBar: Binding<Bool>, height: Binding<CGFloat>, hideKeyboard: @escaping ()->Void, returnMethod: @escaping ()->Void) {
            _text = text
            _returnText = returnText
            _isFirstResponder = isFirstResponder
            _showCustomBar = showCustomBar
            self.calculatedHeight = height
            self.hideKeyboard = hideKeyboard
            self.returnMethod = returnMethod
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            $text.wrappedValue = uiView.text
//            NDCustomKeyboard.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.becomeFirstResponder()
            showCustomBar = true
        }
            
        func textViewDidEndEditing(_ textView: UITextView) {
            self.returnText = textView.text ?? ""
            textView.resignFirstResponder()
            showCustomBar = false
            hideKeyboard()
            returnMethod()
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



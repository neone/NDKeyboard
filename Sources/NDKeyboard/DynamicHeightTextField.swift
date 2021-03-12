//
//  File.swift
//  
//
//  Created by Dave Glassco on 3/11/21.
//

import SwiftUI

struct DynamicHeightTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var returnText: String
    @Binding var height: CGFloat
    @Binding var showCustomBar: Bool
    @Binding var isFirstResponder: Bool
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        
        textView.text = text
        textView.backgroundColor = UIColor.clear
        
        context.coordinator.textView = textView
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

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, returnText: $returnText, isFirstResponder: $isFirstResponder, showCustomBar: $showCustomBar, dynamicSizeTextField: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate {
        @Binding var text: String
        @Binding var returnText: String
        @Binding var isFirstResponder: Bool
        @Binding var showCustomBar: Bool
        
        var dynamicHeightTextField: DynamicHeightTextField
        
        weak var textView: UITextView?
        
        
        init(text: Binding<String>, returnText: Binding<String>, isFirstResponder: Binding<Bool>, showCustomBar: Binding<Bool>, dynamicSizeTextField: DynamicHeightTextField) {
            _text = text
            _returnText = text
            _isFirstResponder = isFirstResponder
            _showCustomBar = showCustomBar
            self.dynamicHeightTextField = dynamicSizeTextField
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
            self.dynamicHeightTextField.text = textView.text
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
        
        //converts new line into return??
//        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//            if (text == "\n") {
//                textView.resignFirstResponder()
//                return false
//            }
//            return true
//        }
        
        func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
            
            DispatchQueue.main.async { [weak self] in
                guard let textView = self?.textView else {
                    return
                }
                let size = textView.sizeThatFits(textView.bounds.size)
                if self?.dynamicHeightTextField.height != size.height {
                    self?.dynamicHeightTextField.height = size.height
                }
            }
            
        }
    }
}


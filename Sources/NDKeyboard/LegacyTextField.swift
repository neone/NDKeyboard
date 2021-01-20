//
//  File.swift
//  
//
//  Created by Dave Glassco on 1/20/21.
//

import SwiftUI


struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        @Binding var returnText: String
        var hideKeyboard: () -> Void
        var didBecomeFirstResponder = false

        init(text: Binding<String>, returnText: Binding<String>, hideKeyboard: @escaping ()->Void) {
            _text = text
            _returnText = returnText
            self.hideKeyboard = hideKeyboard
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.returnText = textField.text ?? ""
            textField.resignFirstResponder()
            hideKeyboard()
            return true
        }

    }

    @Binding var text: String
    @Binding var returnText: String
    @Binding var isFirstResponder: Bool
    
    var placeholder: String?

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, returnText: $returnText, hideKeyboard: hideKeyboard)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

//public struct LegacyTextField: UIViewRepresentable {
//    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
//    
//    @Binding public var isFirstResponder: Bool
//    @Binding public var text: String
//    
//    private var placeholder: String
//    
//    var font: UIFont?
//    var foregroundColor: UIColor?
//    var accentColor: UIColor?
//    var textAlignment: NSTextAlignment?
//    var contentType: UITextContentType?
//    
//    var autocorrection: UITextAutocorrectionType = .default
//    var autocapitalization: UITextAutocapitalizationType = .sentences
//    var keyboardType: UIKeyboardType = .default
//    var returnKeyType: UIReturnKeyType = .default
//    
//    public var configuration = { (view: UITextField) in }
//    
//    public init( placeholder: String, text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> () = { _ in }) {
//        self.placeholder = placeholder
//        self.configuration = configuration
//        self._text = text
//        self._isFirstResponder = isFirstResponder
//    }
//    
//    public func makeUIView(context: Context) -> UITextField {
//        let textField = UITextField()
//        textField.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
//        textField.delegate = context.coordinator
//        
//        textField.placeholder = placeholder
//        textField.font = font
//        textField.textColor = foregroundColor
//        
//        if let textAlignment = textAlignment {
//            textField.textAlignment = textAlignment
//        }
//        
//        if let contentType = contentType {
//            textField.textContentType = contentType
//        }
//        if let accentColor = accentColor {
//            textField.tintColor = accentColor
//        }
//        
//        textField.autocorrectionType = autocorrection
//        textField.autocapitalizationType = autocapitalization
//        textField.keyboardType = keyboardType
//        textField.returnKeyType = returnKeyType
//        
//        return textField
//    }
//    
//    public func updateUIView(_ uiView: UITextField, context: Context) {
//        uiView.text = text
//        switch isFirstResponder {
//        case true: uiView.becomeFirstResponder()
//        case false: uiView.resignFirstResponder()
//        }
//    }
//    
//    public func makeCoordinator() -> Coordinator {
//        Coordinator($text, isFirstResponder: $isFirstResponder)
//    }
//    
//    public class Coordinator: NSObject, UITextFieldDelegate {
//        var text: Binding<String>
//        var isFirstResponder: Binding<Bool>
//        
//        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
//            self.text = text
//            self.isFirstResponder = isFirstResponder
//        }
//        
//        @objc public func textViewDidChange(_ textField: UITextField) {
//            self.text.wrappedValue = textField.text ?? ""
//        }
//        
//        public func textFieldDidBeginEditing(_ textField: UITextField) {
//            self.isFirstResponder.wrappedValue = true
//        }
//        
//        public func textFieldDidEndEditing(_ textField: UITextField) {
//            self.isFirstResponder.wrappedValue = false
//        }
//    }
//}

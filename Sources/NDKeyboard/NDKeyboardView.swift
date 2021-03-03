//
//  NDKeyboardView.swift
//  NDKeyboardApp
//
//  Created by Dave Glassco on 12/24/20.
//

import SwiftUI

public struct NDKeyboardView: View {
    public init(inputText: Binding<String>, returnText: Binding<String>, isFirstResponder:  Binding<Bool>, quickEmojis: [String], hightlightColor: Color, viewBackgroundColor: Color, textBackgroundColor: Color, shadowColor: Color, hideKeyboard: @escaping () -> Void, returnMethod: @escaping () -> Void) {
        self._inputText = inputText
        self._returnText = returnText
        self._isFirstResponder = isFirstResponder
        self.quickEmojis = quickEmojis
        self.hightlightColor = hightlightColor
        self.viewBackgroundColor = viewBackgroundColor
        self.textBackgroundColor = textBackgroundColor
        self.shadowColor = shadowColor
        self.hideKeyboard = hideKeyboard
        self.returnMethod = returnMethod
        
    }
    
    @Binding var inputText: String
    @Binding var returnText: String
    @Binding var isFirstResponder: Bool
    
   
    var quickEmojis: [String]
    
    var doneButtonLabel: String = ""
    var defaultText: String = ""
    
    var hightlightColor: Color
    var viewBackgroundColor: Color
    var textBackgroundColor: Color
    var shadowColor: Color
    
    var hideKeyboard: () -> Void
    var returnMethod: () -> Void
    
    func emojiButton(_ emoji: String) -> Button<Text> {
        Button {
            self.inputText += emoji
        } label: {
            Text(emoji)
        }
    }
    
    public var body: some View {
        VStack(spacing:0) {
            //Quick Emojis
            HStack(alignment: .center) {
                
                ForEach(quickEmojis, id: \.self) { symbol in
                    emojiButton(symbol)
                }
                
                Spacer()
                Button(action: {
                    returnText = inputText
                    self.hideKeyboard()
                }, label: {
                    Text("Done")
                        .foregroundColor(hightlightColor)
                })
            }
            .padding(.top,8)
            .padding(.horizontal,12)
            .padding(.bottom,4)
            .frame(height: 32)
            
            HStack {
                
                NDCustomKeyboard(text: $inputText, returnText: $returnText ,isFirstResponder: $isFirstResponder, hideKeyboard: hideKeyboard, returnMethod: returnMethod)
                    .padding(.top,4)
                    .padding(.horizontal,8)
                    .padding(.bottom, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(textBackgroundColor))
                
                Spacer()
                
                if !inputText.isEmpty {
                    Button(
                        action: { self.inputText = "" },
                        label: {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .foregroundColor(Color(UIColor.opaqueSeparator))
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                    )
                }
            }.padding(8)
            .frame(height: 48)
            
        }
        .background(viewBackgroundColor)
        
        viewBackgroundColor
            .edgesIgnoringSafeArea(.bottom)
            .frame(height:2)
    }
}


struct NDKeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0.0) {
            Spacer()
            NDKeyboardView(inputText: .constant("inputText"), returnText: .constant(""), isFirstResponder: .constant(false), quickEmojis: ["👍", "😂", "❤️","😢","😡"], hightlightColor: Color.orange, viewBackgroundColor: Color(.tertiarySystemGroupedBackground), textBackgroundColor: Color(.systemBackground), shadowColor: Color(.darkGray), hideKeyboard: {}, returnMethod: {})
        }
    }
}

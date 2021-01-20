//
//  NDKeyboardView.swift
//  NDKeyboardApp
//
//  Created by Dave Glassco on 12/24/20.
//

import SwiftUI

public struct NDKeyboardView: View {
    public init(inputText: Binding<String>, returnText: Binding<String>, quickEmojis: [String], hideKeyboard: @escaping () -> Void) {
        self._inputText = inputText
        self._returnText = returnText
        self.quickEmojis = quickEmojis
        self.hideKeyboard = hideKeyboard
        
    }
    
    @Binding var inputText: String
    @Binding var returnText: String
    @State var isFirstResponder = false
    
    enum FirstResponders: Int {
            case quickComment
        }
    @State var firstResponder: FirstResponders? = nil
    
    var quickEmojis: [String]
    
    var doneButtonLabel: String = ""
    var defaultText: String = ""
    
    var hightlightColor: Color = Color(.systemBlue)
    var viewBackgroundColor: Color = Color(.secondarySystemBackground)
    var textBackgrounColor: Color = Color(.systemBackground)
    
    var hideKeyboard: () -> Void
    
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
                
                
                TextField(defaultText, text: $inputText, onCommit: {
                    returnText = inputText
                })
                .padding(.top,4)
                .padding(.horizontal,8)
                .padding(.bottom, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(textBackgrounColor))
                
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

//
//  NDKeyboardView.swift
//  NDKeyboardApp
//
//  Created by Dave Glassco on 12/24/20.
//

import SwiftUI
import SFSafeSymbols

public struct NDKeyboardView: View {
    public init(inputText: Binding<String>, returnText: Binding<String>, isFirstResponder:  Binding<Bool>, showAddCommentImage: Bool, addCommentImage: Image?, addCommentColor: Color?, quickEmojis: [String], showQuickEmojis: Bool, hightlightColor: Color, returnButtonLabel: String, viewBackgroundColor: Color, textBackgroundColor: Color, hideKeyboard: @escaping () -> Void, returnMethod: @escaping () -> Void) {
        self._inputText = inputText
        self._returnText = returnText
        self._isFirstResponder = isFirstResponder
        self.showAddCommentImage = showAddCommentImage
        self.addCommentImage = addCommentImage
        self.addCommentColor = addCommentColor
        self.quickEmojis = quickEmojis
        self.showQuickEmojis = showQuickEmojis
        self.hightlightColor = hightlightColor
        self.returnButtonLabel = returnButtonLabel
        self.viewBackgroundColor = viewBackgroundColor
        self.textBackgroundColor = textBackgroundColor
        self.hideKeyboard = hideKeyboard
        self.returnMethod = returnMethod
    }
    
    @Binding var inputText: String
    @Binding var returnText: String
    @Binding var isFirstResponder: Bool
    @State var showCustomBar: Bool = false
    
    var showAddCommentImage: Bool
    var addCommentImage: Image?
    var addCommentColor: Color?
    
    var quickEmojis: [String]
    var showQuickEmojis: Bool
    
    var doneButtonLabel: String = ""
    var defaultText: String = ""
    var returnButtonLabel: String
    
    var hightlightColor: Color
    var viewBackgroundColor: Color
    var textBackgroundColor: Color
    
    var hideKeyboard: () -> Void
    var returnMethod: () -> Void
    
    func doneAction() {
        returnText = inputText
        returnMethod()
        hideKeyboard()
        showCustomBar = false
        isFirstResponder = false
    }

    public var body: some View {
        VStack(spacing:0) {
            if showCustomBar {
                HStack {
                    if showQuickEmojis {
                        QuickEmojiView(inputText: $inputText, quickEmojis: quickEmojis, hightlightColor: hightlightColor)
                    }
                    Spacer()
                    
                    Button(action: {
                        doneAction()
                    }, label: {
                        HStack {
                            Text(returnButtonLabel)
                                .foregroundColor(hightlightColor)
                            Image(systemName: SFSymbol.paperplane.rawValue)
                        }
                    })
                }
                .padding(.horizontal,12)
                .frame(height: 32)
            }
            
            HStack {
               
                
                ZStack {
                    NDCustomKeyboard(text: $inputText, returnText: $returnText ,isFirstResponder: $isFirstResponder, showCustomBar: $showCustomBar, hideKeyboard: hideKeyboard, returnMethod: returnMethod)
                        .padding(.top,4)
                        .padding(.horizontal,8)
                        .padding(.bottom, 8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(textBackgroundColor))
                    
                    if inputText.isEmpty && showAddCommentImage == true {
                        if addCommentImage != nil {
                            HStack {
                                addCommentImage!
                                    .resizable()
                                    .foregroundColor(addCommentColor)
                                    .frame(width: 28, height: 28)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }
                
                Spacer()
                
                if !inputText.isEmpty {
                    Button(
                        action: { self.inputText = "" },
                        label: {
                            Image(systemName: SFSymbol.xCircleFill.rawValue)
                                .resizable()
                                .foregroundColor(Color(UIColor.opaqueSeparator))
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                    )
                }
            }
            .padding(8)
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
            NDKeyboardView(inputText: .constant(""), returnText: .constant(""), isFirstResponder: .constant(false), showAddCommentImage: true, addCommentImage: Image(systemName: "plus.circle"), addCommentColor: Color.orange , quickEmojis: ["👍", "😂", "❤️","😢","😡"], showQuickEmojis: false, hightlightColor: Color.orange, returnButtonLabel: "Done", viewBackgroundColor: Color(.tertiarySystemGroupedBackground), textBackgroundColor: Color(.systemBackground), hideKeyboard: {}, returnMethod: {})
        }
    }
}

struct QuickEmojiView: View {
    @Binding var inputText: String
    var quickEmojis: [String]
    var hightlightColor: Color
    
    func emojiButton(_ emoji: String) -> Button<Text> {
        Button {
            self.inputText += emoji
        } label: {
            Text(emoji)
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            ForEach(quickEmojis, id: \.self) { symbol in
                emojiButton(symbol)
            }
        }
        .padding(.top,8)
        .padding(.bottom,4)
        .frame(height: 32)
    }
}

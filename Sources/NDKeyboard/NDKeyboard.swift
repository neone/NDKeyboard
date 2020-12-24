//
//  NDKeyboard.swift
//  NDKeyboardApp
//
//  Created by Dave Glassco on 12/24/20.
//

import SwiftUI

struct NDKeyboard: View {
    @Binding var inputText: String
    @Binding var returnText: String
    
    @State var quickEmojis: [String]
    @State var doneButtonLabel: String
    
    @State var defaultText: String
    @State var hightlightColor: Color
    @State var viewBackgroundColor: Color
    @State var textBackgrounColor: Color
    
    var hideKeyboard: () -> Void
    
    func emojiButton(_ emoji: String) -> Button<Text> {
        Button {
            self.inputText += emoji
        } label: {
            Text(emoji)
        }
    }
    
    var body: some View {
        VStack(spacing:0) {
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
        }
        .background(viewBackgroundColor)
    }
}

struct NDKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        NDKeyboard(inputText: .constant(""), returnText: .constant(""), quickEmojis: ["👍", "😂", "❤️","😢","😡"], doneButtonLabel: "Done", defaultText: "Type Something", hightlightColor: Color.orange, viewBackgroundColor: Color(.secondarySystemBackground), textBackgrounColor: Color(.systemBackground))
            .previewLayout(PreviewLayout.sizeThatFits)
        
        NDKeyboard(inputText: .constant(""), returnText: .constant(""), quickEmojis: ["👍", "😂", "❤️","😢","😡"], doneButtonLabel: "Done", defaultText: "Type Something", hightlightColor: Color.orange, viewBackgroundColor: Color(.secondarySystemBackground), textBackgrounColor: Color(.systemBackground))
            .previewLayout(PreviewLayout.sizeThatFits)
            .colorScheme(.dark)
    }
}

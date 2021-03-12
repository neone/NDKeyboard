//
//  NDKeyboardView.swift
//  NDKeyboardApp
//
//  Created by Dave Glassco on 12/24/20.
//

import SwiftUI
import Combine
import SFSafeSymbols

public enum CustomBarItems {
    case attachments
    case emoji
    case none
}

public struct CustomBarButton {
    public init(buttonImage: Image, buttonLabel: String? = nil, returnMethod: @escaping () -> Void) {
        self.buttonImage = buttonImage
        self.buttonLabel = buttonLabel
        self.returnMethod = returnMethod
    }
    
    public var buttonImage: Image
    public var buttonLabel: String?
    public var returnMethod: () -> Void
}

let testButtons = [
    CustomBarButton(buttonImage: Image(systemName: "camera.fill"), returnMethod: {}),
    CustomBarButton(buttonImage: Image(systemName: "photo.fill"), returnMethod: {}),
    CustomBarButton(buttonImage: Image(systemName: "folder.fill"), returnMethod: {})
]


public struct NDKeyboardView: View {
    
    public init(inputText: Binding<String>, returnText: Binding<String>, showCustomBar: Bool, showAddCommentImage: Bool, addCommentImage: Image?, addCommentColor: Color?, quickEmojis: [String], customBarItems: CustomBarItems, customBarButtons: [CustomBarButton]?, customBarLinkButton: CustomBarButton?, buttonTint: Color, viewWidth: CGFloat, hightlightColor: Color, returnButtonLabel: String, viewBackgroundColor: Color, textBackgroundColor: Color, returnMethod: @escaping () -> Void) {
        self._inputText = inputText
        self._returnText = returnText
        _showCustomBar = State(initialValue: false)
        self.showAddCommentImage = showAddCommentImage
        self.addCommentImage = addCommentImage
        self.addCommentColor = addCommentColor
        self.quickEmojis = quickEmojis
        self.customBarItems = customBarItems
        self.customBarButtons = customBarButtons
        self.customBarLinkButton = customBarLinkButton
        self.buttonTint = buttonTint
        self.viewWidth = viewWidth
        self.hightlightColor = hightlightColor
        self.returnButtonLabel = returnButtonLabel
        self.viewBackgroundColor = viewBackgroundColor
        self.textBackgroundColor = textBackgroundColor
        self.returnMethod = returnMethod
    }
    
    @Binding var inputText: String
    @Binding var returnText: String
    @State var showCustomBar: Bool
    @Binding var isFirstResponder: Bool
    @State private var viewHeight: CGFloat = 40
    
    var customBarItems: CustomBarItems
    var customBarButtons: [CustomBarButton]?
    var customBarLinkButton: CustomBarButton?
    var buttonTint: Color
    var viewWidth: CGFloat
    var showAddCommentImage: Bool
    var addCommentImage: Image?
    var addCommentColor: Color?
    var quickEmojis: [String]
    var doneButtonLabel: String = ""
    var defaultText: String = ""
    var returnButtonLabel: String
    var hightlightColor: Color
    var viewBackgroundColor: Color
    var textBackgroundColor: Color
    var returnMethod: () -> Void
    
    func returnAction() {
        returnText = inputText
        returnMethod()
        showCustomBar = false
        //        isFirstResponder = false
    }
    
    @State var textHeight: CGFloat = 0
    
    var textFieldHeight: CGFloat {
        let minHeight: CGFloat = 32
        let maxHeight: CGFloat = 70
        
        if textHeight < minHeight {
            return minHeight
        }
        
        if textHeight > maxHeight {
            return maxHeight
        }
        
        return textHeight
    }
    
    public var body: some View {
        VStack(spacing:0) {
            VStack(spacing:0) {
                if showCustomBar {
                    if let buttons = customBarButtons{
                        HStack(alignment: .center) {
                            ForEach(0..<buttons.count) { index in
                                    Button(action: {
                                        buttons[index].returnMethod()
                                    }, label: {
                                        VStack {
                                            Spacer()
                                                .frame(height: 10)
                                            buttons[index].buttonImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 28, height:28)
                                            .padding(.horizontal, 4)
                                            .foregroundColor(buttonTint)
                                        if let label = buttons[index].buttonLabel {
                                            Text(label)
                                        }
                                    }
                                })
                            }
                            
                            if let linkButton = customBarLinkButton {
                                
                                Separator()
                                VStack {
                                    Spacer()
                                    Button(action: {
                                        
                                    }, label: {
                                        VStack {
                                            linkButton.buttonImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 28, height:28)
                                            .padding(.horizontal, 4)
                                            .foregroundColor(buttonTint)
                                        if let label = linkButton.buttonLabel {
                                            Text(label)
                                        }
                                    }
                                })
                            }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                returnAction()
                            }, label: {
                                HStack(alignment: .center) {
                                    Text(returnButtonLabel)
                                        .foregroundColor(hightlightColor)
                                    Image(systemName: SFSymbol.paperplane.rawValue)
                                        .foregroundColor(hightlightColor)
                                }
                                .padding(.top,8)
                            })
                        }
                        .padding(.horizontal,16)
                        .frame(height: 36)
                    }
                } else {
                    viewBackgroundColor
                        .frame(height:4)
                }
                
                HStack {
                    DynamicHeightTextField(text: $inputText, returnText: $returnText, height: $textHeight, showCustomBar: $showCustomBar, isFirstResponder: <#Binding<Bool>#>)
                        .padding(.top,4)
                        .padding(.horizontal,8)
                        .padding(.bottom, 8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(textBackgroundColor))
                        .frame(height: textFieldHeight)
                    
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
                .frame(minHeight: 48)
            }
            .background(viewBackgroundColor)
            
            viewBackgroundColor
                .edgesIgnoringSafeArea(.bottom)
                .frame(height:2)
        }
    }
}

struct NDKeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0.0) {
            Spacer()
            NDKeyboardView(inputText: .constant("inputText"), returnText: .constant(""), showCustomBar: true, showAddCommentImage: true, addCommentImage: Image(systemName: "plus.circle"), addCommentColor: Color.orange , quickEmojis: [], customBarItems: .attachments, customBarButtons: testButtons, customBarLinkButton: CustomBarButton(buttonImage: Image(systemName: "safari.fill"), returnMethod: {}), buttonTint: Color(.gray), viewWidth: UIScreen.main.bounds.width, hightlightColor: Color.orange, returnButtonLabel: "Done", viewBackgroundColor: Color(.tertiarySystemGroupedBackground), textBackgroundColor: Color(.systemBackground), returnMethod: {})
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


final class UserData: ObservableObject  {
    let didChange = PassthroughSubject<UserData, Never>()
    
    var text = "" {
        didSet {
            didChange.send(self)
        }
    }
    
    init(text: String) {
        self.text = text
    }
}

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.backgroundColor = UIColor(Color(.secondarySystemGroupedBackground))
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct Separator: View {
    var body: some View {
        VStack {
            Spacer()
            Color(.secondaryLabel)
                .frame(width:2)
                .padding(.vertical,4)
        }
    }
}

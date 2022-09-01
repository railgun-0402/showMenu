//
//  CopyUILabel.swift
//  showMenuProject
//
//  Created by 菅原大輝 on 2022/08/31.
//

import UIKit

class CopyUILabel: UILabel, UIEditMenuInteractionDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.copyInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.copyInit()
    }
    
    func copyInit() {
        // タップ有効
        self.isUserInteractionEnabled = true
        
        // 長押しコピー
        //self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(CopyUILabel.showMenu(sender:))))
        // 軽くタッチコピー
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CopyUILabel.showMenu(_:))))
    }
    
    @objc func showMenu(_ recognizer: UIGestureRecognizer) {
        self.becomeFirstResponder()
        
        if #available(iOS 16.0, *) {
            // iOS16以降は「UIEditMenuInteraction」を使用する
            let editMenuInteraction = UIEditMenuInteraction(delegate: self)
            
            // 画面の大まかな場所を決める
            let location = recognizer.location(in: self) // locationの引数は任意のViewを入れる
            let configuration = UIEditMenuConfiguration(identifier: nil, sourcePoint: location)
            
            // メニュー表示する
            editMenuInteraction.presentEditMenu(with: configuration)
            
        } else {
            // iOS16からUIMenuControllerが非推奨になるため
            let contextMenu = UIMenuController.shared
            
            if !contextMenu.isMenuVisible {
                contextMenu.showMenu(from: self, rect: self.bounds)
            }

        }
    }
    
    override func copy(_ sender: Any?) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = text
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // コピーをメニューに表示することを許可
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    
    
}

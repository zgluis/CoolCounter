//
//  InsetMessageView.swift
//  CoolCounter
//
//  Created by Luis Zapata on 09-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

enum InsetMessage {
    case emptyCounters
    case error
}

protocol InsetMessageDelegate: class {
    func didTapActionButton()
}

class InsetMessageView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnAction: UIButton! {
        didSet {
            btnAction.layer.cornerRadius = 8
            btnAction.titleEdgeInsets = UIEdgeInsets(top: -8, left: -16, bottom: -8, right: -16)
            btnAction.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        }
    }
    @IBOutlet var contentView: UIView!
    weak var delegate: InsetMessageDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
            Bundle.main.loadNibNamed("InsetMessageView", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }

    func setUpView(insetMessage: InsetMessage, delegate: InsetMessageDelegate) {
        self.delegate = delegate
        switch insetMessage {
        case .emptyCounters:
            self.btnAction.setTitle(UIText.messageEmptyCountersButton, for: .normal)
            self.lblTitle.text = UIText.messageEmptyCountersTitle
            self.lblSubtitle.text = UIText.messageEmptyCountersSubtitle
        case .error:
            self.btnAction.setTitle(UIText.messageErrorCountersButton, for: .normal)
            self.lblTitle.text = UIText.messageErrorCountersTitle
            self.lblSubtitle.text = UIText.messageErrorCountersSubtitle
        }
    }

    @IBAction func didTapActionButton(_ sender: Any) {
        delegate?.didTapActionButton()
    }

}

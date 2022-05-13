//
//  Checkbox.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 11/05/22.
//

import UIKit

@IBDesignable
class Checkbox: UIControl {

    private weak var checkImageView: UIImageView!
    
    private var imageState: UIImage {
        return isChecked ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "circle")!
    }
    
    public var isChecked: Bool = false {
        didSet {
            checkImageView.image = imageState
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkboxSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        checkboxSetup()
    }
    
    private func checkboxSetup(){
        let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            
            imageView.image = imageState
            imageView.contentMode = .scaleAspectFit
            
            self.checkImageView = imageView
            
            backgroundColor = UIColor.clear
            
            addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc func touchUpInside() {
      isChecked = !isChecked
      sendActions(for: .valueChanged)
    }

}

//
//  OnboardingCollectionViewCell.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 12/04/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var pageImageView: UIImageView!
    
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var pageDescription: UILabel!
    
    
    func initialize(_ page: OnboardingPage){
        pageTitle.text = page.heading
        pageDescription.text = page.description
        pageImageView.image = page.pageImage
    }
    
}

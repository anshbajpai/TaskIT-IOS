//
//  QuoteData.swift
//  TaskIT
//
//  Created by Ansh Bajpai on 25/05/22.
//

import UIKit

class QuoteData: NSObject, Decodable {
    
    var content: String
    
    private enum CodingKeys: String, CodingKey {
        case content = "content"
    }


}

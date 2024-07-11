//
//  Picture.swift
//  Milestone 10-12
//
//  Created by lz on 03/07/2024.
//

import UIKit

class Picture: NSObject, Codable {
    
    var picName: String
    var picImage: String
    
    init(picName: String, picImage: String) {
        self.picName = picName
        self.picImage = picImage
    }

}

//
//  Image.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/27/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Gloss

class Image: NSObject, Glossy {
    var url: URL?
    var width: Double?
    var height: Double?
    
    required init?(json: JSON) {
        self.url = FirebaseKey.url <~~ json
        self.width = FirebaseKey.width <~~ json
        self.height = FirebaseKey.heigh <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.url ~~> url,
            FirebaseKey.width ~~> width,
            FirebaseKey.heigh ~~> height])
    }
}

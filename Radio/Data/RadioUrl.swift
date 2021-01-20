//
//  RadioUrl.swift
//  PhonixRadio
//
//  Created by Martin Haisma on 27/07/2020.
//

import Foundation

extension RadioUrl {
    convenience init(for url:String, with title:String) {
        self.init()
        
        self.url = url
        self.title = title
        self.logo = ""
    }
}

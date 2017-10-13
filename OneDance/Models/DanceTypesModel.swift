//
//  DanceTypesModel.swift
//  OneDance
//
//  Created by Burak Can on 10/11/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation


class DanceTypesModel: DanceTypesModelType {
    private var items = [IDanceType]()
    func items(_ completionHandler: @escaping ([IDanceType]) -> Void) {
            completionHandler(self.items)
    }
    
    init(items: [IDanceType]?) {
        if let danceTypes = items {
            self.items = danceTypes
        }
    }
}

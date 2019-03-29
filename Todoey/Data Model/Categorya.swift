//
//  Categorya.swift
//  Todoey
//
//  Created by Andres Felipe De La Ossa Navarro on 3/23/19.
//  Copyright © 2019 Andres Felipe De La Ossa Navarro. All rights reserved.
//

import Foundation
import RealmSwift

class Categorya: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}

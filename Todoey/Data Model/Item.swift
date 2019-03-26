//
//  Item.swift
//  Todoey
//
//  Created by Andres Felipe De La Ossa Navarro on 3/23/19.
//  Copyright © 2019 Andres Felipe De La Ossa Navarro. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Categorya.self, property: "items")
}

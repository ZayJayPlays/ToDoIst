//
//  ToDoList.swift
//  ToDoist
//
//  Created by Zane Jones on 4/30/23.
//

import Foundation

extension ToDoList {
    var itemsArray: [Item] {
        Array(_immutableCocoaArray: item!)
    }
}

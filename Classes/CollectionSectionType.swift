//
//  CollectionSectionType.swift
//  Shoyu
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public protocol CollectionSectionType {
    var items: [ItemType] { get }
    
    var header: CollectionSectionHeaderFooterType? { get }
    var footer: CollectionSectionHeaderFooterType? { get }
    
    var itemCount: Int { get }
    func itemFor(item: Int) -> ItemType
    func itemFor(indexPath: NSIndexPath) -> ItemType
    
    func reusableViewFor(kind: String) -> CollectionSectionHeaderFooterType?
}
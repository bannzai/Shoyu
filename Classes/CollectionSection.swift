//
//  CollectionSection.swift
//  Shoyu
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public final class CollectionSection<HeaderType: UIView, FooterType: UIView>: CollectionSectionType {
    public private(set) var items: [ItemType] = []
    
    public init() { }
    
    public init(@noescape closure: (CollectionSection<HeaderType, FooterType> -> Void)) {
        closure(self)
    }
}

extension CollectionSection {
    public var itemCount: Int { return items.count }
    
    public func itemFor(item: Int) -> ItemType {
        return items[item]
    }
    
    public func itemFor(indexPath: NSIndexPath) -> ItemType {
        return itemFor(indexPath.item)
    }
}

extension CollectionSection {
    public func addItem(item: ItemType) -> Self {
        items.append(item)
        return self
    }
    
    public func addItems(items: [ItemType]) -> Self {
        self.items.appendContentsOf(items)
        return self
    }
    
    public func createItem<T>(@noescape closure: (Item<T> -> Void)) -> Self {
        return addItem(Item<T>() { closure($0) })
    }
    
    public func createItems<T, E>(elements: [E], @noescape closure: ((E, Item<T>) -> Void)) -> Self {
        return addItems(
            elements.map { element -> Item<T> in
                return Item<T>() { closure(element, $0) }
                }.map { $0 as ItemType }
        )
    }
    
    public func createItems<T>(count: UInt, @noescape closure: ((UInt, Item<T>) -> Void)) -> Self {
        return createItems([UInt](0..<count), closure: closure)
    }
}
//
//  Section.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class TableSection<HeaderType: UIView, FooterType: UIView>: TableSectionType {
    public private(set) var rows: [RowType] = []
    
    public var header: SectionHeaderFooterType?
    public var footer: SectionHeaderFooterType?
    
    public init() { }
    
    public init(@noescape closure: (TableSection<HeaderType, FooterType> -> Void)) {
        closure(self)
    }
}

extension TableSection {
    public var rowCount: Int { return rows.count }
    
    public func rowFor(row: Int) -> RowType {
        return rows[row]
    }
    
    public func rowFor(indexPath: NSIndexPath) -> RowType {
        return rowFor(indexPath.row)
    }
    
    public func removeRow(index: Int) -> RowType {
        return rows.removeAtIndex(index)
    }
    
    public func insertRow(row: RowType, index: Int) {
        rows.insert(row, atIndex: index)
    }
}

extension TableSection {
    public func addRow(row: RowType) -> Self {
        rows.append(row)
        return self
    }
    
    public func addRows(rows: [RowType]) -> Self {
        self.rows.appendContentsOf(rows)
        return self
    }
    
    public func createRow<T>(@noescape closure: (Row<T> -> Void)) -> Self {
        return addRow(Row<T>() { closure($0) })
    }
    
    public func createRows<T, E>(elements: [E], @noescape closure: ((E, Row<T>) -> Void)) -> Self {
        return addRows(
            elements.map { element -> Row<T> in
                return Row<T>() { closure(element, $0) }
                }.map { $0 as RowType }
        )
    }
    
    public func createRows<T>(count: UInt, @noescape closure: ((UInt, Row<T>) -> Void)) -> Self {
        return createRows([UInt](0..<count), closure: closure)
    }
    
    public func createHeader(@noescape closure: (SectionHeaderFooter<HeaderType> -> Void)) -> Self {
        return createHeaderFooter { (header: SectionHeaderFooter<HeaderType>) in
            self.header = header
            closure(header)
        }
    }
    
    public func createFooter(@noescape closure: (SectionHeaderFooter<FooterType> -> Void)) -> Self {
        return createHeaderFooter { (footer: SectionHeaderFooter<FooterType>) in
            self.footer = footer
            closure(footer)
        }
    }
    
    private func createHeaderFooter<T>(@noescape closure:(SectionHeaderFooter<T> -> Void)) -> Self {
        closure(SectionHeaderFooter<T>())
        return self
    }
}

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
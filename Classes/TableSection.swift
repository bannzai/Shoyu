//
//  TableSection.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class TableSection<HeaderType: UIView, FooterType: UIView>: TableSectionType {
    public private(set) var rows: [RowType] = []
    
    public var header: TableSectionHeaderFooterType?
    public var footer: TableSectionHeaderFooterType?
    
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
    
    public func createHeader(@noescape closure: (TableSectionHeaderFooter<HeaderType> -> Void)) -> Self {
        return createHeaderFooter { (header: TableSectionHeaderFooter<HeaderType>) in
            self.header = header
            closure(header)
        }
    }
    
    public func createFooter(@noescape closure: (TableSectionHeaderFooter<FooterType> -> Void)) -> Self {
        return createHeaderFooter { (footer: TableSectionHeaderFooter<FooterType>) in
            self.footer = footer
            closure(footer)
        }
    }
    
    private func createHeaderFooter<T>(@noescape closure:(TableSectionHeaderFooter<T> -> Void)) -> Self {
        closure(TableSectionHeaderFooter<T>())
        return self
    }
}


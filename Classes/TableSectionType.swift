//
//  TableSectionType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol TableSectionType {
    var rows: [RowType] { get }
    
    var header: TableSectionHeaderFooterType? { get }
    var footer: TableSectionHeaderFooterType? { get }
    
    var rowCount: Int { get }
    func rowFor(row: Int) -> RowType
    func rowFor(indexPath: NSIndexPath) -> RowType
    
    func removeRow(index: Int) -> RowType
    func insertRow(row: RowType, index: Int)
}


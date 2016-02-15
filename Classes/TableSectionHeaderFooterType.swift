//
//  TableSectionHeaderFooterType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol TableSectionHeaderFooterType {
    var reuseIdentifier: String? { get }
    var height: CGFloat? { get set }
    var title: String? { get set }
}

protocol TableSectionHeaderFooterDelegateType {
    func configureView(tableView: UITableView, view: UIView, section: Int)
    func heightFor(tableView: UITableView, section: Int) -> CGFloat?
    func titleFor(tableView: UITableView, section: Int) -> String?
    func viewFor(tableView: UITableView, section: Int) -> UIView?
}

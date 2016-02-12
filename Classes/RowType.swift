//
//  RowType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol RowType {
    var reuseIdentifier: String { get set }
    var height: CGFloat? { get }
}

protocol RowDelegateType {
    func configureCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath)
    func heightFor(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat?
    func canEdit(tableView: UITableView, indexPath: NSIndexPath) -> Bool
    func canRemove(tableView: UITableView, indexPath: NSIndexPath) -> Bool
    func canMove(tableView: UITableView, indexPath: NSIndexPath) -> Bool
    func canMoveTo(tableView: UITableView, sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath) -> Bool
    func didSelect(tableView: UITableView, indexPath: NSIndexPath)
    func didDeselect(tableView: UITableView, indexPath: NSIndexPath)
    func willDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath)
    func didEndDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath)
    func willRemove(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewRowAnimation
    func didRemove(tableView: UITableView, indexPath: NSIndexPath)
}

protocol ItemDelegateType {
    func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath)
    func sizeFor(tableView: UICollectionView, indexPath: NSIndexPath) -> CGSize?
//    func canEdit(tableView: UICollectionView, indexPath: NSIndexPath) -> Bool
//    func canRemove(tableView: UICollectionView, indexPath: NSIndexPath) -> Bool
//    func canMove(tableView: UICollectionView, indexPath: NSIndexPath) -> Bool
//    func canMoveTo(tableView: UICollectionView, sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath) -> Bool
    func didSelect(tableView: UICollectionView, indexPath: NSIndexPath)
//    func didDeselect(tableView: UICollectionView, indexPath: NSIndexPath)
//    func willDisplayCell(tableView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath)
//    func didEndDisplayCell(tableView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath)
//    func willRemove(tableView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewRowAnimation
//    func didRemove(tableView: UICollectionView, indexPath: NSIndexPath)
}

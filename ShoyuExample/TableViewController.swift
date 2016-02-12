//
//  TableViewController.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: TableView!
    
    let members = [
        Member(firstName: "N", lastName: "Takahiro"),
        Member(firstName: "H", lastName: "Naoki"),
        Member(firstName: "K", lastName: "Kotaro"),
        Member(firstName: "A", lastName: "Yuki"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.source = TableSource().createSection { (section: TableSection<HeaderTableViewCell, FooterTableViewCell>) in
            section.createHeader { header in
                header.reuseIdentifier = "Header"
                header.height = 32
                header.configureView = { headerCell, _ in
                    headerCell.contentView.backgroundColor = UIColor.blueColor()
                }
            }
            section.createFooter { footer in
                footer.createView = { [weak self] _ in
                    return self?.createViewForFooterCell()
                }
                footer.configureView = { footerCell, _ in
                    footerCell.contentView.backgroundColor = UIColor.orangeColor()
                }
                footer.titleFor = { _ -> String? in
                    return "footer"
                }
                footer.heightFor = { _ -> CGFloat? in
                    return 32
                }
            }
            section.createRows(members) { (member: Member, row: Row<DefaultTableViewCell>) in
                row.height = 52
                row.configureCell = configureMemberCell(member)
                row.didSelect = didSelectMember(member)
                
                row.canRemove = { _ -> Bool in
                    return true
                }
                row.canMove = { _ -> Bool in
                    return false
                }
                row.canMoveTo = { event -> Bool in
                    return event.sourceIndexPath.section == event.destinationIndexPath.section
                }
                row.willRemove = { _ -> UITableViewRowAnimation? in
                    return .Left
                }
                row.didRemove = { event in
                    print(event.row)
                }
            }
            section.createRows(5) { (index: UInt, row: Row<DefaultTableViewCell>) -> Void in
                row.heightFor = { _ -> CGFloat? in
                    return 44
                }
                row.configureCell = configureCountCell(index)
            }
        }
        tableView.reloadData()
        
        tableView.source?.didMoveRow = {
            print(String($0) + " " + String($1))
        }
        
        tableView.setEditing(true, animated: true)
    }
    
    private func configureMemberCell<T: DefaultTableViewCell>(member: Member) -> (T, Row<T>.RowInformation) -> Void {
        return { cell, _ in
            cell.setupWith(DefaultTableViewCellModel(name: member))
        }
    }
    
    private func didSelectMember<T>(member: Member) -> Row<T>.RowInformation -> Void {
        return { [weak self] _ in
            self?.memberSelected(member)
        }
    }
    
    private func configureCountCell<T: DefaultTableViewCell>(index: UInt) -> (T, Row<T>.RowInformation) -> Void {
        return { cell, _ in
            cell.nameLabel.text = String(index)
        }
    }
    
    private func memberSelected(member: Member) {
        print("Member selected: " + member.fullName)
    }
    
    deinit {
        print("TableViewController deinit")
    }
    
    private func createViewForFooterCell() -> FooterTableViewCell {
        let cell = FooterTableViewCell()
        let label = UILabel(frame: CGRectMake(5, 5, 0, 0))
        label.text = "Custom view footer"
        label.sizeToFit()
        cell.contentView.addSubview(label)
        return cell
    }

}

class DefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    func setupWith(viewModel: DefaultTableViewCellModel) {
        nameLabel.text = viewModel.fullName
    }
    
    deinit {
        print("DefaultTableViewCellModel deinit")
    }
}

class HeaderTableViewCell: UITableViewCell { }
class FooterTableViewCell: UITableViewCell { }

struct DefaultTableViewCellModel {
    var name: NameProtocol
    
    var fullName: String {
        return name.fullName
    }
}

class TableView: UITableView {
    
    deinit {
        print("TableView deinit")
    }
}

protocol NameProtocol {
    var firstName: String { get }
    var lastName: String { get }
    var fullName: String { get }
}

struct Member: NameProtocol {
    var firstName: String
    var lastName: String
    
    var fullName: String {
        return lastName + " " + firstName
    }
}

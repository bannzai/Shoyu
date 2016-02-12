//
//  TableSourceTests.swift
//  ShoyuTests
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest
@testable import Shoyu

class TableSourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddTableSection() {
        let source = TableSource().addSection(TableSection())
        XCTAssertEqual(source.sections.count, 1)
        
        source.addSection(TableSection())
        source.addSection(TableSection())
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        source.addSection(TableSection()).addSection(TableSection()).addSection(TableSection())
        XCTAssertEqual(source.sections.count, 6)
    }
    
    func testAddSections() {
        let source = TableSource().addSections([TableSection(), TableSection()])
        XCTAssertEqual(source.sections.count, 2)
        
        // Method chain
        source.addSections([TableSection()]).addSections([TableSection(), TableSection()])
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateTableSection() {
        let source = TableSource().createSection { _ in }
        XCTAssertEqual(source.sections.count, 1)
        
        source.createSection { _ in }
        source.createSection { _ in }
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        source.createSection { _ in }.createSection { _ in }
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateSections() {
        let source = TableSource()
        
        // Count
        let count = UInt(2)
        source.createSections(count) { _ in }
        XCTAssertEqual(source.sections.count, Int(count))
        
        // Items
        let items = [1, 2, 3]
        source.createSections(items) { _ in }
        XCTAssertEqual(source.sections.count, Int(count) + items.count)
    }
    
    func testSectionAndRowAtIndex() {
        let source = TableSource()
        
        let section1 = TableSection()
        let row1_1 = Row()
        let row1_2 = Row()
        section1.addRows([row1_1, row1_2])
        
        let section2 = TableSection()
        let row2_1 = Row()
        let row2_2 = Row()
        section2.addRows([row2_1, row2_2])
        
        source.addSections([section1, section2])
        
        XCTAssert(source.sectionFor(0) as! TableSection === section1)
        XCTAssert(source.sectionFor(1) as! TableSection === section2)
        XCTAssert(source.sectionFor(0).rowFor(0) as! Row === row1_1)
        XCTAssert(source.sectionFor(0).rowFor(1) as! Row === row1_2)
        XCTAssert(source.sectionFor(1).rowFor(0) as! Row === row2_1)
        XCTAssert(source.sectionFor(1).rowFor(1) as! Row === row2_2)
    }
    
    func testMoveRow() {
        func reuseIdentifierFrom(section: Int, row: Int) -> String {
            return String(section * 10000 + row)
        }
        func reuserIdentifierFromIndexPath(indexPath: NSIndexPath) -> String {
            return reuseIdentifierFrom(indexPath.section, row: indexPath.row)
        }
        
        let sectionCount = 10
        let rowCount = 10
        let source = TableSource { source in
            source.createSections(UInt(sectionCount)) { sectionIndex, section in
                section.createRows(UInt(rowCount)) { rowIndex, row in
                    row.reuseIdentifier = reuseIdentifierFrom(Int(sectionIndex), row: Int(rowIndex))
                }
            }
        }
        
        let sourceIndexPath = NSIndexPath(forRow: 2, inSection: 3)
        let destinationIndexPath = NSIndexPath(forRow: 4, inSection: 5)
        
        // Move
        source.moveRow(sourceIndexPath, destinationIndexPath: destinationIndexPath)
        
        // Validation
        XCTAssertNotEqual(source.sectionFor(sourceIndexPath).rowFor(sourceIndexPath).reuseIdentifier, reuserIdentifierFromIndexPath(sourceIndexPath))
        XCTAssertEqual(source.sectionFor(destinationIndexPath).rowFor(destinationIndexPath).reuseIdentifier, reuserIdentifierFromIndexPath(sourceIndexPath))
    }
    
    func testBenchmarkTableSource() {
        class HeaderView: UIView { }
        class FooterView: UIView { }
        class Cell: UITableViewCell {
            let label = UILabel()
        }
        
        let source = TableSource()
        self.measureBlock {
            source.createSections(100) { (_, section: TableSection<HeaderView, FooterView>) in
                section.createHeader { header in }
                section.createFooter { footer in }
                section.createRows(1000) { (_, row: Row<Cell>) in
                    row.configureCell = { cell, info in
                        cell.label.text = "text"
                    }
                    row.heightFor = { _ in
                        return 52
                    }
                }
            }
        }
    }
    
}

//
//  Source.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class Source: NSObject {
    internal var sections = [SectionType]()
    
    public override init() {
        super.init()
    }
    
    public convenience init(@noescape clousure: (Source -> Void)) {
        self.init()
        clousure(self)
    }
    
    public func addSection(section: SectionType) -> Self {
        sections.append(section)
        return self
    }
    
    public func addSections(sections: [SectionType]) -> Self {
        self.sections.appendContentsOf(sections)
        return self
    }
    
    public func createSection<H, F>(@noescape clousure: (Section<H, F> -> Void)) -> Self {
        return addSection(Section<H, F>() { clousure($0) })
    }
    
    public func createSections<H, F, E>(elements: [E], @noescape clousure: ((E, Section<H, F>) -> Void)) -> Self {
        return addSections(
            elements.map { element -> Section<H, F> in
                return Section<H, F>() { clousure(element, $0) }
                }.map { $0 as SectionType }
        )
    }
    
    public func createSections<H, F>(count: UInt, @noescape clousure: ((UInt, Section<H, F>) -> Void)) -> Self {
        return createSections([UInt](0..<count), clousure: clousure)
    }
    
}

public extension Source {
    public func sectionFor(section: Int) -> SectionType {
        return sections[section]
    }
    
    public func sectionFor(indexPath: NSIndexPath) -> SectionType {
        return sectionFor(indexPath.section)
    }
}

// MARK: - Table view data source

extension Source: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionFor(section).rowCount
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = sectionFor(indexPath).rowFor(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier, forIndexPath: indexPath)
        if let delegate = row as? RowDelegateType {
            delegate.configureCell(cell, indexPath: indexPath)
        }
        return cell
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sec = sectionFor(section)
        
        // Create view
        if let delegate = sec.header as? SectionHeaderFooterDelegateType,
            let view = delegate.viewFor(section) {
            delegate.configureView(view, section: section)
            return view
        }
        
        // Dequeue
        if let identifier = sec.header?.reuseIdentifier,
            let view = dequeueReusableView(tableView, identifier: identifier) {
                if let delegate = sec.header as? SectionHeaderFooterDelegateType {
                    delegate.configureView(view, section: section)
                }
                return view
        }
        return nil
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sec = sectionFor(section)
        
        // Create view
        if let delegate = sec.footer as? SectionHeaderFooterDelegateType,
            let view = delegate.viewFor(section) {
                delegate.configureView(view, section: section)
                return view
        }
        
        // Dequeue
        if let identifier = sec.footer?.reuseIdentifier,
            let view = dequeueReusableView(tableView, identifier: identifier) {
                if let delegate = sec.footer as? SectionHeaderFooterDelegateType {
                    delegate.configureView(view, section: section)
                }
                return view
        }
        return nil
    }
    
    private func dequeueReusableView(tableView: UITableView, identifier: String) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) {
            return view
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            return cell.contentView
        }
        return nil
    }
}

// MARK: - Table view delegate

extension Source: UITableViewDelegate {
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = sectionFor(indexPath).rowFor(indexPath)
        if let delegate = row as? RowDelegateType,
            let height = delegate.heightFor(indexPath) {
                return height
        }
        return tableView.rowHeight
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sec = sectionFor(section)
        if let delegate = sec.header as? SectionHeaderFooterDelegateType,
            let height = delegate.heightFor(section) {
                return height
        }
        return tableView.sectionHeaderHeight
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = sectionFor(section)
        if let delegate = sec.footer as? SectionHeaderFooterDelegateType,
            let height = delegate.heightFor(section) {
                return height
        }
        return tableView.sectionFooterHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.didSelect(indexPath)
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.didDeselect(indexPath)
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.willDisplayCell(cell, indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.didEndDisplayCell(cell, indexPath: indexPath)
    }
}


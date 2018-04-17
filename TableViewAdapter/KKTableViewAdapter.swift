//
//  KKTableViewAdapter.swift
//  TableViewTest
//
//  Created by yangyi on 2018/4/14.
//  Copyright © 2018年 yangyi. All rights reserved.
//

import UIKit

//自定义cell需实现该协议方法
@objc protocol KKListCellDelegate {
    func configCell(with data: Any, indexPath: IndexPath)
    
    @objc optional static func heightOfCell(with data: Any) -> CGFloat
    
    //可选方法，cell需要透出事件时实现该方法
    @objc optional func setCellDelegate(delegate: AnyObject?)
}

//自定义cell需继承该协议
typealias KKTableViewCell = UITableViewCell & KKListCellDelegate

class KKTableViewAdapter: NSObject {
    
    //数据的数组，按section划分
    var datas: [[Any]] = []
    
    //单一cell类型的情况
    var cellClass: KKTableViewCell.Type!
    
    //多个cell类型的情况
    var cellClassForRow: ((IndexPath) -> KKTableViewCell.Type)?
    
    var heightForSectionHeader: ((Int) -> CGFloat)?
    var heightForSectionFooter: ((Int) -> CGFloat)?
    var viewForSectionHeader: ((Int) -> UIView)?
    var viewForSectionFooter: ((Int) -> UIView)?
    
    //点击事件
    var didSelectRow: ((UITableView, IndexPath) -> Void)?
    
    override init() {
        super.init()
    }
    
    weak var parent: AnyObject?
    init(_ parent: AnyObject) {
        self.parent = parent
        super.init()
    }
    
    private var heightCaches:[IndexPath: CGFloat] = [:]
}

extension KKTableViewAdapter: UITableViewDataSource, UITableViewDelegate {
    
    func getCellTypeByIndexPath(_ indexPath: IndexPath) -> KKTableViewCell.Type? {
        var cellType: KKTableViewCell.Type?
        if cellClass != nil {
            cellType = cellClass
        } else if cellClassForRow != nil {
            cellType = cellClassForRow!(indexPath)
        }
        return cellType
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier: String = ""
        let cellType = getCellTypeByIndexPath(indexPath)
        identifier = NSStringFromClass(cellType.self!)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? KKTableViewCell
        if cell == nil {
            cell = cellType!.init(style: .default, reuseIdentifier: identifier)
        }
        let data = datas[indexPath.section][indexPath.row]
        cell!.configCell(with: data, indexPath: indexPath)
        cell!.setCellDelegate?(delegate: parent)
        return cell!
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightCaches[indexPath] {
            return height
        } else {
            let cellType = getCellTypeByIndexPath(indexPath)
            let data = datas[indexPath.section][indexPath.row]
            if let cellHeight = cellType?.heightOfCell?(with: data) {
                heightCaches[indexPath] = cellHeight
                return cellHeight
            }
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if heightForSectionHeader != nil {
            return heightForSectionHeader!(section)
        } else if viewForSectionHeader != nil {
            return tableView.sectionHeaderHeight
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if heightForSectionFooter != nil {
            return heightForSectionFooter!(section)
        } else if viewForSectionFooter != nil {
            return tableView.sectionFooterHeight
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return (viewForSectionHeader != nil) ? viewForSectionHeader!(section) : nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return (viewForSectionFooter != nil) ? viewForSectionFooter!(section) : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if didSelectRow != nil {
            didSelectRow!(tableView, indexPath)
        }
    }
}

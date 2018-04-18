//
//  ViewController.swift
//  TableViewTest
//
//  Created by yangyi on 2018/4/12.
//  Copyright © 2018年 yangyi. All rights reserved.
//

import UIKit

class MyTableViewCell1: KKTableViewCell {
    lazy var nameView: UILabel = {
        let nameLabel = UILabel(frame: CGRect(x: 50, y: 12, width: 180, height: 20))
        nameLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        return nameLabel
    } ()
    
    //MARK: KKListCellDelegate
    func configCell(with data: Any, indexPath: IndexPath) {
        nameView.text = data as? String
    }
    
    static func heightOfCell(with data: Any) -> CGFloat {
        return 66
    }
}

protocol MyTableViewCell2Delegate: AnyObject {
    func onLike(index: Int)
}

class MyTableViewCell2: KKTableViewCell {
    var index: Int = 0
    
    var nameLabel: UILabel!
    var likeButton: UIButton!
    
    weak var delegate: MyTableViewCell2Delegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel(frame: CGRect(x: 50, y: 12, width: 180, height: 20))
        nameLabel.font = .boldSystemFont(ofSize: 17)
        self.contentView.addSubview(nameLabel)
        
        likeButton = UIButton(frame: CGRect(x: 200, y: 4, width: 60, height: 36))
        likeButton.setTitle("Click", for: .normal)
        likeButton.setTitleColor(.black, for: .normal)
        likeButton.addTarget(self, action: #selector(onLikeButtonClicked), for: .touchUpInside)
        self.contentView.addSubview(likeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onLikeButtonClicked(_ sender: UIButton?) {
        delegate?.onLike(index:index)
    }

    //MARK: KKListCellDelegate
    func configCell(with data: Any, indexPath: IndexPath) {
        index = indexPath.row
        nameLabel.text = data as? String
    }
    
    func setCellDelegate(delegate: AnyObject?) {
        self.delegate = delegate as? MyTableViewCell2Delegate
    }
}

class ViewController: UIViewController, MyTableViewCell2Delegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initTableView()
    }
    
    var adapter: KKTableViewAdapter?
    
    func initTableView() {
        //最简单的情况
        adapter = KKTableViewAdapter()
        adapter?.datas = [["jack", "tom"]]
        adapter?.cellClass = MyTableViewCell1.self
        
        //有多个section或多个cell类型的情况
        adapter = KKTableViewAdapter(self)
        adapter?.datas = [["jack", "tom"],["frank","bill"]] // 数据可以稍后再设
        adapter?.cellClassForRow = { indexPath in
            if indexPath.section == 0 {
                return MyTableViewCell1.self
            } else {
                return MyTableViewCell2.self
            }
        }
        
        adapter?.didSelectRow = { tableView, indexPath in
            print("\(indexPath)")
        }
        
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.dataSource = adapter
        tableView.delegate = adapter
        self.view.addSubview(tableView)
    }
    
    //MARK: MyTableViewCell2Delegate
    func onLike(index: Int) {
        print("\(index)")
    }
}


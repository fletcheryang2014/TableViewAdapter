# TableViewAdapter
A simple wrapper for the datasource and delegate of the UITableView. It will help you make a lighter view controller. 
It supports most of common cases of the UITableView, including multi-section, multi-cell, cell height caches, delegate from cell.

## usage
```
//simple case
adapter = KKTableViewAdapter()
adapter?.datas = [["jack", "tom"]]
adapter?.cellClass = MyTableViewCell1.self        
adapter?.didSelectRow = { tableView, indexPath in
     print("\(indexPath)")
}
        
let tableView = UITableView(frame: self.view.frame, style: .plain)
tableView.dataSource = adapter
tableView.delegate = adapter
self.view.addSubview(tableView)
``` 
```
//custom case
adapter = KKTableViewAdapter(self)
adapter?.datas = [["jack", "tom"],["frank","bill"]] // 数据可以稍后再设
adapter?.cellClassForRow = { indexPath in
     if indexPath.section == 0 {
           return MyTableViewCell1.self
     } else {
           return MyTableViewCell2.self
     }
}      
```
cells need to inherit from KKTableViewCell, and implement the methods of KKListCellDelegate as needed.

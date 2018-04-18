# TableViewAdapter
A simple wrapper for the datasource and delegate of the UITableView. It will help you make a lighter view controller.

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
        dataSource = KKTableViewAdapter(self)
        dataSource?.datas = [["jack", "tom"],["frank","bill"]] // 数据可以稍后再设
        dataSource?.cellClassForRow = { indexPath in
            if indexPath.section == 0 {
                return MyTableViewCell1.self
            } else {
                return MyTableViewCell2.self
            }
        }      
```

//
//  SearchedViewController.swift
//  QiitaArticlesApp
//
//  Created by mizoz on 2021/07/21.
//

import UIKit

class SearchedViewController: UIViewController {
    var inputtedText = ""
//    private let cellId = "cellId"
//    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      UITableView
//        view.addSubview(tableView)
//        tableView.frame.size = view.frame.size
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableView.self, forCellReuseIdentifier: cellId)
        //      NavigationBar
        navigationItem.title = inputtedText
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

//extension SearchedViewController: UITableViewDelegate, UITableViewDataSource {
//    //      UITableView
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
//        cell.backgroundColor = .systemRed
//        return cell
//    }
//}

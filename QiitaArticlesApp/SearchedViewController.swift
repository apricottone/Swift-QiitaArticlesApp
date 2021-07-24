//
//  SearchedViewController.swift
//  QiitaArticlesApp
//
//  Created by mizoz on 2021/07/21.
//

import UIKit

class SearchedViewController: UIViewController {
    var inputtedText = ""
    private let cellId = "cellId"
    private var qiitas = [Qiita]()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      UITableView
        view.addSubview(tableView)
        tableView.frame.size = view.frame.size
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(QiitaTableViewCell.self, forCellReuseIdentifier: cellId)
        //      NavigationBar
        navigationItem.title = inputtedText
        //      Access API
        getQiitaAPI()
    }
    
    //      Access API (Regarding "inputtedText")
    private func getQiitaAPI() {
        //      Get JSON
        guard let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=10&query=\(inputtedText)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //      Get Contents
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("情報の取得に失敗：", error)
                return
            }
            if let data = data {
                do {
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let qiita = try JSONDecoder().decode([Qiita].self, from: data)
                    self.qiitas = qiita
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("json: ", qiita)
                } catch(let error) {
                    print("情報の取得に失敗：", error)
                }
            }
        }
        task.resume()
    }
}

extension SearchedViewController: UITableViewDelegate, UITableViewDataSource {
    //      UITableViewCell
    func tableView(_ tableView: UITableView, heightForRowAt IndexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qiitas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QiitaTableViewCell
        //        cell.backgroundColor = .systemPink
        cell.qiita = qiitas[indexPath.row]
        
        return cell
    }
}

//
//  ViewController.swift
//  QiitaArticlesApp
//
//  Created by mizoz on 2021/07/18.
//
import UIKit

//      Specifying the contents to be acquired
struct Qiita: Codable {
    let title: String
    let createdAt: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case createdAt = "created_at"
        case user = "user"
    }
}

struct User: Codable {
    let name: String
    let profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case profileImageUrl = "profile_image_url"
    }
}

class ViewController: UIViewController {
    private let cellId = "cellId"
    private var qiitas = [Qiita]()
    let tableView = UITableView()
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
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
        navigationItem.title = "Qiita"
        searchButton.tintColor = .white
        navigationController!.navigationBar.barTintColor = .systemGreen
        //      Access API
        getQiitaAPI()
    }
    
    //      Open a search popup
    @IBAction func searchPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    //      Access API
    private func getQiitaAPI() {
        //      Get JSON
        guard let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=10") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //      Get Contents
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("情報の取得に失敗", error)
                return
            }
            if let data = data {
                do {
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let qiita = try JSONDecoder().decode([Qiita].self, from: data)  //  Get specified contents
                    self.qiitas = qiita
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    //                    print("json: ", json)
                    print("json: ", qiita)
                } catch(let error) {
                    print("情報の取得に失敗", error)
                }
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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

//      Settings for what is displayed in the cell
class QiitaTableViewCell: UITableViewCell {
    
    var qiita: Qiita? {
        didSet {
            bodyTextLabel.text = qiita?.title
            let url = URL(string: qiita?.user.profileImageUrl ?? "")
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                userImageView.image = image
            }catch let err {
                print("Error : \(err.localizedDescription)")
            }
        }
    }
    //      Icon (profileIamgeUrl)
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "something in here"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(userImageView)
        addSubview(bodyTextLabel)
        [
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            
            bodyTextLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
            bodyTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ].forEach{ $0.isActive = true }
        
        userImageView.layer.cornerRadius = 50 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

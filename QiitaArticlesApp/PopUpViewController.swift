//
//  PopUpViewController.swift
//  QiitaArticlesApp
//
//  Created by mizoz on 2021/07/20.
//

import UIKit
import PKHUD

class PopUpViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var searchField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      UISearchBar
        searchField.placeholder = "キーワードを入力"
        searchField.delegate = self
        //      UIView
        PopUpView.backgroundColor = UIColor.systemGreen.withAlphaComponent(1)
        PopUpView.layer.cornerRadius = 310 / 20
        //      View
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    //      Begin editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchField.showsCancelButton = true
    }
    
    //      Tap cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchField.showsCancelButton = false
        view.endEditing(true)
    }
    
    //      Tap screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchField.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    //      Tap the search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchField.showsCancelButton = false
        
        let searchedViewController = self.storyboard?.instantiateViewController(withIdentifier: "Searched") as! SearchedViewController
        searchedViewController.inputtedText = searchField.text!
        self.navigationController?.pushViewController(searchedViewController, animated: true)
        HUD.flash(.progress, delay: 3.0)
    }
    
    //      Close a search popup
    @IBAction func closePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}

//
//  ViewController.swift
//  Assignment3
//
//  Created by Mac on 04/01/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var post : [Post] =  []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        registerXibWithTableView()
        initilizeTableView()
    }
    func registerXibWithTableView(){
        let uiNib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: "CustomTableViewCell")
    }
    func initilizeTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }


    func fetchData()
    {
        let postUrl = URL(string: "https://jsonplaceholder.typicode.com/todos")
        var postUrlRequest = URLRequest(url: postUrl!)
        postUrlRequest.httpMethod = "Get"
        let postUrlSesson = URLSession(configuration: .default)
        let dataTask = postUrlSesson.dataTask(with: postUrlRequest) { postData, postResponse, postError in
            let postUrlResponse = try! JSONSerialization.jsonObject(with: postData!)
            
            for eachResponse in postUrlResponse as! [[String : Any]]
            {
                let postDictonary = eachResponse as! [String : Any]
                let userId = postDictonary["userId"] as! Int
                let id = postDictonary["id"] as! Int
                let title = postDictonary["title"] as! String
                let completed = postDictonary["completed"] as! Bool
                
                let obejct = Post(userId: userId, id: id, title: title, completed: completed)
                self.post.append(obejct)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        dataTask.resume()
    }
}

extension ViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        customTableViewCell.userIdLabel.text = String(post[indexPath.row].userId)
        customTableViewCell.idLabel.text = String(post[indexPath.row].id)
        customTableViewCell.titleLabel.text = (post[indexPath.row].title)
        customTableViewCell.completed.text =    String(post[indexPath.row].completed)
        return customTableViewCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

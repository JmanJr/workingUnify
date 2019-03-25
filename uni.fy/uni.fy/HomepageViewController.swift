//
//  HomepageViewController.swift
//  uni.fy
//
//  Created by Saarila Kenkare on 3/13/19.
//  Copyright © 2019 Priya Patel. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomepageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var classClicked = ""
    var courseSize: Int = 0
    let db = Firestore.firestore()
    
    @IBOutlet weak var classes: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: get number of classes from user
        // Doesn't work yet
        db.collection("basicInfo").document("stat").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let size = dataDescription!["numCourses"] as! Int
                self.courseSize = size
            } else {
                print("Error: cannot get basicInfo document")
            }
        }
        
        return 10
    }
    
    //this is the function that is called onclick of a class cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        classClicked = String(indexPath.row) //TODO: get class ID from classes array and pass that instead
        self.performSegue(withIdentifier: "homeToMessagesSegueIdentifier", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "classCellIdentifier", for: indexPath) as! ClassTableViewCell
        cell.className.text = "Class Name " + String(indexPath.row); //TODO: update with real class name
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        classes.dataSource = self;
        classes.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToMessagesSegueIdentifier",
            let destination = segue.destination as? MessagesViewController {
                destination.className = classClicked
            
        }
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

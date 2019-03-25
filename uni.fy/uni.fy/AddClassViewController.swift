//
//  AddClassViewController.swift
//  uni.fy
//
//  Created by Saarila Kenkare on 3/13/19.
//  Copyright © 2019 Priya Patel. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var courseSubject: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var uniqueNumber: UITextField!
    @IBOutlet weak var instructor: UITextField!
    
    
    @IBAction func addClassClicked(_ sender: Any) {
        /*
         First part checks if all four textfields have been completed. If not, the user
            will receive an alert to complete all four fills.
         
         Second part will send the information of all four textfields back to the
            Firestore's Cloud Database. On completion, the ViewController will
            dismiss itself.
        */
        if ((courseSubject.text?.isEmpty)! || (courseNumber.text?.isEmpty)! ||
                (uniqueNumber.text?.isEmpty)! || (instructor.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "Error", message: "Incompleted information. Please complete all four fills.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            /*
            self.performSegue(withIdentifier: "addClassToMessagesSegueIdentifier", sender: self)
            */
            // Sets up textFields to be used
            let cS = courseSubject.text!
            let cN = courseNumber.text!
            let uN = uniqueNumber.text!
            let i = instructor.text!
            let cNuN = ("\(cN): \(uN)") // (Format of CourseNumber and UniqueNumber [CS439: 123456)
            
            /*
             Sets up the Collections and Documents relationship to be sent back to the Database.
                Upon sending the data back a course is successfully created and added.
             
             Afterwards, the stat (basicInfo -> stat) document will be updated.
                (Increases the course count by one)
            */
            let db = Firestore.firestore()
            let courseRef = db.collection("courses")
            courseRef.document(uN).setData([
                "courseSubject": cS,
                "courseNumber" : cN,
                "uniqueNumber" : uN,
                "instructor" : i,
                "fullInfo" : cNuN
            ]) { (error: Error?) in
                if let error = error {
                    // If there's an error, the following error will be printed
                    print(error.localizedDescription)
                } else {
                    // Otherwise, print success
                    print("Successfully created \(cNuN)!")
                }
            }
            
            // Updates the number of courses under basicInfo -> stat - > numCourses
            db.collection("basicInfo").document("stat").getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let size = dataDescription!["numCourses"] as! Int
                    let count = size + 1
                    document.reference.updateData(["numCourses": count])
                } else {
                    print("Error: cannot get basicInfo document")
                }
            }
            
            // Dismisses the ViewController to return to the HomePage
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addClassToMessagesSegueIdentifier",
            let destination = segue.destination as? MessagesViewController {
            destination.className = courseSubject.text! + courseNumber.text!
            
        }    }
    
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

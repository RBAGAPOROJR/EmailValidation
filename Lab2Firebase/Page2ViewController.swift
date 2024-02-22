//
//  Page2ViewController.swift
//  Lab2Firebase
//
//  Created by RNLD on 2023-10-19.
//

import UIKit

class Page2ViewController: UIViewController {

    @IBOutlet weak var userID    : UILabel!
    @IBOutlet weak var userEmail : UILabel!
    
    var userUID      : String?
    var userEmailAdd : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userID.text     = userUID
        userEmail.text  = userEmailAdd
    }
    
    @IBAction func btnLogOut(_ sender: UIButton) {
        
        dismiss( animated: true )
        
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

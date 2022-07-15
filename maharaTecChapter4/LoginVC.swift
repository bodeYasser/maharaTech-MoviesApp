//
//  LoginVC.swift
//  maharaTecChapter4
//
//  Created by Abdallah yasser on 08/06/2022.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButton(_ sender: UIButton) {
        
        if let  userName = userNameTF.text , let password = passwordTF.text {
            
            let verifiedLogin = verifyLogin(user: userName, password: password)
            
            if verifiedLogin {
                print("you are logging")
               let vc = storyboard?.instantiateViewController(withIdentifier: "MoviesListVC") as! ViewController
                
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                print("error in login")
                
            }
        }
        
        
    }
    func verifyLogin(user : String, password : String) -> Bool {
        
        return (user == "abdallah") && (password == "123456")
        
    }
    
    
}



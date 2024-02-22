//
//  ViewController.swift
//  Lab2Firebase
//
//  Created by RNLD on 2023-10-19.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxtField    : UITextField!
    @IBOutlet weak var passTxtField     : UITextField!
    
    @IBOutlet weak var emailMissing     : UILabel!
    @IBOutlet weak var passMissing      : UILabel!
    
    @IBOutlet weak var btnAccess        : UIButton!
    
//    var email1  = "test1@here.com"
//    var pass1   = "password1"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTxtField.becomeFirstResponder()
        emailTxtField.delegate  = self
        passTxtField.delegate   = self
        btnAccess.isEnabled     = false

    }

    @IBAction func btnAccess(_ sender: UIButton) {
    
        let email   =   emailTxtField.text ?? ""
        let pass    =   passTxtField.text ?? ""
    
        if emailValidation( email, pass: pass ) {
            
                authentication( email: email, pass: pass )
            
        } else {
                
            showAlert( message: "Invalid email address" )
            print( email )
            print( pass )
                    
        }
    }
    
    
    private func authentication( email: String, pass: String ) {
        
        let email   = emailTxtField.text ?? ""
        let pass    = passTxtField.text ?? ""
        
        Auth.auth().signIn( withEmail: email, password: pass ) { [ weak self ] authResult, error in
            
            guard let strongSelf = self else {
                
                return
                
            }
            
            if error != nil {
                
                strongSelf.passTxtField.becomeFirstResponder()
                strongSelf.passMissing.text     = "Invalid password."
                strongSelf.showAlert( message: "Password mismtach." )
                strongSelf.emailMissing.text    =   ""
                return
                
            }
            
            strongSelf.access()
            print( email )
            print( pass )

        }
   
    }
    
    
    private func segue() {
        
        performSegue( withIdentifier: "goToPage2", sender: self )
        
    }
    
    
    private func access() {
        
        let alert = UIAlertController( title: "ACCESS GRANTED", message: "Welcome to INFO6125!", preferredStyle: .alert )
            alert.addAction( UIAlertAction( title: "OK", style: .default ) { [ weak self ] _ in
                
                self?.segue()
                self?.emailTxtField.text    = ""
                self?.passTxtField.text     = ""
                self?.emailMissing.text     = ""
                self?.btnAccess.isEnabled   = false
                
            } )
        
        present( alert, animated: true, completion: nil )

    }
    
    
    private func showAlert( message: String ) {
        
        let alert = UIAlertController( title: "Access Denied", message: message, preferredStyle: .alert )
        alert.addAction( UIAlertAction( title: "OK", style: .default ) )
        present( alert, animated: true, completion: nil )
        emailMissing.text = "Invalid email address."
        
    }

    
    private func emailValidation(_ email: String, pass: String ) -> Bool {
        
        let emailRegex       = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate   = NSPredicate( format: "SELF MATCHES %@", emailRegex )
        let isEmailValid     = emailPredicate.evaluate( with: email )
        
        emailTxtField.becomeFirstResponder()

        return isEmailValid && pass == pass

   }
    
    
    // TEXT FIELD FOR MISSING THE INPUT AND DISABLING / ABLING THE BUTTON
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String ) -> Bool {
        
        let emailText       = emailTxtField.text ?? ""
        let passwordText    = passTxtField.text ?? ""

        if textField == emailTxtField {
                    
            let updatedText = ( textField.text as NSString? )?.replacingCharacters( in: range, with: string ) ?? ""
            let passText    = passTxtField.text ?? ""
            
            emailMissing.text   = updatedText.isEmpty ? "Email is missing." : ""
            btnAccess.isEnabled = !updatedText.isEmpty && !passText.isEmpty
            
        } else if textField == passTxtField {
                        
            let updatedText = ( textField.text as NSString? )?.replacingCharacters( in: range, with: string ) ?? ""
            let emailText   = emailTxtField.text ?? ""
            
            passMissing.text    = updatedText.isEmpty ? "Password is missing." : ""
            btnAccess.isEnabled = !emailText.isEmpty && !updatedText.isEmpty
            
        } else {

            btnAccess.isEnabled = !emailText.isEmpty && !passwordText.isEmpty

        }

        return true
        
    }
    
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        
        if let userID = Auth.auth().currentUser?.uid, let userEmail = Auth.auth().currentUser?.email {
            
            if let destination = segue.destination as? Page2ViewController {
                
                destination.userUID      = userID
                destination.userEmailAdd = userEmail
                
            }
        }
    }

    
    
}



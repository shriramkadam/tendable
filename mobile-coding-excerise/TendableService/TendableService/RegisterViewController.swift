//
//  RegisterViewController.swift
//  TendableService
//
//  Created by Shriram Kadam on 15/06/24.
//


import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnRegister.layer.cornerRadius = 25.0
    }
    
    @IBAction func closeUserRegistration() {
        self.dismiss(animated: true)
    }
    
    @IBAction func registerUser() {
        guard let email = txtEmail.text, txtEmail.text?.count != 0  else{
            lblMessage.isHidden = false
            lblMessage.text = "Please enter your email id"
            return
        }
        
        guard let password = txtPassword.text, txtPassword.text?.count != 0  else{
            lblMessage.isHidden = false
            lblMessage.text = "Please enter your password"
            return
        }
        
        if isValidEmail(emailID: email) == false {
            lblMessage.isHidden = false
            lblMessage.text = "Please enter a vaild email id"
        } else {
            lblMessage.text = ""
            sendPostRegisterRequest(userEmail: email, userPassword: password)
        }
    }
    
    func isValidEmail(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailText = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailText.evaluate(with: emailID)
    }
    
    func sendPostRegisterRequest(userEmail: String, userPassword: String) {
        let parameters = ["email": userEmail, "password": userPassword]
        
        guard let url = URL(string: "\(UrlManager.baseUrlApi)\("register")") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                //print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.lblMessage.isHidden = false
                        self.lblMessage.text = "User registered successfully"
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismiss(animated: true)
                    }
                }
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                //print(responseJSON)
                DispatchQueue.main.async {
                    self.lblMessage.isHidden = false
                    self.lblMessage.text = responseJSON["error"] as? String
                }
                
            }
        }
        
        task.resume()
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

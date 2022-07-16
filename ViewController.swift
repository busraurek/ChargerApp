//
//  ViewController.swift
//  ChargerApp
//
//  Created by Busra on 29.06.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _login_button: UIButton!
    
    override func viewDidLoad() {

        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "session") !=  nil)
        {
            LoginDone()
        }
        else
        {
            LoginToDo()
        }
        
    }

    @IBAction func LoginButton(_ sender: Any) {
        if(_login_button.titleLabel?.text == "Logout")
        {
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            
            LoginToDo()
            return
        }
        let email = _email.text
        let password = _password.text
        if (email == "" || password == "")
        {
            return
        }
        DoLogin(email! , password!)
    }
    func DoLogin(_ user:String, _ psw:String)
    {
    let url = URL(string: "http://ec2-18-197-100-203.eu-central-1.compute.amazonaws.com:8080/auth/login")
    let session = URLSession.shared
    
    let request = NSMutableURLRequest(url: url!)
    request.httpMethod = "POST"
    
    let paramToSend = "email=" + user + "&password=" + psw
    request.httpBody = paramToSend.data(using: String.Encoding.utf8)
    
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard let _:Data = data else
            {
                return
            }
            let json:Any?
            
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options:[])
            }
            catch
            {
                return
            }
            
            guard let server_response = json as? NSDictionary else
            {
                return
            }
             
            if let data_block = server_response["data"] as? NSDictionary
            {
                if let session_data = data_block["session"] as? String
                {
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    DispatchQueue.main.async (
                    execute:self.LoginDone
                    )
                }
            }
    
        })
        task.resume()
}
    func LoginToDo()
    {
        _email.isEnabled = true
        _email.isEnabled = true
        _login_button.setTitle("Login", for: .normal)
    }

    func LoginDone()
    {
        _email.isEnabled = false
        _email.isEnabled = false
        _login_button.setTitle("Logout", for: .normal)
    }
}

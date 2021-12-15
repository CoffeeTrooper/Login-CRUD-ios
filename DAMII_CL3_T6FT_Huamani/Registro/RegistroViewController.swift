//
//  RegistroViewController.swift
//  DAMII_CL3_T6FT_Huamani
//
//  Created by Sofia Alejandra on 11/29/21.
//  Copyright © 2021 Sofia Alejandra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistroViewController: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnRegistrarse: UIButton!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Registro de usuario"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegistrarseAction(_ sender: Any) {
        
        if let email = txtEmail.text, let password = txtPassword.text, let confirm = txtConfirmPassword.text{
            
            if(confirm == password){
                Auth.auth().createUser(withEmail: email, password: password){
                    (result, error) in
                    if let _ = result, error == nil {
                        
                    self.navigationController?.pushViewController(CrudViewController(provider: .basic), animated: true)
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando al usuario", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            }
            else{
                let alertController = UIAlertController(title: "Error", message: "La contrase;a debe ser igual a la confirmacion de esta.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        txtNombre.text?.removeAll()
        txtEmail.text?.removeAll()
        txtPassword.text?.removeAll()
        txtConfirmPassword.text?.removeAll()
        
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
        
    }
    
    
}

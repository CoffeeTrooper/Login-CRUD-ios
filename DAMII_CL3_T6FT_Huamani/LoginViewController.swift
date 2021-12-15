//
//  ViewController.swift
//  DAMII_CL3_T6FT_Huamani
//
//  Created by Sofia Alejandra on 11/29/21.
//  Copyright © 2021 Sofia Alejandra. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import TwitterKit

//CONTINUAR EN MIN 1>44>54

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var txtEmailLogin: UITextField!
    
    @IBOutlet weak var txtPasswordLogin: UITextField!
    
    @IBOutlet weak var btnIngresar: UIButton!
    
    @IBOutlet weak var btnRegistro: UIButton!
    
    @IBOutlet weak var btnAuthGoogle: UIButton!
    
    @IBOutlet weak var btnAuthFb: UIButton!
    
    @IBOutlet weak var btnAuthTwitter: UIButton!
    
    //Autenticacion GOOGLE
    
    /*
    let signInConfig = GIDConfiguration.init(clientID: "885495951492-g2f41bcl51c8e6r7qfg17j4c2r37olt4.apps.googleusercontent.com")*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Login"
        
        //Comprobar si hay user autenticado
        let defaults = UserDefaults.standard
        
        if let email = defaults.value(forKey: "email") as? String, let provider = defaults.value(forKey: "provider") as? String{
            
            self.navigationController?.pushViewController(CrudViewController(provider: ProviderType.init(rawValue: provider)!), animated: false)
            
        }
        
        
        
        //google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        //1>46>35

    }
    
    
    @IBAction func btnIngresarAction(_ sender: Any) {
        
        if let email = txtEmailLogin.text, let password = txtPasswordLogin.text{
            
            Auth.auth().signIn(withEmail: email, password: password){
                (result, error) in
                
                self.showHome(result: result, error: error, provider: .basic)
                
            }
            
        }
        
    }
    
    
    @IBAction func btnAuthGoogleAction(_ sender: Any) {
        
        //Por tema de seguridad primero cerramos sesion
        GIDSignIn.sharedInstance()?.signOut()
        
        GIDSignIn.sharedInstance()?.signIn()

    }
    
    @IBAction func btnAuthFbAction(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            switch result{
                
            case .success(let granted, let declined, let token):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                Auth.auth().signIn(with: credential) { (result, error) in
                    
                    self.showHome(result: result, error: error, provider: .facebook)
                    
                }
                
            case .cancelled:
                break
                
            case .failed(_):
                break
                
            }
        }
        
    }
    
    @IBAction func btnAuthTwitterAction(_ sender: Any) {
        
        TWTRTwitter.sharedInstance().logIn {
            (session, error) -> Void in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
        
    }
    
    @IBAction func btnRegistroAction(_ sender: Any) {
        self.navigationController?.pushViewController(RegistroViewController(), animated: true)
    }
    
    private func showHome(result: AuthDataResult?, error: Error?, provider: ProviderType){
        
        if let result = result, error == nil {
            
            self.navigationController?.pushViewController(CrudViewController(provider: .basic), animated: true)
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Se ha producido un error de autenticacion mediante \(provider.rawValue) . \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
}

extension LoginViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                
                self.showHome(result: result, error: error, provider: .google)
                
            }
            
        }
    }
    
    
}


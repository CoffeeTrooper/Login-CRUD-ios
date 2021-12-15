//
//  CrudViewController.swift
//  DAMII_CL3_T6FT_Huamani
//
//  Created by Sofia Alejandra on 11/29/21.
//  Copyright © 2021 Sofia Alejandra. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FirebaseFirestore

enum ProviderType: String{
    
    case basic
    case google
    case facebook
    
}

class CrudViewController: UIViewController {

    private let provider: ProviderType
    
    @IBOutlet weak var txtIdporducto: UITextField!
    
    @IBOutlet weak var txtNombreProd: UITextField!
    
    @IBOutlet weak var txtPrecio: UITextField!
    
    @IBOutlet weak var txtStock: UITextField!
    
    @IBOutlet weak var btnRegistrarProd: UIButton!
    
    @IBOutlet weak var btnRecuperarProd: UIButton!
    
    @IBOutlet weak var btnActualizarProd: UIButton!
    
    @IBOutlet weak var btnEliminarProd: UIButton!
    
    @IBOutlet weak var btnCerrarSesion: UIButton!
    
    
    //Contructor
    init(provider: ProviderType){
        
        self.provider = provider
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "CRUD"
        
        //guardamos de datos de usuario en user defaults
        let defaults = UserDefaults.standard
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private let db = Firestore.firestore()
    
    @IBAction func btnRegistrarProdAction(_ sender: Any) {
        
        view.endEditing(true)
        db.collection("productos").document(txtIdporducto.text!).setData([
            "nombre": txtNombreProd.text ?? "",
            "precio": txtPrecio.text ?? "",
            "stock": txtStock.text ?? ""
            ])
        
        showAlert(message: "El producto se registro correctamente.")
    }
    
    @IBAction func btnRecuperarProdAction(_ sender: Any) {
        
        view.endEditing(true)
        
        db.collection("productos").document(txtIdporducto.text!).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil{
                
                if let nombre = document.get("nombre") as? String{
                    self.txtNombreProd.text = nombre
                }
                else{
                    self.txtNombreProd.text = ""
                }
                
                if let precio = document.get("precio") as? String{
                    self.txtPrecio.text = precio
                }
                else{
                    self.txtPrecio.text = ""
                }
                
                if let stock = document.get("stock") as? String{
                    self.txtStock.text = stock
                }
                
                else{
                    self.txtStock.text = ""
                }
                
            }
            else{
                self.txtNombreProd.text = ""
                self.txtPrecio.text = ""
                self.txtStock.text = ""
            }
        }
    }
    
    @IBAction func btnActualizarProdAction(_ sender: Any) {
        
        view.endEditing(true)
        
        db.collection("productos").document(txtIdporducto.text!).updateData([
            "nombre": txtNombreProd.text ?? "",
            "precio": txtPrecio.text ?? "",
            "stock": txtStock.text ?? ""
            ])
        
        showAlert(message: "El producto se actualizo correctamente.")
    }
    
    @IBAction func btnEliminarProdAction(_ sender: Any) {
        
        view.endEditing(true)
        
        db.collection("productos").document(txtIdporducto.text!).delete { (error) in
            if let err = error{
                self.showAlert(message: "Ocurrio un error al borrar producto. \(err)")
            }
            else{
                self.showAlert(message: "El producto se elimino correctamente.")
            }
        }
    }
    
    
    @IBAction func btnCerrarsesionAction(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        switch provider{
            
        case .basic:
            firebaseLogOut()
            
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogOut()
            
        case .facebook:
            let loginManager = LoginManager()
            loginManager.logOut()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    private func firebaseLogOut(){
        
        do{
            try Auth.auth().signOut()

        }
        catch{
            
        }
        
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "CL3 DAMII", message: message, preferredStyle: .alert)
        
        //Para agregar boton OK
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //para mostrar el alert
        present(alert, animated: true, completion: nil)
    }

}

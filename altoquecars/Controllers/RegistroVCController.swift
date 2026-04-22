//
//  RegistroVCController.swift
//  altoquecars
//
//  Created by Jack Yeiden Cabanillas Correa on 19/04/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistroVCController: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.isSecureTextEntry = true
        txtConfirmPassword.isSecureTextEntry = true
    }

    @IBAction func btnRegistrarse(_ sender: UIButton) {
        let nombre = txtNombre.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let correo = txtCorreo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = txtConfirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if nombre.isEmpty || correo.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            mostrarAlerta("No deje ningún campo vacío")
            return
        }
        
        if password != confirmPassword {
            mostrarAlerta("Las contraseñas no coinciden")
            return
        }
        
        if password.count < 6 {
            mostrarAlerta("La contraseña debe tener mínimo 6 caracteres")
            return
        }
        
        Auth.auth().createUser(withEmail: correo, password: password) { result, error in
            if let error = error {
                self.mostrarAlerta("Error: \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else {
                self.mostrarAlerta("No se pudo obtener el usuario")
                return
            }
            
            self.guardarUsuario(uid: uid, nombre: nombre, correo: correo)
        }
    }
    
    func guardarUsuario(uid: String, nombre: String, correo: String) {
        db.collection("Usuario").document(uid).setData([
            "Nombre": nombre,
            "Correo": correo,
            "Rol": "Cliente"
        ]) { error in
            if let error = error {
                self.mostrarAlerta("Se creó la cuenta, pero no se guardaron los datos: \(error.localizedDescription)")
            } else {
                self.mostrarAlertaConRetorno("Usuario registrado correctamente")
            }
        }
    }
    
    @IBAction func btnIrLogin(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func mostrarAlerta(_ mensaje: String) {
        let alerta = UIAlertController(title: "Registro", message: mensaje, preferredStyle: .alert)
        let accion = UIAlertAction(title: "OK", style: .default)
        alerta.addAction(accion)
        present(alerta, animated: true)
    }
    
    func mostrarAlertaConRetorno(_ mensaje: String) {
        let alerta = UIAlertController(title: "Registro", message: mensaje, preferredStyle: .alert)
        let accion = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alerta.addAction(accion)
        present(alerta, animated: true)
    }
}

//
//  HomeVC.swift
//  altoquecars
//
//  Created by Jairo on 11/04/26.
//
// Jennifer add btnCerrar

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    var correo: String?
    
    @IBOutlet weak var lblCorreo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCorreo.text = "BIENVENIDO \(correo ?? "DESCONOCIDO")"
    }
    
    @IBAction func btnCerrarSesion(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true)
        } catch {
            let alerta = UIAlertController(
                title: "Error",
                message: "No se pudo cerrar sesión",
                preferredStyle: .alert
            )
            let accion = UIAlertAction(title: "OK", style: .default)
            alerta.addAction(accion)
            present(alerta, animated: true)
        }
    }
}

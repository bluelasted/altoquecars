//
//  HomeVC.swift
//  altoquecars
//
//  Created by Jairo on 11/04/26.
//

import UIKit

class HomeVC: UIViewController {
    var correo: String?
    
    @IBOutlet weak var lblCorreo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCorreo.text = "BIENVENIDO \(correo ?? "DESCONOCIDO")"
    }
}

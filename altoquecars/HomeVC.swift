//
//  HomeVC.swift
//  altoquecars
//
//  Created by Jairo on 11/04/26.
//
// Jennifer add btnCerrar

import UIKit
import FirebaseAuth

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var correo: String?
    var nombre: String?
    var listaAutos: [Auto] = []
    var autoSeleccionado: Auto?
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblBienvenido: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgLogo.image = UIImage(named: "logo")
        lblBienvenido.text = "BIENVENIDO \(nombre ?? "USUARIO")"

        tableView.delegate = self
        tableView.dataSource = self

        listaAutos.append(Auto(id: "1", marca: "Porsche", modelo: "911", precio: 65200, imagen: "porsche911"))
        listaAutos.append(Auto(id: "2", marca: "Toyota", modelo: "FJ Cruiser 2010", precio: 45000, imagen: "toyotafjcruiser2010"))
        listaAutos.append(Auto(id: "3", marca: "Honda", modelo: "Pilot 2026", precio: 40000, imagen: "hondapilot2026"))
        listaAutos.append(Auto(id: "4", marca: "BMW", modelo: "M4", precio: 65100, imagen: "bmwm4"))
        listaAutos.append(Auto(id: "5", marca: "Toyota", modelo: "Prado 2026", precio: 72000, imagen: "toyotaprado2026"))
        listaAutos.append(Auto(id: "6", marca: "BMW", modelo: "X6", precio: 83500, imagen: "bmwx6"))
        listaAutos.append(Auto(id: "7", marca: "Honda", modelo: "CR-V Hybrid 2026", precio: 47800, imagen: "hondacrvhybrid2026"))
        listaAutos.append(Auto(id: "8", marca: "Ferrari", modelo: "SP8", precio: 380000, imagen: "ferrarisp8"))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaAutos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "AutoCell", for: indexPath) as! AutoTableViewCell
        
        let auto = listaAutos[indexPath.row]
        celda.lblMarcaModelo.text = "\(auto.marca) \(auto.modelo)"
        celda.lblPrecio.text = "S/ \(auto.precio)"
        celda.imgAuto.image = UIImage(named: auto.imagen)
        
        celda.imgAuto.layer.cornerRadius = 8
        celda.imgAuto.clipsToBounds = true
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        autoSeleccionado = listaAutos[indexPath.row]
        performSegue(withIdentifier: "irAReserva", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irAReserva" {
            let destino = segue.destination as! ReservaVC
            destino.autoSeleccionado = autoSeleccionado
        }
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

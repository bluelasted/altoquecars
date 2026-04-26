//
//  HomeVC.swift
//  altoquecars
//
//  Created by Jairo on 11/04/26.
//
// Jennifer add btnCerrar

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var correo: String?
    var nombre: String?
    var listaAutos: [Auto] = []
    var autoSeleccionado: Auto?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblBienvenido: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgLogo.image = UIImage(named: "logo")
        lblBienvenido.text = "BIENVENIDO \(nombre ?? "USUARIO")"

        tableView.delegate = self
        tableView.dataSource = self
        
        obtenerAutos()
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

    @IBAction func btnHistorial(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let historialVC = storyboard.instantiateViewController(withIdentifier: "Historial") as? HistorialReservasVC {
            historialVC.modalPresentationStyle = .fullScreen
            self.present(historialVC, animated: true)
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
    func obtenerAutos(){
        db.collection("Autos").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.listaAutos.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    let marca = data["marca"] as! String
                    let modelo = data["modelo"] as! String
                    let precio = data["precio"] as! Double
                    let imagen = data["imagen"] as! String
                    let year = data["year"] as! Int
                    let km = data["km"] as! Int
                    let placa = data["placa"] as! String
                    
                    let auto = Auto(autoId: id, marca: marca, modelo: modelo, year: year,km: km, placa: placa, precio: precio, imagen: imagen)
                    self.listaAutos.append(auto)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

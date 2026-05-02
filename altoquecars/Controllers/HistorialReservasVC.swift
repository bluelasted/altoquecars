//
//  HistorialReservasVC.swift
//  altoquecars
//
//  Created by Jairo on 26/04/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HistorialReservasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var listaReservas: [Reserva] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listaReservas.count
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {

         

          if let navigationController = self.navigationController {

             

            for controlador in navigationController.viewControllers {

           

              if controlador is HomeVC {

                navigationController.popToViewController(controlador, animated: true)

                return

              }

            }

             

          } else {

       

            self.dismiss(animated: true, completion: nil)

          }

        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellHistorial", for: indexPath) as! HistorialTableViewCell
        let reserva = listaReservas[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        celda.lblMarcaModelo.text = "\(reserva.auto?.marca ?? "") - \(reserva.auto?.modelo ?? "")"
        celda.lblInicio.text = formatter.string(from: reserva.fechaInicio ?? Date.now)
        celda.lblFin.text = formatter.string(from: reserva.fechaFin ?? Date.now)
        celda.imgAuto.image = UIImage(named: reserva.auto?.imagen ?? "")
        return celda
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let batch = db.batch()
        if editingStyle == .delete {
            let reserva = listaReservas[indexPath.row]
            //MOSTRAR PREGUNTA DE CONFIMRACION DE BORRADO
            let alerta = UIAlertController(title: "Confirmacion de borrado", message: "Seguro deseas borrar?", preferredStyle: .alert)
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            let aceptar = UIAlertAction(title: "Aceptar", style: .destructive)
            {_ in
                //eliminar en firebase
                let reservacionRef = self.db.collection("Reservas").document(reserva.id ?? "")
                let usuarioRef = self.db.collection("Usuario").document(reserva.usuarioId ?? "")
                
                batch.deleteDocument(reservacionRef)
                batch.updateData([
                    "Reservas": FieldValue.arrayRemove([reserva.id ?? ""])
                ], forDocument: usuarioRef)
                batch.commit { error in
                    if let error = error {
                        print("Error al eliminar: \(error.localizedDescription)")
                    } else {
                        print("Reserva eliminada correctamente")
                        self.listaReservas.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            alerta.addAction(cancelar)
            alerta.addAction(aceptar)
            present(alerta, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Eliminar"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        obtenerReservasPorUsuario()
    }
    
    func obtenerReservasPorUsuario() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let usuarioRef = db.collection("Usuario").document(uid)
        
        db.collection("Reservas")
            .whereField("usuario", isEqualTo: usuarioRef)  // Busca por la referencia
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let docs = snapshot?.documents else { return }
                
                let reservas = docs.compactMap { doc -> Reserva? in
                    let data = doc.data()
                    guard let autoData = data["auto"] as? [String: Any] else { return nil }
                    
                    let auto = Auto(
                        autoId: autoData["idAuto"] as? String ?? "",
                        marca:  autoData["marca"]  as? String ?? "",
                        modelo: autoData["modelo"] as? String ?? "",
                        year:   autoData["year"]   as? Int    ?? 0,
                        km:     autoData["km"]     as? Int    ?? 0,
                        placa:  autoData["placa"]  as? String ?? "",
                        precio: autoData["precio"] as? Double ?? 0.0,
                        imagen: autoData["imagen"] as? String ?? "",
                    )
                    
                    return Reserva(
                        id:           doc.documentID,
                        usuarioId: uid,
                        auto:         auto,
                        fechaReserva: (data["fechaReserva"] as? Timestamp)?.dateValue() ?? Date(),
                        fechaInicio:  (data["fechaInicio"]  as? Timestamp)?.dateValue() ?? Date(),
                        fechaFin:     (data["fechaFin"]     as? Timestamp)?.dateValue() ?? Date()
                    )
                }
                DispatchQueue.main.async {
                    self.listaReservas = reservas
                    self.tableView.reloadData()
                }
            }
    }

}

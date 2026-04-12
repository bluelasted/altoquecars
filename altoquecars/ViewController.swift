import UIKit
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnIngresar(_ sender: UIButton){
        let correo = tfCorreo.text!
        let password = tfPassword.text!
        
        if correo.isEmpty || password.isEmpty{
            self.MostrarAlerta( "Debes ingresar tus datos de acceso")
        }else{
            Auth.auth().signIn(withEmail: correo, password: password) { (result, error) in
                if let error = error{
                    self.MostrarAlerta("ERROR : "+error.localizedDescription)
                    return
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let homeVC = storyboard.instantiateViewController(withIdentifier: "Home") as? HomeVC{
                        homeVC.correo = correo
                        homeVC.modalPresentationStyle = .fullScreen
                        self.present(homeVC, animated: true)
                    }
                }
            }
        }
    }

    func MostrarAlerta(_ mensaje:String){
        let alerta = UIAlertController(title: "Alerta login", message: mensaje, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alerta.addAction(action)
        present(alerta, animated: true)
    }
}


//
//  ViewController.swift
//  JsonConOpenLibrary
//
//  Created by Andrés Ixpec on 29/10/16.
//  Copyright © 2016 Andrés Ixpec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func actionTriggeredtxtISBN(_ sender: AnyObject) {
        
        //self.view.endEditing(true)
        txtISBN.delegate = self
        if reachability.isInternetAvailable(){
            let resultado : String = buscarISBN(ISBN: txtISBN.text!)
            //lblTitulo.text = resultado
            print("RESULTADOO: \(resultado)")
        }
        else{
            let refreshAlert = UIAlertController(title: "Error", message: "Sin conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        
    }

    @IBOutlet weak var txtISBN: UITextField!
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var lblPortada: UILabel!
    @IBOutlet weak var lblAutores: UILabel!
    var reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.txtISBN.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textView: UITextField) -> Bool {
        textView.resignFirstResponder()
        textView.delegate = self
        
        if reachability.isInternetAvailable(){
            let resultado : String = buscarISBN(ISBN: txtISBN.text!)
            lblTitulo.text = resultado;
            print(resultado)
        }
        else{
            let refreshAlert = UIAlertController(title: "Error", message: "Sin conexión a internet", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        return true
    }
    
    
    func textFieldShouldClear(textView: UITextField) -> Bool{
        lblTitulo.text = ""
        lblAutores.text = ""
        lblPortada.text = ""
        lblTitulo.text="Hola mundo"
        textView.resignFirstResponder()
        return false
    }
    
    func buscarISBN(ISBN : String)  -> String  {
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
        let nsURL = NSURL(string:urls)
        let texto : NSString? = ""
        /*let datos:NSData? = NSData(contentsOf: nsURL! as URL)
        var texto : NSString? = ""
        if let datos = datos {
  
            texto = NSString(data:datos as Data,encoding:String.Encoding.utf8.rawValue)
        }*/
        
        if let data = try? Data(contentsOf: nsURL! as URL)
        {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        
        
        if let dictionary = json as? [String: Any] {
            
            if let ISBN = dictionary["ISBN:"+ISBN] as? [String: Any] {
                
                // access nested dictionary values by key
                if let titulo = ISBN["title"] as? String {
                    lblTitulo.text = titulo;
                    print(titulo)
                }
                
                var nombresAutores = ""
                if let autores = ISBN["authors"] as? [Any] {
                    for autor in autores {
                        if let cAutor = autor as? [String: Any]{
                            if let nombreAutor = cAutor["name"] as? String {
                                nombresAutores = nombresAutores + nombreAutor + ", "
                            }
                        }
                    }
                }
                lblAutores.text = nombresAutores
                
                
                var cCovers = ""
                if let covers = ISBN["cover"] as? [String: String] {
                   
                    for (key, value) in covers {
                         cCovers = cCovers + "\(key) \(value) \r"
                    }
                    lblPortada.text = cCovers
                }
                else{
                    lblPortada.text = "No existe"
                }
            
                
                
                
            }
            
            
            
            /*for (key, value) in dictionary {
                // access all key / value pairs in dictionary
            }
            
            if let nestedDictionary = dictionary["anotherKey"] as? [String: Any] {
                // access nested dictionary values by key
            }*/
        }
        }
        else{
            let refreshAlert = UIAlertController(title: "Error", message: "Ocurrión un error al intentar acceder al servidor, intente de nuevo por favor", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        return texto as! String
        }
        
    }
    
    
    
    
    



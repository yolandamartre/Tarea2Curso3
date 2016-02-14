//
//  ViewController.swift
//  Tarea2Curso3
//
//  Created by Yolanda Martínez on 2/13/16.
//  Copyright © 2016 Yolanda Martínez. All rights reserved.
//
// https://github.com/yolandamartre/Tarea2Curso3.git
//
// Ejemplo de ISBN que existen en la pagina 	9789990084467, 9780439023528
// 978-84-376-0494-7



import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ISBN: UITextField!
    
    @IBOutlet weak var lbTitulo: UILabel!
    
    @IBOutlet weak var lbAutores: UILabel!
    
    @IBOutlet weak var imgPortada: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func llamada()
    {
        imgPortada.image = nil
        let isbn = ISBN.text!
        
        let urlStr = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        let url = NSURL(string: urlStr)
        
        do
        {
            let datos = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
            if datos.length != 2   // si regresa {} quiero que salga el mensaje
            {
                let texto = NSString(data: datos, encoding: NSUTF8StringEncoding)
                print (texto)

                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableLeaves)
                    
                    let dico1 = json as! NSDictionary
                    let dico2 = dico1["ISBN:" + isbn] as! NSDictionary
                    self.lbTitulo.text = dico2["title"] as! NSString as String
                    
                    var autores = ""
                    if dico2["authors"] != nil
                    {
                        let arre1 = dico2["authors"] as! NSArray
                        for var autor in arre1
                        {
                            let dico3 = autor as! NSDictionary
                            autores += (dico3["name"] as! NSString as String) + "\n"
                        }
                    }
                    self.lbAutores.text = autores
                    
                    if dico2["cover"] != nil
                    {
                       let dico4 = dico2["cover"] as! NSDictionary
                        
                        //let dico4 = arre2[0] as! NSDictionary
                        
                        let strurl = dico4["medium"] as! NSString as String
                        
                        let urlImg = NSURL(string: strurl)
                        
                        let imagenData = NSData(contentsOfURL: urlImg!)
                        
                        self.imgPortada.image = UIImage(data: imagenData!)
                    }

                }
                    
                catch _ {
                    
                }

            }
            else
            {
                let alerta = UIAlertController(title: "Error", message: "Ese libro no existe", preferredStyle: UIAlertControllerStyle.Alert)
                alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                presentViewController(alerta, animated: true, completion: nil)
            }
        }
        catch
        {
            print ("Error")
        }
    }

    @IBAction func botonLimpiar(sender: AnyObject) {
        ISBN.text = ""
        lbTitulo.text = ""
        lbAutores.text = ""
        imgPortada.image = nil
        
    }

    @IBAction func oprimioIr(sender: AnyObject?)
    {
        llamada()
    }
    
}


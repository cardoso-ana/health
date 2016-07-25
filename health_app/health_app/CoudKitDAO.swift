//
//  CoudKitDAO.swift
//  health_app
//
//  Created by Pedro de Sá on 19/07/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import Foundation
import CloudKit

public class CloudKitDAO {
    
    var ctUsers = [CKRecord]()
    
    var idCuidador = ""
    
    
    // Mandando o idoso pra nuvem:
    
    func send2CloudElder(usuario: Elder) {
        print("got hereeeeeeee")
        
        
        let user = CKRecord(recordType: "Elder")
        
        user["name"] = usuario.getElderName()
        user["age"] = usuario.getElderAge()
        user["phone"] = usuario.getElderPhone()
        user["street"] = usuario.getElderStreet()
        user["houseNumber"] = usuario.getElderHouseNumber()
        user["city"] = usuario.getElderCity()
        user["state"] = usuario.getElderState()
        user["careTakerId"] = usuario.getEldercareTakerId()
        
        let publicData = CKContainer.default().publicCloudDatabase
        
        publicData.save(user, completionHandler: { (record: CKRecord?, error: NSError?) in
            if error == nil {
                
                DispatchQueue.main.asynchronously(execute: { () -> Void in
                    print("IDOSO salvo com sucesso\n")
                })
            }
            else {
                print("\nHUEHUEHUEHUE\n")
                print(error?.localizedDescription)
            }
        })
    }
    
    
    
    // Mandando o cuidador pra nuvem:
    
    func send2CloudCaretaker(usuario: Caretaker) {
        print("got hereeeeeeee")
        
        let user = CKRecord(recordType: "Caretaker")
        
        user["id"] = usuario.getId()
        user["elderName"] = usuario.elderName
        user["elderAge"] = usuario.getElderAge()
        user["elderPhone"] = usuario.getElderPhone()
        
        let publicData = CKContainer.default().publicCloudDatabase
        
        publicData.save(user, completionHandler: { (record: CKRecord?, error: NSError?) in
            if error == nil {
                
                DispatchQueue.main.asynchronously(execute: { () -> Void in
                    print("CUIDADOR salvo com sucesso\n")
                })
            }
            else {
                print("\nHUEHUEHUEHUE\n")
                print(error?.localizedDescription)
            }
        })
    }
    
    // Pega o idoso da nuvem:
    
    typealias CompletionHandler = (success:Bool) -> Void
    func loadElderUser(phone: String, completionHandler: CompletionHandler) {
        
        ctUsers = [CKRecord]()
        print("\nO TELEFONE É:\(phone)")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", phone)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                self.ctUsers = users
                print("\nHow many users in cloud: \(self.ctUsers.count)\n")
                if self.ctUsers.count != 0 {
                    
                    completionHandler(success: false)
                }
                else {
                    
                    completionHandler(success: true)
                }
            }
        }
    }
    
    
    // Pega o cuidador(AAAAI QUE DELÍCIA) da nuvem:
    
    typealias CompletionHandler2 = (success:Bool) -> Void
    func loadCaretakerUser(phone: String, completionHandler: CompletionHandler2) {
        
        ctUsers = [CKRecord]()
        print("\nO TELEFONE É:\(phone)")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", phone)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        //var sucess = true
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                self.ctUsers = users
                print("\nHow many users in cloud: \(self.ctUsers.count)\n")
                if self.ctUsers.count != 0 {
                    
                    completionHandler(success: false)
                }
                else {
                    
                    completionHandler(success: true)
                }
            }
        }
    }
    
    func pareamento(phone: String, ctid: String) {
        ctUsers = [CKRecord]()
        print("O TELEFONE É: \(phone)\n")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", phone)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                self.ctUsers = users
                print("\nHow many users in cloud: \(self.ctUsers.count)\n")
                
                if self.ctUsers.count != 0 {
                    
                    let user =  users.first //CKRecord(recordType: "Elder")
                    user?["careTakerId"] = ctid
                    
                    let publicData = CKContainer.default().publicCloudDatabase
                    publicData.save(user!, completionHandler: { (record: CKRecord?, error: NSError?) in
                        if error == nil {
                            
                            DispatchQueue.main.asynchronously(execute: { () -> Void in
                                
                                print("IDOSO atualizado com sucesso\n")
                                //self.atualizaCuidadorComOsDadosDoIdoso(results: results!)
                            })
                        }
                        else {
                            print("\nHUEHUEHUEHUE\n")
                            print(error?.localizedDescription)
                        }
                    })
                }
                else {
                    print("\nIDOSO NÃO ENCONTRADO NA CLOUD\n")
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    func pegaIdCuidador(telefone: String) {
        
        ctUsers = [CKRecord]()
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", telefone)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results, error) in
            
            if error != nil {
                print("DEU MERDA MT GRANDE!!\n\n\n\n\n")
                print(error?.localizedDescription)
            } else {
                
                print("MALANDRAMENTE  \(results?.first?.value(forKey: "careTakerId"))  \nMALANDRAMENTE")
                
                if results?.first?.value(forKey: "careTakerId") != nil {
                    self.idCuidador = results?.first?.value(forKey: "careTakerId") as! String
                    
                    let dict = ["careTakerId" : self.idCuidador]
                    
                    NotificationCenter.default.post(name: "idDoCuidador" as NSNotification.Name, object: dict)
                    
                    //self.atualizaCuidadorComOsDadosDoIdoso(id: self.idCuidador, resultados: results!)
                    
                } else {
                    print("AAAAAA O idCuidador NA CLOUDDAO É NULO!!!")
                }
            }
        }
    }
    
    func atualizaCuidadorComOsDadosDoIdoso(id: String, resultados: [CKRecord]) { // resultados = velhos
        
        ctUsers = [CKRecord]()
        print("\nO TELEFONE É:\(id)")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "id == %@", id)
        let query = CKQuery(recordType: "Caretaker", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let user = results?.first {
                
                user["elderName"] = resultados.first?.value(forKey: "name") as? String
                user["elderAge"] = resultados.first?.value(forKey: "age") as? String
                user["elderPhone"] = resultados.first?.value(forKey: "phone") as? String
                
            }
        }
    }
    
    
    func pegaIdoso(id: String) {
        
        ctUsers = [CKRecord]()
        print("O ID DO CUIDADOR É: \(id)\n")
        
        var nome = ""
        var idade = ""
        var tel = ""
        var rua = ""
        var cidade = ""
        var estado = ""
        var idCuidador = ""
        var lat = ""
        var long = ""
        
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "careTakerId == %@", id)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                
                nome = (users[0].value(forKey: "name") as? String)!
                idade = (users[0].value(forKey: "age") as? String)!
                tel = (users[0].value(forKey: "phone") as? String)!
                rua = (users[0].value(forKey: "street") as? String)!
                cidade = (users[0].value(forKey: "city") as? String)!
                estado = (users[0].value(forKey: "state") as? String)!
                idCuidador = (users[0].value(forKey: "careTakerId") as? String)!
                lat = (users[0].value(forKey: "lat") as? String)!
                long = (users[0].value(forKey: "long") as? String)!
                
                let myDict = [ "name": nome, "age":idade, "phone" : tel, "street" : rua, "city" : cidade, "state" : estado, "careTakerId" : idCuidador, "lat" : lat, "long" : long]
                
                
                print("\n PRINTAANDO O NOME DO pegaIdoso: \(nome)\n")
                
                NotificationCenter.default.post(name: "véioChegando" as NSNotification.Name, object: myDict)
                
            }
        }
    }
    
    func pegaCuidador(id: String) {
        
        ctUsers = [CKRecord]()
        
        var nome = ""
        var tel = ""
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "id == %@", id)
        let query = CKQuery(recordType: "Caretaker", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                
                nome = (users[0].value(forKey: "name") as? String)!
                tel = (users[0].value(forKey: "phone") as? String)!
                
                let myDict = ["name" : nome, "tel" : tel]
                
                print("\n PRINTAANDO O NOME DO pegaCuidador: \(nome)\n")
                
                NotificationCenter.default.post(name: "cuidadorChegando" as NSNotification.Name, object: myDict)
                
                //NotificationCenter.default.post(name: "eita" as NSNotification.Name, object: myDict)
                
            }
        }
    }
    
    func enviaCoordsPraCloud(lat: String, long: String, tel: String) {
        
        ctUsers = [CKRecord]()
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", tel)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results?.first {
                
                print("MANDOU NOME: \(users["name"])")
                users["lat"] = lat
                users["long"] = long
                print("AAAAAAAAAAAAAAAAAA MANDOU AAAAAAAAAAAAAAAA")
                print("MANDOU LAT: \(lat)")
                print("MANDOU lONG: \(long)")
                
                let publicData = CKContainer.default().publicCloudDatabase
                publicData.save(users, completionHandler: { (record: CKRecord?, error: NSError?) in
                    if error == nil {
                        
                        print("IDOSO atualizado com sucesso\n")
                        //self.atualizaCuidadorComOsDadosDoIdoso(results: results!)
                        
                    }
                    else {
                        print("\nHUEHUEHUEHUE\n")
                        print(error?.localizedDescription)
                    }
                })
            }
        }
    }
    
    func idCaretaker(id: String) {
        
        ctUsers = [CKRecord]()
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "id == %@", id)
        let query = CKQuery(recordType: "Caretaker", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            if let users = results?.first {
                
                print("TEM CARETAKER JÁ CADASTRADO, O NOME É: \(users["name"])")
                
                let myDict = ["name"]
            }
        }
    }
    
    func idIdoso(id: String) {
        
        
        
    }
}

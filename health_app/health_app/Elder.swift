//
//  Elder.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import Foundation

public class Elder {
    
    static let singleton = Elder()
    
    var name = ""
    var age = ""
    var phone = ""
    var street = ""
    var houseNumber = ""
    var city = ""
    var state = ""
    var careTakerId = ""
    
    
    private init() { }
    
    
    func getElderName() -> String {
        return name
    }
    
    func setElderName(name: String) {
        self.name = name
    }
    
    
    func getElderAge() -> String {
        return age
    }
    
    func setElderAge(age: String) {
        self.age = age
    }
    
    
    func getElderPhone() -> String {
        return phone
    }
    
    func setElderPhone(phone: String) {
        self.phone = phone
    }
    
    
    func getElderStreet() -> String {
        return street
    }
    
    func setElderStreet(street: String) {
        self.street = street
    }
    
    
    func getElderHouseNumber() -> String {
        return houseNumber
    }
    
    func setElderHouseNumber(number: String) {
        self.houseNumber = number
    }
    
    
    func getElderCity() -> String {
        return city
    }
    
    func setElderCity(city: String) {
        self.city = city
    }
    
    
    func getElderState() -> String {
        return state
    }
    
    func setElderState(state: String) {
        self.state = state
    }
    
    
    func getEldercareTakerId() -> String {
        return careTakerId
    }
    
    func setEldercareTakerId(id: String) {
        self.careTakerId = id
    }
}

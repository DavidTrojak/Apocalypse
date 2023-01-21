//
//  NasaData.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import Foundation

struct NASAData: Decodable {
    
    var id: String?
    var name: String?
    var nametype: String?
    var recclass: String?
    var mass: String?
    var fall: String?
    var year: String?
    var reclon: String?
    var reclat: String?
    var geoLoc: GeoLoc?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case nametype = "nametype"
        case recclass = "recclass"
        case mass = "mass"
        case fall = "fall"
        case year = "year"
        case reclon = "reclong"
        case reclat = "reclat"
        case geoLoc = "geolocation"
    }
    
    //    {
    //        "name": "Aachen",
    //        "id": "1",
    //        "nametype": "Valid",
    //        "recclass": "L5",
    //        "mass": "21",
    //        "fall": "Fell",
    //        "year": "1880-01-01T00:00:00.000",
    //        "reclat": "50.775000",
    //        "reclong": "6.083330",
    //        "geolocation": {
    //              "latitude":"14.15083",
    //              "longitude":"-2.04167"
    //        }
    //    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try values.decodeIfPresent(String.self, forKey: .id)
            self.name = try values.decodeIfPresent(String.self, forKey: .name)
            self.nametype = try values.decodeIfPresent(String.self, forKey: .nametype)
            self.recclass = try values.decodeIfPresent(String.self, forKey: .recclass)
            self.mass = try values.decodeIfPresent(String.self, forKey: .mass)
            self.fall = try values.decodeIfPresent(String.self, forKey: .fall)
            self.year = try values.decodeIfPresent(String.self, forKey: .year)
            self.reclon = try values.decodeIfPresent(String.self, forKey: .reclon)
            self.reclat = try values.decodeIfPresent(String.self, forKey: .reclat)
            
            self.geoLoc = try values.decodeIfPresent(GeoLoc.self, forKey: .geoLoc)
        } catch {
             print(error)
        }
    }
}

struct GeoLoc: Decodable {
    
    var latitude: String?
    var longitude: String?
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    init(from decoder: Decoder) throws {
        do {
           let values = try decoder.container(keyedBy: CodingKeys.self)

           self.latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
           self.longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
            
        } catch {
           print(error)
        }
    }
}

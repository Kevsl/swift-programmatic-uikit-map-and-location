import UIKit

struct Coordinate: Codable {
    let type: String
    let coordinates: [Double]
}

struct Properties: Codable {
    let label: String
    let score: Double
    let id: String
    let type: String
    let name: String
    let postcode: String
    let citycode: String
    let x: Double
    let y: Double
    let population: Int
    let city: String
    let context: String
    let importance: Double
    let municipality: String
}

struct Feature: Codable {
    let type: String
    let geometry: Coordinate
    let properties: Properties
}

struct ApiResponse: Codable {
    let type: String
    let version: String
    let features: [Feature]
    let attribution: String
    let licence: String
    let query: String
    let filters: [String: String]
    let limit: Int
}


func fetchDataFromAPI(_ city: String,completion: @escaping (ApiResponse?) -> Void) {
    guard let url = URL(string: "https://api-adresse.data.gouv.fr/search/?q=\(city)&type=municipality") else {
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(ApiResponse.self, from: data)
            completion(apiResponse)
        } catch {
            completion(nil)
        }
    }.resume()
}


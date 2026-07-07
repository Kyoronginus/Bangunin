//
//  RouteModel.swift
//  Bangunin
//

import Foundation
import CoreLocation

enum RouteLine: String, CaseIterable {
//    case redKotaBogor = "Red Line (Jakarta Kota-Bogor)"
//    case redCitayamNambo = "Red Line (Citayam-Nambo)"
    case red = "Red Line"
    case blue = "Blue Line"
    case green = "Green Line"
    case brown = "Brown Line"
    case pink = "Pink Line"
    case debug = "Debug (Current Location)"
}

struct Station: Hashable, Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static let none = Station(name: "None", latitude: 0.0, longitude: 0.0)
}

struct RouteData {
    static var routeStations: [RouteLine: [Station]] {
    let currentLat = LocationManager.shared.userLocation?.coordinate.latitude ?? -6.200000
    let currentLon = LocationManager.shared.userLocation?.coordinate.longitude ?? 106.816666
    
    return [
        .debug: [
            Station(name: "ADA GOP 9", latitude: -6.3021, longitude: 106.6525),
            Station(name: "Cisauk debug", latitude: -6.3262, longitude: 106.6433),
            Station(name: "Los Angeles Station debug", latitude: 34.0651, longitude: -118.2353),
            
            Station(name: "Debug DEPARTURE", latitude: currentLat, longitude: currentLon),
            Station(name: "Debug DESTINATION (sama kyk DEPARTURE)", latitude: currentLat, longitude: currentLon)
        ],
        .red: [
            Station(name: "Jakarta Kota", latitude: -6.1375, longitude: 106.8146),
            Station(name: "Jayakarta", latitude: -6.1413, longitude: 106.8206),
            Station(name: "Mangga Besar", latitude: -6.1497, longitude: 106.8248),
            Station(name: "Sawah Besar", latitude: -6.1607, longitude: 106.8277),
            Station(name: "Juanda", latitude: -6.1666, longitude: 106.8281),
            Station(name: "Gondangdia", latitude: -6.1860, longitude: 106.8326),
            Station(name: "Cikini", latitude: -6.1985, longitude: 106.8407),
            Station(name: "Manggarai", latitude: -6.2098, longitude: 106.8502),
            Station(name: "Tebet", latitude: -6.2263, longitude: 106.8576),
            Station(name: "Cawang", latitude: -6.2427, longitude: 106.8587),
            Station(name: "Duren Kalibata", latitude: -6.2555, longitude: 106.8548),
            Station(name: "Tanjung Barat", latitude: -6.3051, longitude: 106.8398),
            Station(name: "Lenteng Agung", latitude: -6.3312, longitude: 106.8344),
            Station(name: "Universitas Pancasila", latitude: -6.3392, longitude: 106.8329),
            Station(name: "Universitas Indonesia", latitude: -6.3609, longitude: 106.8317),
            Station(name: "Pondok Cina", latitude: -6.3687, longitude: 106.8319),
            Station(name: "Depok Baru", latitude: -6.3905, longitude: 106.8184),
            Station(name: "Depok", latitude: -6.4045, longitude: 106.8166),
            Station(name: "Citayam", latitude: -6.4485, longitude: 106.8021),
            Station(name: "Cilebut", latitude: -6.5230, longitude: 106.7997),
            Station(name: "Bojong Gede", latitude: -6.4947, longitude: 106.7951),
            Station(name: "Bogor", latitude: -6.5946, longitude: 106.7891),
            Station(name: "Citayam", latitude: -6.4485, longitude: 106.8021),
            Station(name: "Pondok Rajeg", latitude: -6.4475, longitude: 106.8285),
            Station(name: "Cibinong", latitude: -6.4716, longitude: 106.8530),
            Station(name: "Nambo", latitude: -6.4526, longitude: 106.9113)
        ],
        .blue: [
            Station(name: "Cikarang", latitude: -6.2570, longitude: 107.1448),
            Station(name: "Metland Telaga Murni", latitude: -6.2559, longitude: 107.1121),
            Station(name: "Cibitung", latitude: -6.2625, longitude: 107.0850),
            Station(name: "Tambun", latitude: -6.2608, longitude: 107.0543),
            Station(name: "Bekasi Timur", latitude: -6.2415, longitude: 107.0208),
            Station(name: "Bekasi", latitude: -6.2361, longitude: 106.9995),
            Station(name: "Kranji", latitude: -6.2238, longitude: 106.9749),
            Station(name: "Cakung", latitude: -6.2152, longitude: 106.9507),
            Station(name: "Klender Baru", latitude: -6.2163, longitude: 106.9363),
            Station(name: "Buaran", latitude: -6.2147, longitude: 106.9213),
            Station(name: "Klender", latitude: -6.2114, longitude: 106.8997),
            Station(name: "Jatinegara", latitude: -6.2147, longitude: 106.8687),
            Station(name: "Matraman", latitude: -6.2104, longitude: 106.8584),
            Station(name: "Manggarai", latitude: -6.2098, longitude: 106.8502),
            Station(name: "Sudirman", latitude: -6.2023, longitude: 106.8228),
            Station(name: "Karet", latitude: -6.2016, longitude: 106.8166),
            Station(name: "Tanah Abang", latitude: -6.1856, longitude: 106.8109),
            Station(name: "Duri", latitude: -6.1554, longitude: 106.8016),
            Station(name: "Angke", latitude: -6.1437, longitude: 106.7975),
            Station(name: "Kampung Bandan", latitude: -6.1326, longitude: 106.8276),
            Station(name: "Rajawali", latitude: -6.1455, longitude: 106.8378),
            Station(name: "Kemayoran", latitude: -6.1619, longitude: 106.8385),
            Station(name: "Pasar Senen", latitude: -6.1748, longitude: 106.8441),
            Station(name: "Gang Sentiong", latitude: -6.1852, longitude: 106.8491),
            Station(name: "Kramat", latitude: -6.1942, longitude: 106.8530),
            Station(name: "Pondok Jati", latitude: -6.2045, longitude: 106.8615)
        ],
        .green: [
            Station(name: "Debug GREENLINE", latitude: currentLat, longitude: currentLon),
            Station(name: "Tanah Abang", latitude: -6.1856, longitude: 106.8109),
            Station(name: "Palmerah", latitude: -6.2074, longitude: 106.7969),
            Station(name: "Kebayoran", latitude: -6.2396, longitude: 106.7816),
            Station(name: "Pondok Ranji", latitude: -6.2797, longitude: 106.7454),
            Station(name: "Jurang Mangu", latitude: -6.2891, longitude: 106.7303),
            Station(name: "Sudimara", latitude: -6.3023, longitude: 106.7118),
            Station(name: "Rawa Buntu", latitude: -6.3150, longitude: 106.6853),
            Station(name: "Serpong", latitude: -6.3195, longitude: 106.6669),
            Station(name: "Cisauk", latitude: -6.3262, longitude: 106.6433),
            Station(name: "Cicayur", latitude: -6.3292, longitude: 106.6212),
            Station(name: "Parung Panjang", latitude: -6.3458, longitude: 106.5670),
            Station(name: "Cilejit", latitude: -6.3475, longitude: 106.5165),
            Station(name: "Daru", latitude: -6.3438, longitude: 106.4950),
            Station(name: "Tenjo", latitude: -6.3411, longitude: 106.4674),
            Station(name: "Tigaraksa", latitude: -6.3351, longitude: 106.4357),
            Station(name: "Cikoya", latitude: -6.3426, longitude: 106.4172),
            Station(name: "Maja", latitude: -6.3415, longitude: 106.3986),
            Station(name: "Citeras", latitude: -6.3400, longitude: 106.3265),
            Station(name: "Rangkasbitung", latitude: -6.3541, longitude: 106.2483)
        ],
        .brown: [
            Station(name: "Tangerang", latitude: -6.1751, longitude: 106.6335),
            Station(name: "Tanah Tinggi", latitude: -6.1738, longitude: 106.6475),
            Station(name: "Batu Ceper", latitude: -6.1663, longitude: 106.6616),
            Station(name: "Poris", latitude: -6.1633, longitude: 106.6713),
            Station(name: "Kalideres", latitude: -6.1557, longitude: 106.7027),
            Station(name: "Rawa Buaya", latitude: -6.1583, longitude: 106.7268),
            Station(name: "Bojong Indah", latitude: -6.1601, longitude: 106.7371),
            Station(name: "Taman Kota", latitude: -6.1606, longitude: 106.7561),
            Station(name: "Pesing", latitude: -6.1611, longitude: 106.7725),
            Station(name: "Grogol", latitude: -6.1617, longitude: 106.7865),
            Station(name: "Duri", latitude: -6.1554, longitude: 106.8016)
        ],
        .pink: [
            Station(name: "Jakarta Kota", latitude: -6.1375, longitude: 106.8146),
            Station(name: "Kampung Bandan", latitude: -6.1326, longitude: 106.8276),
            Station(name: "Ancol", latitude: -6.1264, longitude: 106.8407),
            Station(name: "Tanjung Priok", latitude: -6.1098, longitude: 106.8833)
        ]
    ]
}
}

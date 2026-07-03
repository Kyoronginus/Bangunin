//
//  RouteModel.swift
//  Bangunin
//

import Foundation

enum RouteLine: String, CaseIterable {
    case redKotaBogor = "Red Line (Jakarta Kota-Bogor)"
    case redCitayamNambo = "Red Line (Citayam-Nambo)"
    case blue = "Blue Line"
    case green = "Green Line"
    case brown = "Brown Line"
    case pink = "Pink Line"
}

let routeStations: [RouteLine: [String]] = [
    .redKotaBogor: ["Jakarta Kota", "Jayakarta", "Mangga Besar", "Sawah Besar", "Juanda", "Gondangdia", "Cikini", "Manggarai", "Tebet", "Cawang", "Duren Kalibata", "Tanjung Barat", "Lenteng Agung", "Universitas Pancasila", "Universitas Indonesia", "Pondok Cina", "Depok Baru", "Depok", "Citayam", "Cilebut", "Bojong Gede", "Bogor"],
    .redCitayamNambo: ["Citayam", "Pondok Rajeg", "Cibinong", "Nambo"],
    .blue: ["Cikarang", "Metland Telaga Murni", "Cibitung", "Tambun", "Bekasi Timur", "Bekasi", "Kranji", "Cakung", "Klender Baru", "Buaran", "Klender", "Jatinegara", "Matraman", "Manggarai", "Sudirman", "Karet", "Tanah Abang", "Duri", "Angke", "Kampung Bandan", "Rajawali", "Kemayoran", "Pasar Senen", "Gang Sentiong", "Kramat", "Pondok Jati"],
    .green: ["Tanah Abang", "Palmerah", "Kebayoran", "Pondok Ranji", "Jurang Mangu", "Sudimara", "Rawa Buntu", "Serpong", "Cisauk", "Cicayur", "Jatake", "Parung Panjang", "Cilejit", "Daru", "Tenjo", "Tigaraksa", "Cikoya", "Maja", "Citeras", "Rangkasbitung"],
    .brown: ["Tangerang", "Tanah Tinggi", "Batu Ceper", "Poris", "Kalideres", "Rawa Buaya", "Bojong Indah", "Taman Kota", "Pesing", "Grogol", "Duri"],
    .pink: ["Jakarta Kota", "Kampung Bandan", "Ancol", "Tanjung Priok"]
]

//
//  MapCell.swift
//  Weather-Group3
//
//  Created by SR on 2023/10/02.
//

import CoreLocation
import MapKit
import UIKit

class MapCell: UICollectionViewCell {
    let identifier = "mapCell"
    let mapView = MKMapView()

    let manager = CLLocationManager()

    var currentLatitude: Double = 37.5729
    var currentLongitude: Double = 126.9794

    var temperature: Int = 0

    var pinTintColor: UIColor = .systemBackground
    var annotationText: String = "24℃"
    var systemImageName: String = "thermometer.low"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        getCurrentLocation()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapCell {
    private func setup() {
        mapView.delegate = self
        mapView.mapType = .hybrid

        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension MapCell: CLLocationManagerDelegate {
    private func getCurrentLocation() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func showLocation(latitude: Double, longitude: Double, pinTintColor: UIColor, annotationText: String, systemImageName: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        setCustomPin(pinTintColor: pinTintColor, annotationText: annotationText, systemImageName: systemImageName)
    }

    func setCustomPin(pinTintColor: UIColor, annotationText: String, systemImageName: String) {
        
        mapView.removeAnnotations(mapView.annotations)
        let customPin = CustomAnnotation(pinTintColor: pinTintColor,
                                         annotationText: annotationText,
                                         systemImageName: systemImageName)

        customPin.coordinate = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        mapView.addAnnotation(customPin)
    }

    func getWeatherInfo(currentLatitude: Double, currentLongitude: Double) {
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
        let apiKey = WeatherAPIService().apiKey
        let urlString = "\(baseURL)?lat=\(currentLatitude)&lon=\(currentLongitude)&appid=\(apiKey)"

        WeatherAPIService().getLocalWeather(url: urlString) { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    if let firstWeather = weatherResponse.list.first {
                        let tempChange = Int(firstWeather.main.temp - 273.15)
                        self.temperature = tempChange
                        self.annotationText = "\(self.temperature)℃"

                        self.showLocation(latitude: currentLatitude, longitude: currentLongitude, pinTintColor: self.pinTintColor, annotationText: self.annotationText, systemImageName: self.systemImageName)
                    }
                    print("#mapcell: \(weatherResponse.list)")
                }
            case .failure:
                print("실패: error")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            manager.stopUpdatingLocation()
            DispatchQueue.global(qos: .background).async {
                self.getWeatherInfo(currentLatitude: self.currentLatitude, currentLongitude: self.currentLongitude)
            }
        }
    }
}

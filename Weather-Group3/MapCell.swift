//
//  MapCell.swift
//  Weather-Group3
//
//  Created by SR on 2023/10/02.
//

import MapKit
import UIKit

class MapCell: UICollectionViewCell {
    let identifier = "mapCell"
    let mapView = MKMapView()

    var pinTintColor: UIColor = .systemBackground
    var temperature: Double = 0.0
    var annotationText: String = "24℃"
    var systemImageName: String = "thermometer.low"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        mapView.delegate = self
        addAnnotation(pinTintColor: pinTintColor, annotationText: annotationText, systemImageName: systemImageName)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapCell {
    private func setup() {
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

    private func addAnnotation(pinTintColor: UIColor, annotationText: String, systemImageName: String) {
        let seoulCoordinate = CLLocationCoordinate2D(latitude: 37.5729, longitude: 126.9794)
//        if weatherResponse.list.count > 3 {
//            let noonWeather = weatherResponse.list[3]
//            let temperature = noonWeather.main.temp
//            let pressure = noonWeather.main.pressure
//            let humidity = noonWeather.main.humidity
//
//            print("온도: \(temperature)°C")
//            print("기압: \(pressure) hPa")
//            print("습도: \(humidity)%")
//        } else {
//            print("낮 12시 데이터를 찾을 수 없습니다.")
//        }
        
        let temperatureAnnotationText = "\(temperature)℃"
        let annotation = CustomAnnotation(
            pinTintColor: .systemBackground,
            annotationText: temperatureAnnotationText,
            systemImageName: "thermometer.low"
        )
        annotation.coordinate = seoulCoordinate
        mapView.addAnnotation(annotation)

        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: seoulCoordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
}


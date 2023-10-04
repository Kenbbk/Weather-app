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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addAnnotation()
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

    private func addAnnotation() {
        let seoulCoordinate = CLLocationCoordinate2D(latitude: 37.5729, longitude: 126.9794)
        let annotation = CustomAnnotation(
            pinTintColor: .systemBackground,
            annotationText: "11mm",
            systemImageName: "cloud.sun"
        )
        annotation.coordinate = seoulCoordinate
        mapView.addAnnotation(annotation)

        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: seoulCoordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
}

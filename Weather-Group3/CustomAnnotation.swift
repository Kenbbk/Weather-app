//
//  CustomAnnotation.swift
//  Weather-Group3
//
//  Created by SR on 2023/10/02.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var pinTintColor: UIColor?
    var annotationText: String?
    var systemImageName: String?

    init(pinTintColor: UIColor?, annotationText: String?, systemImageName: String?) {
        super.init()
        self.pinTintColor = pinTintColor
        self.annotationText = annotationText
        self.systemImageName = systemImageName
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else {
            return nil
        }

        let reuseIdentifier = "CustomPin"
            
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = customAnnotation
        }

        annotationView?.image = UIImage(systemName: "circle.fill")?.withTintColor(customAnnotation.pinTintColor ?? .blue)
        annotationView?.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
           
        let finalImage = imageWithTextAndSystemImage(annotationView?.image, text: customAnnotation.annotationText ?? "11mm", systemImageName: customAnnotation.systemImageName ?? "cloud.sun")
              
        annotationView?.image = finalImage
        return annotationView
    }
    
    func imageWithTextAndSystemImage(_ baseImage: UIImage?, text: String, systemImageName: String) -> UIImage? {
        guard let baseImage = baseImage else {
            return nil
        }
        let imageSize = CGSize(width: 48, height: 48)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        pinTintColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: imageSize))
        
        let textFont = UIFont.systemFont(ofSize: 12)
        let textColor = UIColor.label
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
        ]
        
        let textSize = text.size(withAttributes: textAttributes)
        let textRect = CGRect(
            x: (imageSize.width - textSize.width) / 2,
            y: imageSize.height - textSize.height - 4,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: textAttributes)
        
        let systemImage = UIImage(systemName: systemImageName)?.withTintColor(.label)
        let systemImageSize = CGSize(width: 16, height: 16)
        let systemImageRect = CGRect(
            x: (imageSize.width - systemImageSize.width) / 2,
            y: textRect.origin.y - systemImageSize.height - 4,
            width: systemImageSize.width,
            height: systemImageSize.height
        )
        
        systemImage?.draw(in: systemImageRect)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}

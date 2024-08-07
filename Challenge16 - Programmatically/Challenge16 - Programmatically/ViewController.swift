import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBar()
        createPins()
    }
    
    func createPins() {
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    func setupView() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNavigationBar() {
        title = "Capitals"
        
        let mapTypeButton = UIButton(type: .system)
        mapTypeButton.setTitle("Map Type", for: .normal)
        mapTypeButton.setTitleColor(.black, for: .normal)
        mapTypeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        mapTypeButton.addTarget(self, action: #selector(changeMapType), for: .touchUpInside)
        
        let mapTypeBarButtonItem = UIBarButtonItem(customView: mapTypeButton)
        navigationItem.rightBarButtonItem = mapTypeBarButtonItem
    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Choose map type", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = .standard
        })
        
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satellite
        })
        
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybrid
        })
        
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satelliteFlyover
        })
        
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybridFlyover
        })
        
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = .mutedStandard
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = .systemBlue
        annotationView?.tintColor = .systemBlue
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let wvc = WebViewController()
        wvc.urlString = capital.info
        navigationController?.pushViewController(wvc, animated: true)
    }
}

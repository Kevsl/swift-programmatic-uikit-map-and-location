import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
    
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupCL()
    }
}


extension ViewController: MKMapViewDelegate{
    func setupMap(){
        
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        
        addAnnotation("Strasbourg", "info", 48.5870262, 7.7530259)
        
        addAnnotation("Paris", "Panthéon", 48.866667, 2.333333)
    
    }
    
    
    func addAnnotation(_ title:String, _ subtitle:String,_ latitude: CLLocationDegrees,_ longitude:CLLocationDegrees){
    
        
        let annotation = MKPointAnnotation()
        
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        mapView.addAnnotation(annotation)

    }
    
}
extension ViewController: CLLocationManagerDelegate {
    
    func setupCL(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        guard let location = locations.last else{
            return
        }
        
        print(location.coordinate.latitude, location.coordinate.longitude)

    }
    
    
    
    
    
}

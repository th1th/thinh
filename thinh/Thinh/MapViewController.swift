//
//  MapViewController.swift
//  Thinh
//
//  Created by Linh Le on 4/8/17.

//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    
    var allUsers: [User]! = []
    var camera:GMSCameraPosition!
    var mapView:GMSMapView!
    var mockPosition:CLLocationCoordinate2D!

    
    
    @IBOutlet weak var tempAvatar: UIImageView!

    
    
    
    @IBAction func onClickCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            //
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mockPosition = CLLocationCoordinate2D(latitude: 37.785834000000001, longitude: -122.406417)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        camera = GMSCameraPosition.camera(withLatitude: 37.785834000000001, longitude: -122.406417, zoom: 8.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 37.785834000000001, longitude: -122.406417)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        getStrangerList()
    }

}
extension MapViewController{
    func getStrangerList() {
        Api.shared().getMyStrangerList().subscribe(onNext: { (user) in
            self.allUsers.append(user)
            self.addUserToMap(user)
            utilities.log("getUserFromServer--  get \(self.allUsers.count) users")
        }, onError: { (error) in
            utilities.log("getUserFromServer--\(error.localizedDescription)")
        }, onCompleted: nil, onDisposed: nil)
    }
    func addUserToMap(_ user:User) {
        if user.name != "Donald Trump" {
            return
        }
        // Creates a marker in the the map.
        let position = CLLocationCoordinate2D(latitude: mockPosition.latitude, longitude: mockPosition.longitude)
        let marker = GMSMarker(position: position)
        
        marker.isFlat = true
        marker.title = user.name
        
        marker.downloadedFrom(link: user.avatar!)
        marker.tracksViewChanges = true

        marker.map = mapView
        marker.appearAnimation = GMSMarkerAnimation.pop
    }
    
}

extension GMSMarker {
    func downloadedFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                let tempImage = self.resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
                
                let imageView = UIImageView(image: tempImage)
                imageView.layer.cornerRadius = (imageView.frame.height)/2 //set corner for image
                imageView.clipsToBounds = true
//                imageView.frame.size = CGSize(width: 20, height: 20)
//                imageView.contentMode = .scaleAspectFill
                
                self.iconView = imageView
//
//                self.iconView = imageView
            }
            }.resume()
    }
    func downloadedFrom(link: String) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
//extension UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { () -> Void in
//                self.image = image
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode)
//    }


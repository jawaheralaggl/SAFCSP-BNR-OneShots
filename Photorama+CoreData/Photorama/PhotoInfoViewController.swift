// 
//  Copyright © 2019 Big Nerd Ranch
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var numberOfViews: UILabel! // Silver Challenge
    
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Silver Challenge: Photo View Count
        store.fetchImage(for: photo) { (result) in
            switch result {
            case let .success(image):
                self.imageView.image = image
                self.photo.numberOfViews += 1
                
                if self.photo.numberOfViews == Int16(1) {
                    self.numberOfViews.text = "\(self.photo.numberOfViews) View"
                } else {
                    self.numberOfViews.text = "\(self.photo.numberOfViews) Views"
                }
                
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
            
            if case .success = result {
                do {
                    try self.store.persistentContainer.viewContext.save()
                } catch {
                    print("Cannot save changes: \(error)")
                }
            }
            
        }
    }
    
}

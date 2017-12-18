
import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var detailDescriptionLabel: UILabel!

  
  var vehicleDetail: Vehicle? {
    didSet {
      configureView()
    }
  }
  
  func configureView() {
    if let vehicleDetail = vehicleDetail {
      if let detailDescriptionLabel = detailDescriptionLabel {
        detailDescriptionLabel.text = vehicleDetail.make
      
        title = vehicleDetail.color
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}


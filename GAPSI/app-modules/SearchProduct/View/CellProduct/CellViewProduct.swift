//
//  CellViewProduct.swift
//  GAPSI
//
//  Created by Cesar Miguel Chavez on 15/03/21.
//

import UIKit
import SDWebImage

class CellViewProduct: UITableViewCell {
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelSKU: UILabel!
    @IBOutlet weak var containerRating: UIView!
    
    
    @IBOutlet weak var labelRating: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Init CounterCell")
    }

    public func configure(product: Product){
        
        labelTitle.text = product.title
        labelPrice.text = cleanMXN(product.price)
        labelSKU.text = String(format: "SKU: %@", product.id!)
        if product.rating != nil {
            labelRating.text = String(format: "%.2f", product.rating!)
        }else{
            containerRating.isHidden = true
        }
        
        imageThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageThumbnail.sd_setImage(
            with: URL(string: product.image!),
            placeholderImage: UIImage(named: ""),
            options: SDWebImageOptions(rawValue: 0),
            completed: { image, error, cacheType, imageURL in
                
                if (error != nil) {
                    // Failed to load image
                    self.imageThumbnail.image = UIImage(named: "")
                } else {
                    // Successful in loading image
                    self.imageThumbnail.image = image
                }
            }
        )
    }
    
    func cleanMXN(_ value: Double?) -> String {
        guard value != nil else { return "$0.00" }
        let doubleValue = value
        let formatter = NumberFormatter()
        formatter.currencyCode = "MXN"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = floor(doubleValue!) == doubleValue ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: doubleValue!)) ?? "$\(doubleValue)"
    }

}


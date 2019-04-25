//
//  CodesHistoryTableViewCell.swift
//  QRCodeReader
//
//  Created by Jakub Iwaszek on 25/04/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class CodesHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var codeMetadataLabel: UILabel!
    @IBOutlet weak var codeDateLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    
    var model: ScannedCode! {
        didSet {
            customize(scannedCode: model)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize(scannedCode: ScannedCode) {
        codeMetadataLabel.text = scannedCode.metadata
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: scannedCode.date)
        let myDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let myDateStringFinal = formatter.string(from: myDate!)
        codeDateLabel.text = myDateStringFinal
    }

}

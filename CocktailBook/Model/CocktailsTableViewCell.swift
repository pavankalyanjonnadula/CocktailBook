//
//  CocktailsTableViewCell.swift
//  CocktailBook
//
//  Created by Jonnadula Pavan Kalyan  on 04/04/24.
//

import UIKit

class CocktailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cocktailDescrption: UILabel!
    @IBOutlet weak var cocktailTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

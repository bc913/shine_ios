//
//  EventTableCell.swift
//  OneDance
//
//  Created by Burak Can on 3/19/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {
    
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var danceTypesLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    
    
    public func configure(item: EventLite){
        
        self.setEventName(text: item.title)
        self.setType(text: item.eventType.map { $0.rawValue } ?? "" )
        self.setLocationName(text: item.location.name ?? "")
        self.setDate(date: item.startDate)
        //self.setDate(text: item.startDate)
        
    }
    
    public func setEventImage(_ image: UIImage){
        self.eventImageView.image = image
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Name
        self.eventNameLabel.numberOfLines = 2
        self.eventNameLabel.lineBreakMode = .byTruncatingTail
        setEventName(text: "")
        
        // Type
        self.eventTypeLabel.numberOfLines = 1
        setType(text: "")
        
        // Location
        self.locationNameLabel.numberOfLines = 1
        setLocationName(text: "")
        
        // Date
        self.dateLabel.numberOfLines = 2
        self.dateFormatter.dateFormat = "MMM d"
        self.danceTypesLabel.attributedText = NSAttributedString(string: "")
        
        // Attendance
        self.attendanceLabel.numberOfLines = 1
        self.attendanceLabel.text = ""
        
        // Dance types
        self.danceTypesLabel.numberOfLines = 1
        self.danceTypesLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib : UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var cellHeight : CGFloat {
        return 128.0
    }
    
    
    // Setters
    
    private func setEventName(text: String){
        self.eventNameLabel.text = text
    }
    
    private func setType(text: String){
        let attrText = NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)])
        
        self.locationNameLabel.attributedText = attrText
    }
    
    private func setLocationName(text: String){
        let attrText = NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)])
        
        self.locationNameLabel.attributedText = attrText
    }
    
    private func setDate(date: Date){
        
        let attrText = NSAttributedString(string: self.dateFormatter.string(from: date), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        
        self.dateLabel.attributedText = attrText
    }
    
    private func setDanceTypesLabel(dances: DanceType){
        
    }
    
    private func setAttendanceLabel(att: AttendeesQuantity){
        
    }
    
    
    
    
}

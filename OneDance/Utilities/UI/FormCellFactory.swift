//
//  FormCellFactory.swift
//  OneDance
//
//  Created by Burak Can on 11/12/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import UIKit

protocol FormCell {
    var designatedHeight : CGFloat { get }
}

extension UITableViewCell : FormCell{
    var designatedHeight: CGFloat {
        return 44.0
    }
}

enum FormCellType{
    case nameTitle
    case nameTitleWithImage
    
    case info
    
    case email
    case url
    case phoneNumber
    
    case location
    
    case date
    case dateRange
    case datePicker
    
    case picker
    case switchType
    case defaultType
}

enum FormPurpose {
    
    case createDanceEvent
    case createDanceOrganization
}


enum FormType : String {
    case classEvent
    case nightEvent
    case partyEvent
    case festivalEvent
    
    case organizationProfile
    case danceAcademyProfile
}

enum FormItemType {
    enum Input {
        case Switch
        case Date
        case Picker
        case ActionSheet
        case ShortText // Textfield
        case LongText // TExt view
        case Check
        
    }
    
}



protocol FormItem {
    var type : FormItemType.Input { get }
    var title : String { get }
    var rowsCount : Int { get }
    
}

struct FormItemCellFactory {
    
    static func create(tableView: UITableView, purpose: FormPurpose, type: FormCellType, placeHolder: String?) -> BaseFormCell?{
        
        var nibName : UINib?
        var identifier : String?
        
        
        switch type {
        case .nameTitle:
            nibName = NameTitleFormCell.nib
            identifier = NameTitleFormCell.identifier
            
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? NameTitleFormCell {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                return cell
            }
        case .nameTitleWithImage:
            
            nibName = NameTitleWithImageCell.nib
            identifier = NameTitleWithImageCell.identifier
            
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? NameTitleWithImageCell {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                return cell
            }
            
        case .switchType:
            nibName = SwitchFormCell.nib
            identifier = SwitchFormCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? SwitchFormCell {
                cell.placeHolder = placeHolder
                return cell
            }
            
        case .location:
            nibName = LocationFormCell.nib
            identifier = LocationFormCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? LocationFormCell {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                return cell
            }
            
        case .date:
            nibName = DateFormCell.nib
            identifier = DateFormCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? DateFormCell {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                return cell
            }
            
        case .datePicker:
            nibName = ShineDatePickerCell.nib
            identifier = ShineDatePickerCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            let cell = ShineDatePickerCell(style: .default, reuseIdentifier: ShineDatePickerCell.identifier)
            cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            return cell
            
        case .picker:
            nibName = nil
            identifier = PickerFormCell.identifier
            tableView.register(PickerFormCell.self, forCellReuseIdentifier: identifier!)
            let cell = PickerFormCell(style: .default, reuseIdentifier: identifier)
            cell.placeHolder = placeHolder
            return cell            
            
        case .info:
            nibName = TextViewFormCell.nib
            identifier = TextViewFormCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? TextViewFormCell {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                return cell
            }
            
        case .email, .phoneNumber:
            nibName = TextFieldFormCell.nib
            identifier = TextFieldFormCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? TextFieldFormCell {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                return cell
            }
            
        case .url:
            nibName = TextFieldFormCell.nib
            identifier = TextFieldFormCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? TextFieldFormCell {
                if placeHolder == nil {
                    cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                } else {
                    cell.placeHolder = placeHolder
                }
                
                return cell
            }
            
        default:
            nibName = TextFieldCell.nib
            identifier = TextFieldCell.identifier
            
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier!) as? TextFieldCell {
                return cell
            }
        }
        
        return nil
        
    }
    
    private struct Helper {
        static func createPlaceHolderText(purpose: FormPurpose, type: FormCellType) -> String {
            var placeHolder : String = ""
            
            switch type {
            case .nameTitle, .nameTitleWithImage:
                if purpose == .createDanceEvent {
                    placeHolder = "Event Title"
                    
                } else if purpose == .createDanceOrganization {
                    placeHolder = "Organization Name"
                    
                } else {
                    placeHolder = "Title"
                }
            case .location:
                placeHolder = "Location"
            case .date:
                placeHolder = "Date"
            case .datePicker:
                placeHolder = "Date"
            case .email:
                placeHolder = "E-mail"
            case .url:
                placeHolder = "Link"
            case .info:
                placeHolder = "Info"
            case .phoneNumber:
                placeHolder = "Phone"
            default:
                placeHolder = "Name"
            }
            
            
            
            return placeHolder
            
            
        }
    }

}


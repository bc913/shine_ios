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
    case about
    case description
    
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
    
    case shineTextField
    case shineTextView
    
    case danceTypes
}

enum FormPurpose {
    
    case createDanceEvent
    case createDanceOrganization
    
    case editDanceEvent
    case editDanceOrganization
    
    case editUserProfile
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
    
    static func create(tableView: UITableView, purpose: FormPurpose, type: FormCellType, placeHolder: String?) -> BaseFormCell{
        
        var nibName : UINib?
        var identifier : String?
        
        
        switch type {
        case .nameTitleWithImage:
            
            let nib : UINib = NameTitleWithImageCell.nib
            tableView.register(nib, forCellReuseIdentifier: NameTitleWithImageCell.identifier)
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: NameTitleWithImageCell.identifier) as? NameTitleWithImageCell{
            
                if placeHolder != nil {
                    cell.placeHolder = placeHolder
                } else {
                    cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
                }
                return cell
            } else {
                fallthrough
            }

            
        case .shineTextField, .email, .phoneNumber, .url:
            identifier = ShineTextFieldCell.identifier
            tableView.register(ShineTextFieldCell.self, forCellReuseIdentifier: identifier!)
            let cell = ShineTextFieldCell(style: .default, reuseIdentifier: identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
            
        case .shineTextView, .info, .about, .description:
            identifier = ShineTextViewCell.identifier
            tableView.register(ShineTextViewCell.self, forCellReuseIdentifier: identifier!)
            let cell = ShineTextViewCell(style: .default, reuseIdentifier: identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
            
        case .switchType:
            identifier = ShineSwitchCell.identifier
            tableView.register(ShineSwitchCell.self, forCellReuseIdentifier: identifier!)
            let cell = ShineSwitchCell(style: .default, reuseIdentifier: identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
            
        case .location:
            nibName = nil
            identifier = ShineLocationCell.identifier
            tableView.register(ShineLocationCell.self, forCellReuseIdentifier: identifier!)
            let cell = ShineLocationCell(style: .default, reuseIdentifier: identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
            
        case .date:
            nibName = DateFormCell.nib
            identifier = DateFormCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            let cell = DateFormCell(style: .default, reuseIdentifier: identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
            
        case .datePicker:
            nibName = ShineDatePickerCell.nib
            identifier = ShineDatePickerCell.identifier
            tableView.register(nibName, forCellReuseIdentifier: identifier!)
            let cell = ShineDatePickerCell(style: .default, reuseIdentifier: ShineDatePickerCell.identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
            
        case .picker:
            nibName = nil
            identifier = PickerFormCell.identifier
            tableView.register(PickerFormCell.self, forCellReuseIdentifier: identifier!)
            let cell = PickerFormCell(style: .default, reuseIdentifier: identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
        case .danceTypes:
            nibName = nil
            identifier = ShineDanceTypesCell.identifier
            tableView.register(ShineDanceTypesCell.self, forCellReuseIdentifier: identifier!)
            let cell = ShineDanceTypesCell(style: .default, reuseIdentifier: identifier)
            if placeHolder != nil {
                cell.placeHolder = placeHolder
            } else {
                cell.placeHolder = Helper.createPlaceHolderText(purpose: purpose, type: type)
            }
            return cell
            
        default:
            
            tableView.register(BaseFormCell.self, forCellReuseIdentifier: "BaseFormCell")
            return BaseFormCell(style: .default, reuseIdentifier: "BaseFormCell")
        }
        
        
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
            case .about:
                placeHolder = "About"
            case .description:
                placeHolder = "Description"
            case .phoneNumber:
                placeHolder = "Phone"
            case .danceTypes:
                placeHolder = NSLocalizedString("Dances", comment: "")
            default:
                placeHolder = "Name"
            }
            
            
            
            return placeHolder
            
            
        }
    }

}


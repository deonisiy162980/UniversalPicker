//
//  Configurators.swift
//  FrameworksTest
//
//  Created by Denis on 16.06.17.
//  Copyright © 2017 Denis Petrov. All rights reserved.
//

import UIKit

//MARK: - PICKERS TYPES
enum PickersType
{
    case date, time, other
}


//MARK: - PICKER PROTOCOLS
protocol DPConfiguratorProtocol
{
    var type : PickersType {get}
}

@objc protocol UniversalPickerDelegate
{
    @objc optional func didSelect(key : String, value : String)
    @objc optional func didSelectDate(date : Date)
    @objc optional func didSelectTime(time : Date)
}


//MARK: - OTHER CONFIGURATOR
struct Configurator
{
    struct OtherConfigurator: DPConfiguratorProtocol
    {
        var dict : [String : String]
        let type = PickersType.other
        var selectedValue: String?
        
        init(withDictOfKeysAndValues dict_ : [String : String], andSelectedValue sel : String? = nil)
        {
            selectedValue = sel
            dict = dict_
        }
    }
}


//MARK: - DATE CONFIGURATOR
extension Configurator
{
    struct DateConfigurator: DPConfiguratorProtocol
    {
        var startDate : Date?
        var minimumDate : Date?
        var maximumDate : Date?
        let type = PickersType.date
        var selectedValue: String?
        
        init(withStartDate sDate : Date?, withMinimumDate mDate : Date?, andMaximumDate eDate : Date?)
        {
            self.startDate = sDate
            self.minimumDate = mDate
            self.maximumDate = eDate
        }
    }
}


//MARK: - TIME CONFIGURATOR
extension Configurator
{
    struct TimeConfigurator: DPConfiguratorProtocol
    {
        var startTime : Date?
        var minimumTime : Date?
        var maximumTime : Date?
        let type = PickersType.time
        
        init(withStartTime sTime : Date?, withMinimumTime mTime : Date?, andMaximumTime eTime : Date?)
        {
            self.startTime = sTime
            self.maximumTime = eTime
            self.minimumTime = mTime
        }
    }
}


//MARK: - CUSTOMIZATOR
extension Configurator
{
    struct Customizator
    {
        var doneButtonColor : UIColor?
        var cancelButtonColor : UIColor?
        var doneButtonText : String?
        var cancelButtonText : String?
    }
}

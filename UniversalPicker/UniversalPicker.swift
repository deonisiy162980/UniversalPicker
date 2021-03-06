//
//  PickerViewController.swift
//  YachtVoyage
//
//  Created by Denis on 02.06.17.
//  Copyright © 2017 Denis Petrov. All rights reserved.
//

import UIKit



public class UniversalPicker: UIViewController
{
    
    @IBOutlet weak fileprivate var pickerView: UIPickerView!
    @IBOutlet weak fileprivate var pickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var buttonView: UIView!
    @IBOutlet weak fileprivate var datePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var datePickerView: UIDatePicker!
    @IBOutlet weak fileprivate var otherPickerView: UIPickerView!
    @IBOutlet weak fileprivate var cancelButton: UIButton!
    @IBOutlet weak fileprivate var doneButton: UIButton!
    
    
    fileprivate var values = [(key : String, value : String)]()
    fileprivate let delegate : UniversalPickerDelegate!
    fileprivate var selectedValue : (key : String, value : String)
    fileprivate let configurator : DPConfiguratorProtocol!
    fileprivate let customizator : Configurator.Customizator?
    
    
    public init(withConfigurator conf : DPConfiguratorProtocol, withDelegate del : UniversalPickerDelegate, andCustomizator cust : Configurator.Customizator?)
    {
        self.delegate = del
        self.configurator = conf
        self.customizator = cust
        
        if conf.type == .other
        {
            values = (conf as! Configurator.OtherConfigurator).dict.sorted { $0.value < $1.value }
            
            selectedValue = (values.first?.key ?? "", values.first?.value ?? "")
        }
        else
        {
            selectedValue = ("", "")
        }
        
        super.init(nibName: "PickerView", bundle: Bundle(for: UniversalPicker.self))
    }
    
    
    public required init?(coder aDecoder: NSCoder)
    {
        selectedValue = ("", "")
        delegate = nil
        configurator = nil
        customizator = nil
        super.init(nibName: "PickerView", bundle: Bundle(for: UniversalPicker.self))
    }
}


//MARK: - VIEW LOADS
extension UniversalPicker
{
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        
        hideAllElements()
    }
    
    
    override public func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        showAnim()
    }
}


//MARK: - MOVE TO SELECTED VALUE
extension UniversalPicker
{
    fileprivate func moveToSelectedValue()
    {
        let selected = (configurator as! Configurator.OtherConfigurator).selectedValue!
        
        for i in 0 ..< values.count
        {
            if values[i].value == selected { selectedValue = (values[i].key, values[i].value); otherPickerView.selectRow(i, inComponent: 0, animated: false); break }
        }
    }
}


//MARK: - PREPARE
extension UniversalPicker
{
    fileprivate func setupPicker()
    {
        setupByCustomizator()
        
        
        if configurator.type == .date
        {
            let conf = configurator as! Configurator.DateConfigurator
            datePickerView.maximumDate = conf.maximumDate
            datePickerView.minimumDate = conf.minimumDate
            datePickerView.date = conf.startDate ?? Date()
            datePickerView.datePickerMode = .date
        }
        else if configurator.type == .other
        {
            datePickerView.alpha = 0.0
            if (configurator as? Configurator.OtherConfigurator)?.selectedValue != nil { moveToSelectedValue() }
        }
        else
        {
            let conf = configurator as! Configurator.TimeConfigurator
            datePickerView.datePickerMode = .time
            datePickerView.maximumDate = conf.maximumTime
            datePickerView.minimumDate = conf.minimumTime
            datePickerView.date = conf.startTime ?? Date()
        }
    }
    
    
    private func setupByCustomizator()
    {
        guard let cust = self.customizator else { return }
        
        UIView.performWithoutAnimation {
            if let doneText = cust.doneButtonText { doneButton.setTitle(doneText, for: .normal) }
            if let cancelText = cust.cancelButtonText { cancelButton.setTitle(cancelText, for: .normal) }
            if let doneColor = cust.doneButtonColor { doneButton.setTitleColor(doneColor, for: .normal) }
            if let cancelColor = cust.cancelButtonColor { cancelButton.setTitleColor(cancelColor, for: .normal) }
            
            doneButton.layoutIfNeeded()
            cancelButton.layoutIfNeeded()
        }
    }
}


//MARK: - ANIM
extension UniversalPicker
{
    fileprivate func hideAllElements()
    {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let pickersBeginConstraint = -1 * ( pickerView.frame.height + buttonView.frame.height)
        pickerBottomConstraint.constant = pickersBeginConstraint
        datePickerBottomConstraint.constant = pickersBeginConstraint
        self.view.layoutIfNeeded()
        
        setupPicker()
    }
    
    
    fileprivate func showAnim()
    {
        pickerBottomConstraint.constant = 0
        datePickerBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            
        }
        
        
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
    }
}


//MARK: - IB ACTIONS
extension UniversalPicker
{
    @IBAction func doneTapped(_ sender: Any)
    {
        if configurator.type == .date
        {
            delegate.didSelectDate?(date: datePickerView.date)
        }
        else if configurator.type == .time
        {
            delegate.didSelectTime?(time: datePickerView.date)
        }
        else
        {
            delegate.didSelect?(key: selectedValue.key, value: selectedValue.value)
        }
        
        
        closeController()
    }
    
    
    @IBAction func cancelTapped(_ sender: Any)
    {
        delegate.didCancel?()
        closeController()
    }
    
    
    @IBAction func gestureTapped(_ sender: Any)
    {
        delegate.didCancel?()
        closeController()
    }
}


//MARK: - PICKER DELEGATE
extension UniversalPicker: UIPickerViewDataSource, UIPickerViewDelegate
{
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return values.count
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return values[row].value
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if values.count != 0 { selectedValue = values[row] }
    }
}


//MARK: - SHOW AND CLOSE
extension UniversalPicker
{
    public func showController(atParentController parentController : UIViewController)
    {
        self.view.frame = parentController.view.frame
        parentController.addChildViewController(self)
        parentController.view.addSubview(self.view)
        self.view.layoutIfNeeded()
        
        pickerView.reloadAllComponents()
        
        self.viewDidAppear(false)
    }
    
    
    public func closeController()
    {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
        
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            
            self.pickerBottomConstraint.constant = -1 * ( self.pickerView.frame.height + self.buttonView.frame.height)
            self.datePickerBottomConstraint.constant = -1 * ( self.pickerView.frame.height + self.buttonView.frame.height)
            self.view.layoutIfNeeded()
            
        }) {  _ in
            
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
        }
    }
}

//
//  ViewController.swift
//  THCalendarDatePickerExampleSwift
//
//  Created by Hannes Tribus on 27/05/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class ViewController: UIViewController,THDatePickerDelegate {

    @IBOutlet weak var dateButton: UIButton!
    var curDate:Date!
    var formatter:DateFormatter!
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.yellow
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curDate = Date()
        formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy --- HH:mm"
        refreshTitle()
    }

    func refreshTitle() {
        dateButton.setTitle((curDate != nil ? formatter.string(from: curDate) : "No date selected"), for: .normal)
    }
    
    @IBAction func dateButtonTouched(sender: AnyObject) {
        datePicker.date = curDate
        datePicker.setDateHasItemsCallback { (date: Date?) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        }
        presentSemiViewController(datePicker, withOptions: [
            convertCfTypeToString(cfValue: KNSemiModalOptionKeys.shadowOpacity) ?? "Error_0" : 0.3 as Float,
            convertCfTypeToString(cfValue: KNSemiModalOptionKeys.animationDuration) ?? "Error_1" : 1.0 as Float,
            convertCfTypeToString(cfValue: KNSemiModalOptionKeys.pushParentBack) ?? "Error_2" : false as Bool
            ])
    }
    
    /* https://vandadnp.wordpress.com/2014/07/07/swift-convert-unmanaged-to-string/ */
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFString>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFString
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    // MARK: THDatePickerDelegate
    
    func datePickerDonePressed(_ datePicker: THDatePickerViewController!) {
        curDate = datePicker.date
        refreshTitle()
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: Date!) {
        let tmp = formatter.string(from: selectedDate)
        print("Date selected: \(tmp)")
    }
}


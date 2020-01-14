//
//  ViewController.swift
//  THCalendarDatePickerSwiftExample
//
//  Created by Hannes Tribus on 04/09/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

import UIKit
import THCalendarDatePicker


class ViewController: UIViewController, THDatePickerDelegate {

    @IBOutlet weak var dateButton: UIButton!
    
    var curDate : Date = Date()
    lazy var formatter: DateFormatter = {
        var tmpFormatter = DateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy --- HH:mm"
        return tmpFormatter
    }()
    lazy var datePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker.delegate = self
        picker.date = self.curDate
        picker.setAllowClearDate(false)
        picker.setClearAsToday(false)
        picker.setAutoCloseOnSelectDate(true)
        picker.setAllowSelectionOfSelectedDate(true)
        picker.setDisableYearSwitch(true)
        //picker.setDisableFutureSelection(false)
        picker.setDaysInHistorySelection(45)
        picker.setDaysInFutureSelection(0)
        picker.setDateTimeZoneWithName("UTC")
        picker.autoCloseCancelDelay = 5.0
        picker.isRounded = true
        picker.dateTitle = "My DatePicker"
        picker.selectedBackgroundColor = UIColor(red: 125.0/255.0, green: 208.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        picker.currentDateColor = UIColor(red: 242.0/255.0, green: 121.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        picker.currentDateColorSelected = .yellow
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshTitle() {
        dateButton.setTitle(formatter.string(from: curDate), for: .normal)
    }
    
    @IBAction func touchedButton(sender: AnyObject) {
        datePicker.date = self.curDate
        datePicker.setDateHasItemsCallback { (date: Date?) -> Bool in
            let tmp = (arc4random() % 30)+1
            return (tmp % 5 == 0)
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
    
    func datePickerDonePressed(_ datePicker: THDatePickerViewController) {
        curDate = datePicker.date ?? Date()
        refreshTitle()
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
        print("Date selected: ", formatter.string(from: selectedDate as Date))
    }
}


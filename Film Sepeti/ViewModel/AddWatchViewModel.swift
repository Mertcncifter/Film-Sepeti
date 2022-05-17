//
//  AddWatchViewModel.swift
//  Film Sepeti
//
//  Created by mert can çifter on 14.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol AddWatchViewModelProtocol {
    var delegate: AddWatchViewModelDelegate? { get set }
    func load()
    func changeWatch(date: Date)
    func addWatch(name: String, link: String)
}

enum AddWatchViewModelOutput {
    case setLoading(Bool)
    case firstLoad(watch:Watch?,watchName: String?)
    case success
}

protocol AddWatchViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: AddWatchViewModelOutput)
}


final class AddWatchViewModel: AddWatchViewModelProtocol {
    
    var delegate: AddWatchViewModelDelegate?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var watch : Watch? = nil
    
    var watchName : String? = nil
    
    var dateWatch : Date?
    
    init(watch: Watch?,watchName: String){
        self.watch = watch
        self.watchName = watchName
        self.dateWatch = watch?.date ?? nil
    }
    
    
        
    func load(){
        notify(.firstLoad(watch: watch, watchName: watchName))
    }
    
    func changeWatch(date: Date) {
        self.dateWatch = date
    }
    
    
    func addWatch(name: String, link: String) {
        guard let date = dateWatch else { return }
        
        if watch == nil {
            let newItem = Watch(context: context)
            newItem.name = name
            newItem.link = link
            newItem.date = date
        }
        
        else {
            watch?.name = name
            watch?.link = link
            watch?.date = date
        }
        
        do{
            try self.context.save()
        } catch {
            return
        }
        
        scheduleNotification(title: "Film Zamanı",message: name,date: date)
        notify(.success)
                
    }
    
    func scheduleNotification(title: String, message: String, date: Date){
        var checkNotification = requestNotification()
        if checkNotification {
            notificationCenter.getNotificationSettings { (settings) in
                DispatchQueue.main.async
                {
                    let title = title
                    let message = message
                    var identifier = "textnotif"
                    if(settings.authorizationStatus == .authorized)
                    {
                        let content = UNMutableNotificationContent()
                        content.title = title
                        content.body = message
                        
                        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        self.notificationCenter.removeAllPendingNotificationRequests()
                        self.notificationCenter.add(request) { (error) in
                            if(error != nil)
                            {
                                print("Error " + error.debugDescription)
                                return
                            }
                        }
                    }
                    else
                    {
                        
                    }
                }
            }
        }
    }
    
    func requestNotification() -> Bool{
        var status = true
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted)
            {
               status = false
            }
        }
        
        return status
    }
    
    private func notify(_ output: AddWatchViewModelOutput){
        delegate?.handleViewModelOutput(output)
    }
}


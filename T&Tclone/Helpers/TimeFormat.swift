//
//  TimeFormat.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/12/23.
//

import Foundation

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}

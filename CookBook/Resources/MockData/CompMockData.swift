//
//  CompMockData.swift
//  CookBook
//
//  Created by Alexander Altman on 01.12.2022.
//

import Foundation

struct CompMockData {
    
    static let shared = CompMockData()
    
    private let vegan: ListSection = {
        .vegan([
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1)
        ])
    }()
    
    private let random: ListSection = {
        .random([
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1),
            .init(title: " ", image: "https://img1.goodfon.ru/original/960x544/0/61/shum-tekstura-svet-seryy.jpg", id: 1)
        ])
    }()
    
    var pageData: [ListSection] {
        [random, vegan]
    }
}

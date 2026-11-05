// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

struct MenuBarAppearanceStrings {
    let label: String
    let values: String
    let bars: String
    let caption: String
    let customize: String
    let normalColor: String
    let mediumColor: String
    let highColor: String
    let mediumFrom: String
    let highFrom: String
    let readingColors: String
    let yellowFrom: String
    let redFrom: String
}

extension FeatureStrings {
    static func menuBarAppearance(_ language: AppLanguage) -> MenuBarAppearanceStrings {
        switch language {
        case .enUS: return .enUS
        case .ptBR: return .ptBR
        case .tr: return .tr
        case .ru: return .ru
        case .es: return .es
        case .sk: return .sk
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .ja: return .ja
        case .ko: return .ko
        case .zhHans: return .zhHans
        case .zhTW: return .zhTW
        case .zhHK: return .zhHK
        case .uk: return .uk
        }
    }
}

extension MenuBarAppearanceStrings {
    static let enUS = MenuBarAppearanceStrings(
        label: "Usage display",
        values: "Values",
        bars: "Bars",
        caption: "Bars apply to CPU, GPU, memory and disk usage. Other readings stay numeric.",
        customize: "Bar colors and limits",
        normalColor: "Normal color",
        mediumColor: "Medium color",
        highColor: "High color",
        mediumFrom: "Medium from",
        highFrom: "High from",
        readingColors: "Color by threshold",
        yellowFrom: "Yellow from",
        redFrom: "Red from"
    )

    static let ptBR = MenuBarAppearanceStrings(
        label: "Exibição de uso",
        values: "Valores",
        bars: "Barras",
        caption: "As barras mostram o uso de CPU, GPU, memória e disco. As outras leituras continuam numéricas.",
        customize: "Cores e limites das barras",
        normalColor: "Cor normal",
        mediumColor: "Cor média",
        highColor: "Cor alta",
        mediumFrom: "Médio a partir de",
        highFrom: "Alto a partir de",
        readingColors: "Cor por limite",
        yellowFrom: "Amarelo a partir de",
        redFrom: "Vermelho a partir de"
    )

    static let tr = MenuBarAppearanceStrings(
        label: "Kullanım görünümü",
        values: "Değerler",
        bars: "Çubuklar",
        caption: "Çubuklar CPU, GPU, bellek ve disk kullanımını gösterir. Diğer ölçümler sayısal kalır.",
        customize: "Çubuk renkleri ve sınırları",
        normalColor: "Normal renk",
        mediumColor: "Orta renk",
        highColor: "Yüksek renk",
        mediumFrom: "Orta başlangıcı",
        highFrom: "Yüksek başlangıcı",
        readingColors: "Eşiğe göre renklendir",
        yellowFrom: "Sarı eşiği",
        redFrom: "Kırmızı eşiği"
    )

    static let ru = MenuBarAppearanceStrings(
        label: "Отображение нагрузки",
        values: "Значения",
        bars: "Шкалы",
        caption: "Шкалы показывают загрузку CPU, GPU, памяти и диска. Остальные показатели остаются числовыми.",
        customize: "Цвета и пороги шкал",
        normalColor: "Обычный цвет",
        mediumColor: "Средний цвет",
        highColor: "Высокий цвет",
        mediumFrom: "Средний от",
        highFrom: "Высокий от",
        readingColors: "Цвет по порогу",
        yellowFrom: "Жёлтый от",
        redFrom: "Красный от"
    )

    static let es = MenuBarAppearanceStrings(
        label: "Vista de uso",
        values: "Valores",
        bars: "Barras",
        caption: "Las barras muestran el uso de CPU, GPU, memoria y disco. Las demás lecturas siguen siendo numéricas.",
        customize: "Colores y límites de las barras",
        normalColor: "Color normal",
        mediumColor: "Color medio",
        highColor: "Color alto",
        mediumFrom: "Medio desde",
        highFrom: "Alto desde",
        readingColors: "Colorear por umbral",
        yellowFrom: "Amarillo desde",
        redFrom: "Rojo desde"
    )

    static let sk = MenuBarAppearanceStrings(
        label: "Zobrazenie vyťaženia",
        values: "Hodnoty",
        bars: "Pruhy",
        caption: "Pruhy platia pre vyťaženie CPU, GPU, pamäte a disku. Ostatné hodnoty zostávajú číselné.",
        customize: "Farby a limity pruhov",
        normalColor: "Bežná farba",
        mediumColor: "Stredná farba",
        highColor: "Vysoká farba",
        mediumFrom: "Stredná od",
        highFrom: "Vysoká od",
        readingColors: "Farba podľa prahu",
        yellowFrom: "Žltá od",
        redFrom: "Červená od"
    )

    static let de = MenuBarAppearanceStrings(
        label: "Auslastungsanzeige",
        values: "Werte",
        bars: "Balken",
        caption: "Balken zeigen die Auslastung von CPU, GPU, Speicher und Festplatte. Andere Messwerte bleiben numerisch.",
        customize: "Balkenfarben und Grenzwerte",
        normalColor: "Normale Farbe",
        mediumColor: "Mittlere Farbe",
        highColor: "Hohe Farbe",
        mediumFrom: "Mittel ab",
        highFrom: "Hoch ab",
        readingColors: "Farbe nach Schwellenwert",
        yellowFrom: "Gelb ab",
        redFrom: "Rot ab"
    )

    static let fr = MenuBarAppearanceStrings(
        label: "Affichage de l’utilisation",
        values: "Valeurs",
        bars: "Barres",
        caption: "Les barres indiquent l’utilisation du CPU, du GPU, de la mémoire et du disque. Les autres mesures restent numériques.",
        customize: "Couleurs et seuils des barres",
        normalColor: "Couleur normale",
        mediumColor: "Couleur moyenne",
        highColor: "Couleur élevée",
        mediumFrom: "Moyen à partir de",
        highFrom: "Élevé à partir de",
        readingColors: "Couleur selon le seuil",
        yellowFrom: "Jaune à partir de",
        redFrom: "Rouge à partir de"
    )

    static let it = MenuBarAppearanceStrings(
        label: "Visualizzazione utilizzo",
        values: "Valori",
        bars: "Barre",
        caption: "Le barre mostrano l’utilizzo di CPU, GPU, memoria e disco. Le altre letture restano numeriche.",
        customize: "Colori e soglie delle barre",
        normalColor: "Colore normale",
        mediumColor: "Colore medio",
        highColor: "Colore alto",
        mediumFrom: "Medio da",
        highFrom: "Alto da",
        readingColors: "Colore in base alla soglia",
        yellowFrom: "Giallo da",
        redFrom: "Rosso da"
    )

    static let ja = MenuBarAppearanceStrings(
        label: "使用率の表示",
        values: "数値",
        bars: "バー",
        caption: "CPU、GPU、メモリ、ディスクの使用率をバーで表示します。その他の測定値は数値のままです。",
        customize: "バーの色としきい値",
        normalColor: "通常の色",
        mediumColor: "中程度の色",
        highColor: "高負荷の色",
        mediumFrom: "中程度の開始",
        highFrom: "高負荷の開始",
        readingColors: "しきい値で色を変更",
        yellowFrom: "黄色のしきい値",
        redFrom: "赤色のしきい値"
    )

    static let ko = MenuBarAppearanceStrings(
        label: "사용량 표시",
        values: "값",
        bars: "막대",
        caption: "CPU, GPU, 메모리 및 디스크 사용량을 막대로 표시합니다. 다른 측정값은 숫자로 유지됩니다.",
        customize: "막대 색상 및 기준",
        normalColor: "보통 색상",
        mediumColor: "중간 색상",
        highColor: "높음 색상",
        mediumFrom: "중간 시작",
        highFrom: "높음 시작",
        readingColors: "임계값에 따라 색상 변경",
        yellowFrom: "노란색 시작 값",
        redFrom: "빨간색 시작 값"
    )

    static let zhHans = MenuBarAppearanceStrings(
        label: "使用率显示",
        values: "数值",
        bars: "条形",
        caption: "CPU、GPU、内存和磁盘使用率以条形显示。其他读数保持数字显示。",
        customize: "条形颜色和阈值",
        normalColor: "正常颜色",
        mediumColor: "中等颜色",
        highColor: "高负载颜色",
        mediumFrom: "中等起点",
        highFrom: "高负载起点",
        readingColors: "按阈值变色",
        yellowFrom: "黄色阈值",
        redFrom: "红色阈值"
    )

    static let zhTW = MenuBarAppearanceStrings(
        label: "使用率顯示",
        values: "數值",
        bars: "長條",
        caption: "CPU、GPU、記憶體和磁碟使用率以長條顯示。其他讀數維持數字顯示。",
        customize: "長條顏色和門檻",
        normalColor: "正常顏色",
        mediumColor: "中等顏色",
        highColor: "高負載顏色",
        mediumFrom: "中等起點",
        highFrom: "高負載起點",
        readingColors: "依門檻變色",
        yellowFrom: "黃色門檻",
        redFrom: "紅色門檻"
    )

    static let zhHK = MenuBarAppearanceStrings(
        label: "使用率顯示",
        values: "數值",
        bars: "長條",
        caption: "CPU、GPU、記憶體及磁碟使用率以長條顯示。其他讀數維持數字顯示。",
        customize: "長條顏色及門檻",
        normalColor: "正常顏色",
        mediumColor: "中等顏色",
        highColor: "高負載顏色",
        mediumFrom: "中等起點",
        highFrom: "高負載起點",
        readingColors: "按門檻變色",
        yellowFrom: "黃色門檻",
        redFrom: "紅色門檻"
    )
    static let uk = MenuBarAppearanceStrings(
        label: "Відображення використання",
        values: "Значення",
        bars: "Смуги",
        caption: "Смуги застосовуються до використання CPU, GPU, пам’яті та диска. Інші показники залишаються числовими.",
        customize: "Кольори та ліміти смуг",
        normalColor: "Звичайний колір",
        mediumColor: "Середній колір",
        highColor: "Високий колір",
        mediumFrom: "Середній від",
        highFrom: "Високий від",
        readingColors: "Колір за порогом",
        yellowFrom: "Жовтий від",
        redFrom: "Червоний від"
    )
}

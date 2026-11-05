// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

struct CPUStressFeatureStrings {
    let title: String
    let description: String
    let workers: String
    let start: String
    let stop: String
    let running: String
    let stopping: String
    let completed: String
    let stopped: String
    let thermalLimit: String
    let peak: String
}

extension FeatureStrings {
    static func cpuStress(_ language: AppLanguage) -> CPUStressFeatureStrings {
        switch language {
        case .enUS:
            return .init(title: "CPU Stress Test", description: "Apply a sustained load to the CPU and measure its usage.",
                         workers: "Worker threads", start: "Start Test", stop: "Stop Test", running: "Test running…",
                         stopping: "Stopping…", completed: "Test completed", stopped: "Test stopped",
                         thermalLimit: "High thermal pressure. Let your Mac cool down.", peak: "Peak CPU usage")
        case .es:
            return .init(title: "Prueba de estrés de CPU", description: "Aplica una carga sostenida a la CPU y mide su uso.",
                         workers: "Hilos de trabajo", start: "Iniciar prueba", stop: "Detener prueba", running: "Prueba en curso…",
                         stopping: "Deteniendo…", completed: "Prueba completada", stopped: "Prueba detenida",
                         thermalLimit: "Presión térmica alta. Deja que el Mac se enfríe.", peak: "Pico de uso de CPU")
        case .ptBR:
            return .init(title: "Teste de estresse da CPU", description: "Aplica uma carga contínua à CPU e mede seu uso.",
                         workers: "Threads de trabalho", start: "Iniciar teste", stop: "Parar teste", running: "Teste em andamento…",
                         stopping: "Parando…", completed: "Teste concluído", stopped: "Teste interrompido",
                         thermalLimit: "Pressão térmica alta. Deixe o Mac esfriar.", peak: "Pico de uso da CPU")
        case .de:
            return .init(title: "CPU-Stresstest", description: "Belastet die CPU dauerhaft und misst ihre Auslastung.",
                         workers: "Worker-Threads", start: "Test starten", stop: "Test stoppen", running: "Test läuft …",
                         stopping: "Wird gestoppt …", completed: "Test abgeschlossen", stopped: "Test gestoppt",
                         thermalLimit: "Hohe thermische Belastung. Lass deinen Mac abkühlen.", peak: "Maximale CPU-Auslastung")
        case .fr:
            return .init(title: "Test de charge du processeur", description: "Soumet le processeur à une charge soutenue et mesure son utilisation.",
                         workers: "Threads de calcul", start: "Démarrer le test", stop: "Arrêter le test", running: "Test en cours…",
                         stopping: "Arrêt en cours…", completed: "Test terminé", stopped: "Test arrêté",
                         thermalLimit: "Pression thermique élevée. Laissez refroidir votre Mac.", peak: "Pic d’utilisation du processeur")
        case .it:
            return .init(title: "Stress test della CPU", description: "Applica un carico continuo alla CPU e ne misura l’utilizzo.",
                         workers: "Thread di lavoro", start: "Avvia test", stop: "Interrompi test", running: "Test in corso…",
                         stopping: "Interruzione in corso…", completed: "Test completato", stopped: "Test interrotto",
                         thermalLimit: "Pressione termica elevata. Lascia raffreddare il Mac.", peak: "Picco di utilizzo della CPU")
        case .sk:
            return .init(title: "Záťažový test CPU", description: "Trvalo zaťaží procesor a meria jeho vyťaženie.",
                         workers: "Pracovné vlákna", start: "Spustiť test", stop: "Zastaviť test", running: "Test prebieha…",
                         stopping: "Zastavuje sa…", completed: "Test dokončený", stopped: "Test zastavený",
                         thermalLimit: "Vysoká tepelná záťaž. Nechajte Mac vychladnúť.", peak: "Maximálne vyťaženie CPU")
        case .ru:
            return .init(title: "Стресс-тест ЦП", description: "Создаёт длительную нагрузку на процессор и измеряет его загрузку.",
                         workers: "Рабочие потоки", start: "Запустить тест", stop: "Остановить тест", running: "Тест выполняется…",
                         stopping: "Остановка…", completed: "Тест завершён", stopped: "Тест остановлен",
                         thermalLimit: "Высокая тепловая нагрузка. Дайте Mac остыть.", peak: "Пиковая загрузка ЦП")
        case .uk:
            return .init(title: "Стрес-тест ЦП", description: "Створює тривале навантаження на процесор і вимірює його завантаження.",
                         workers: "Робочі потоки", start: "Запустити тест", stop: "Зупинити тест", running: "Тест триває…",
                         stopping: "Зупинення…", completed: "Тест завершено", stopped: "Тест зупинено",
                         thermalLimit: "Високе теплове навантаження. Дайте Mac охолонути.", peak: "Пікове завантаження ЦП")
        case .tr:
            return .init(title: "CPU Stres Testi", description: "CPU’ya sürekli yük uygular ve kullanımını ölçer.",
                         workers: "İş parçacıkları", start: "Testi Başlat", stop: "Testi Durdur", running: "Test çalışıyor…",
                         stopping: "Durduruluyor…", completed: "Test tamamlandı", stopped: "Test durduruldu",
                         thermalLimit: "Isıl baskı yüksek. Mac’in soğumasını bekleyin.", peak: "En yüksek CPU kullanımı")
        case .ja:
            return .init(title: "CPUストレステスト", description: "CPUに継続的な負荷をかけ、使用率を測定します。",
                         workers: "ワーカースレッド数", start: "テストを開始", stop: "テストを停止", running: "テスト実行中…",
                         stopping: "停止中…", completed: "テスト完了", stopped: "テスト停止",
                         thermalLimit: "熱負荷が高くなっています。Macを冷ましてください。", peak: "最大CPU使用率")
        case .ko:
            return .init(title: "CPU 스트레스 테스트", description: "CPU에 지속적으로 부하를 주고 사용률을 측정합니다.",
                         workers: "작업 스레드 수", start: "테스트 시작", stop: "테스트 중지", running: "테스트 실행 중…",
                         stopping: "중지 중…", completed: "테스트 완료", stopped: "테스트 중지됨",
                         thermalLimit: "열 부하가 높습니다. Mac을 식혀 주세요.", peak: "최대 CPU 사용률")
        case .zhHans:
            return .init(title: "CPU 压力测试", description: "对 CPU 施加持续负载并测量其使用率。",
                         workers: "工作线程数", start: "开始测试", stop: "停止测试", running: "正在测试…",
                         stopping: "正在停止…", completed: "测试完成", stopped: "测试已停止",
                         thermalLimit: "热负载过高。请让 Mac 冷却。", peak: "CPU 使用率峰值")
        case .zhTW:
            return .init(title: "CPU 壓力測試", description: "讓 CPU 持續承受負載並測量其使用率。",
                         workers: "工作執行緒數", start: "開始測試", stop: "停止測試", running: "正在測試…",
                         stopping: "正在停止…", completed: "測試完成", stopped: "測試已停止",
                         thermalLimit: "熱負載過高。請讓 Mac 冷卻。", peak: "CPU 使用率峰值")
        case .zhHK:
            return .init(title: "CPU 壓力測試", description: "讓 CPU 持續承受負載並量度其使用率。",
                         workers: "工作執行緒數", start: "開始測試", stop: "停止測試", running: "正在測試…",
                         stopping: "正在停止…", completed: "測試完成", stopped: "測試已停止",
                         thermalLimit: "熱負載過高。請讓 Mac 降溫。", peak: "CPU 使用率峰值")
        }
    }
}

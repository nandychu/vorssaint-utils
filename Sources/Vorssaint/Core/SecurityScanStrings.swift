// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

struct SecurityScanFeatureStrings {
    let title: String
    let hubDescription: String
    let scan: String
    let scanning: String
    let scope: String
    let filter: String
    let all: String
    let review: String
    let listeners: String
    let incomplete: String
    let empty: String
    let ready: String
    let summary: String
    let listenerReadFailed: String
    let partial: String
    let valid: String
    let adHoc: String
    let unsigned: String
    let invalid: String
    let unavailable: String
    let local: String
    let network: String
    let unknownScope: String
    let invalidReason: String
    let unsignedNetworkReason: String
    let temporaryReason: String
    let identityChanged: String
    let failed: String
}

extension FeatureStrings {
    static func securityScan(_ language: AppLanguage) -> SecurityScanFeatureStrings {
        switch language {
        case .enUS: return .enUS
        case .es: return .es
        case .ptBR: return .ptBR
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .sk: return .sk
        case .ru: return .ru
        case .uk: return .uk
        case .tr: return .tr
        case .ja: return .ja
        case .ko: return .ko
        case .zhHans: return .zhHans
        case .zhTW: return .zhTW
        case .zhHK: return .zhHK
        }
    }
}

extension SecurityScanFeatureStrings {
    static let enUS = SecurityScanFeatureStrings(
        title: "Security",
        hubDescription: "Manually review running processes, identity signatures, and listening TCP ports",
        scan: "Scan now",
        scanning: "Scanning…",
        scope: "Local snapshot with your user’s access; macOS may hide data. Checks running identity signatures, not all app files or malware. Network bindings do not confirm reachability.",
        filter: "Search name, PID, path, or port",
        all: "All",
        review: "Review",
        listeners: "TCP listeners",
        incomplete: "Incomplete",
        empty: "No matching processes.",
        ready: "Start a manual scan to see processes and listening ports.",
        summary: "Processes: %d · TCP listeners: %d · To review: %d",
        listenerReadFailed: "TCP listener data could not be fully read. This list may omit ports.",
        partial: "Some readings are unavailable or incomplete. Open the Incomplete filter; the TCP listener list may also be partial.",
        valid: "Identity signature valid",
        adHoc: "Ad-hoc signature",
        unsigned: "Unsigned",
        invalid: "Identity signature invalid",
        unavailable: "Signature unavailable",
        local: "This Mac only",
        network: "Network interface",
        unknownScope: "Unknown scope",
        invalidReason: "The running code’s identity signature failed validation. Review the app’s origin; this alone does not identify malware.",
        unsignedNetworkReason: "An unsigned or ad-hoc signed process listens on a network interface. Development tools can legitimately do this.",
        temporaryReason: "An executable in a temporary folder listens on a network interface. Check whether you expected to run it.",
        identityChanged: "The process ended, changed, or its identity could not be verified. Scan again.",
        failed: "Could not read processes. Try scanning again."
    )

    static let es = SecurityScanFeatureStrings(
        title: "Seguridad",
        hubDescription: "Revisa manualmente procesos activos, firmas de identidad y puertos TCP en escucha",
        scan: "Analizar ahora",
        scanning: "Analizando…",
        scope: "Instantánea local con los permisos de tu usuario; macOS puede ocultar datos. Comprueba firmas de identidad, no todos los archivos ni malware. Escuchar en la red no confirma que el puerto sea accesible.",
        filter: "Buscar nombre, PID, ruta o puerto",
        all: "Todos",
        review: "Revisar",
        listeners: "Escucha TCP",
        incomplete: "Incompletos",
        empty: "No hay procesos que coincidan.",
        ready: "Inicia un análisis manual para ver procesos y puertos en escucha.",
        summary: "Procesos: %d · Escuchas TCP: %d · Por revisar: %d",
        listenerReadFailed: "No se pudo completar la lectura de escuchas TCP. Pueden faltar puertos en la lista.",
        partial: "Hay lecturas incompletas o no disponibles. Consulta el filtro Incompletos; la lista de puertos TCP también puede ser parcial.",
        valid: "Firma de identidad válida",
        adHoc: "Firma ad hoc",
        unsigned: "Sin firma",
        invalid: "Firma de identidad inválida",
        unavailable: "Firma no disponible",
        local: "Solo este Mac",
        network: "Interfaz de red",
        unknownScope: "Alcance desconocido",
        invalidReason: "La firma de identidad del proceso no supera la validación. Revisa el origen de la app; esto por sí solo no identifica malware.",
        unsignedNetworkReason: "Un proceso sin firma o con firma ad hoc escucha en una interfaz de red. Puede ser normal en herramientas de desarrollo.",
        temporaryReason: "Un ejecutable en una carpeta temporal escucha en una interfaz de red. Comprueba si esperabas ejecutarlo.",
        identityChanged: "El proceso terminó, cambió o no se pudo verificar su identidad. Vuelve a analizar.",
        failed: "No se pudieron leer los procesos. Vuelve a analizar."
    )

    static let ptBR = SecurityScanFeatureStrings(
        title: "Segurança",
        hubDescription: "Revise manualmente processos, assinaturas de identidade e portas TCP em escuta",
        scan: "Analisar agora",
        scanning: "Analisando…",
        scope: "Retrato local com as permissões do usuário; o macOS pode ocultar dados. Verifica assinaturas de identidade, não todos os arquivos nem malware. Escutar na rede não confirma acessibilidade.",
        filter: "Buscar nome, PID, caminho ou porta",
        all: "Todos",
        review: "Revisar",
        listeners: "Escuta TCP",
        incomplete: "Incompletos",
        empty: "Nenhum processo correspondente.",
        ready: "Inicie uma análise manual para ver processos e portas em escuta.",
        summary: "Processos: %d · Escutas TCP: %d · Para revisar: %d",
        listenerReadFailed: "Não foi possível ler todas as escutas TCP. A lista pode omitir portas.",
        partial: "Algumas leituras estão incompletas ou indisponíveis. Veja o filtro Incompletos; a lista de portas TCP também pode ser parcial.",
        valid: "Assinatura de identidade válida",
        adHoc: "Assinatura ad hoc",
        unsigned: "Sem assinatura",
        invalid: "Assinatura de identidade inválida",
        unavailable: "Assinatura indisponível",
        local: "Somente este Mac",
        network: "Interface de rede",
        unknownScope: "Escopo desconhecido",
        invalidReason: "A assinatura de identidade do processo falhou na validação. Verifique a origem do app; isso por si só não identifica malware.",
        unsignedNetworkReason: "Um processo sem assinatura ou com assinatura ad hoc escuta na rede. Isso pode ser normal em ferramentas de desenvolvimento.",
        temporaryReason: "Um executável em pasta temporária escuta na rede. Verifique se você esperava executá-lo.",
        identityChanged: "O processo terminou, mudou ou sua identidade não pôde ser verificada. Analise novamente.",
        failed: "Não foi possível ler os processos. Tente novamente."
    )

    static let de = SecurityScanFeatureStrings(
        title: "Sicherheit",
        hubDescription: "Prozesse, Identitätssignaturen und lauschende TCP-Ports manuell prüfen",
        scan: "Jetzt prüfen",
        scanning: "Prüfung läuft…",
        scope: "Lokale Momentaufnahme mit deinen Benutzerrechten; macOS kann Daten ausblenden. Prüft Identitätssignaturen, nicht alle App-Dateien oder Schadsoftware. Netzwerkbindungen bestätigen keine Erreichbarkeit.",
        filter: "Name, PID, Pfad oder Port suchen",
        all: "Alle",
        review: "Prüfen",
        listeners: "TCP-Listener",
        incomplete: "Unvollständig",
        empty: "Keine passenden Prozesse.",
        ready: "Starte eine manuelle Prüfung, um Prozesse und lauschende Ports zu sehen.",
        summary: "Prozesse: %d · TCP-Listener: %d · Zu prüfen: %d",
        listenerReadFailed: "TCP-Listener konnten nicht vollständig gelesen werden. In der Liste können Ports fehlen.",
        partial: "Einige Daten fehlen oder sind unvollständig. Siehe den Filter Unvollständig; auch die TCP-Portliste kann unvollständig sein.",
        valid: "Identitätssignatur gültig",
        adHoc: "Ad-hoc-Signatur",
        unsigned: "Nicht signiert",
        invalid: "Identitätssignatur ungültig",
        unavailable: "Signatur nicht verfügbar",
        local: "Nur dieser Mac",
        network: "Netzwerkschnittstelle",
        unknownScope: "Unbekannter Bereich",
        invalidReason: "Die Identitätssignatur des Prozesses konnte nicht validiert werden. Prüfe die Herkunft der App; dies allein weist keine Schadsoftware nach.",
        unsignedNetworkReason: "Ein unsignierter oder ad hoc signierter Prozess lauscht im Netzwerk. Bei Entwicklungswerkzeugen kann das normal sein.",
        temporaryReason: "Ein Programm in einem temporären Ordner lauscht im Netzwerk. Prüfe, ob du es absichtlich gestartet hast.",
        identityChanged: "Der Prozess wurde beendet, geändert oder seine Identität konnte nicht geprüft werden. Prüfe erneut.",
        failed: "Prozesse konnten nicht gelesen werden. Versuche es erneut."
    )

    static let fr = SecurityScanFeatureStrings(
        title: "Sécurité",
        hubDescription: "Examiner manuellement les processus, leurs signatures d’identité et les ports TCP en écoute",
        scan: "Analyser",
        scanning: "Analyse…",
        scope: "Instantané local avec vos droits utilisateur ; macOS peut masquer des données. Vérifie les signatures d’identité, pas tous les fichiers ni les logiciels malveillants. Une écoute réseau ne confirme pas l’accessibilité.",
        filter: "Rechercher nom, PID, chemin ou port",
        all: "Tous",
        review: "À examiner",
        listeners: "Écoutes TCP",
        incomplete: "Incomplets",
        empty: "Aucun processus correspondant.",
        ready: "Lancez une analyse manuelle pour voir les processus et ports en écoute.",
        summary: "Processus : %d · Écoutes TCP : %d · À examiner : %d",
        listenerReadFailed: "Les écoutes TCP n’ont pas pu être entièrement lues. Des ports peuvent manquer.",
        partial: "Certaines lectures sont indisponibles ou incomplètes. Consultez le filtre Incomplets ; la liste des ports TCP peut aussi être partielle.",
        valid: "Signature d’identité valide",
        adHoc: "Signature ad hoc",
        unsigned: "Non signé",
        invalid: "Signature d’identité invalide",
        unavailable: "Signature indisponible",
        local: "Ce Mac uniquement",
        network: "Interface réseau",
        unknownScope: "Portée inconnue",
        invalidReason: "La signature d’identité du processus n’a pas été validée. Vérifiez l’origine de l’app ; cela seul ne prouve pas la présence d’un logiciel malveillant.",
        unsignedNetworkReason: "Un processus non signé ou signé ad hoc écoute sur le réseau. Cela peut être normal pour les outils de développement.",
        temporaryReason: "Un exécutable dans un dossier temporaire écoute sur le réseau. Vérifiez si vous aviez prévu de l’exécuter.",
        identityChanged: "Le processus s’est arrêté, a changé ou son identité n’a pas pu être vérifiée. Relancez l’analyse.",
        failed: "Impossible de lire les processus. Réessayez."
    )

    static let it = SecurityScanFeatureStrings(
        title: "Sicurezza",
        hubDescription: "Controlla manualmente processi, firme di identità e porte TCP in ascolto",
        scan: "Analizza ora",
        scanning: "Analisi…",
        scope: "Istantanea locale con i tuoi permessi; macOS può nascondere dati. Controlla le firme di identità, non tutti i file o il malware. L’ascolto in rete non conferma la raggiungibilità.",
        filter: "Cerca nome, PID, percorso o porta",
        all: "Tutti",
        review: "Da verificare",
        listeners: "Ascolti TCP",
        incomplete: "Incompleti",
        empty: "Nessun processo corrispondente.",
        ready: "Avvia un’analisi manuale per vedere processi e porte in ascolto.",
        summary: "Processi: %d · Ascolti TCP: %d · Da verificare: %d",
        listenerReadFailed: "Impossibile leggere tutti gli ascolti TCP. Alcune porte potrebbero mancare.",
        partial: "Alcune letture sono incomplete o non disponibili. Usa il filtro Incompleti; anche l’elenco delle porte TCP può essere parziale.",
        valid: "Firma di identità valida",
        adHoc: "Firma ad hoc",
        unsigned: "Non firmato",
        invalid: "Firma di identità non valida",
        unavailable: "Firma non disponibile",
        local: "Solo questo Mac",
        network: "Interfaccia di rete",
        unknownScope: "Ambito sconosciuto",
        invalidReason: "La firma di identità del processo non ha superato la verifica. Controlla l’origine dell’app; questo da solo non identifica malware.",
        unsignedNetworkReason: "Un processo non firmato o con firma ad hoc ascolta in rete. Può essere normale per gli strumenti di sviluppo.",
        temporaryReason: "Un eseguibile in una cartella temporanea ascolta in rete. Verifica se intendevi eseguirlo.",
        identityChanged: "Il processo è terminato, è cambiato o non è stato possibile verificarne l’identità. Ripeti l’analisi.",
        failed: "Impossibile leggere i processi. Riprova."
    )

    static let sk = SecurityScanFeatureStrings(
        title: "Bezpečnosť",
        hubDescription: "Ručne skontrolujte procesy, podpisy identity a počúvajúce porty TCP",
        scan: "Analyzovať teraz",
        scanning: "Analyzuje sa…",
        scope: "Lokálna snímka s vašimi oprávneniami; macOS môže skryť údaje. Overuje podpisy identity, nie všetky súbory ani malvér. Počúvanie v sieti nepotvrdzuje dostupnosť.",
        filter: "Hľadať názov, PID, cestu alebo port",
        all: "Všetky",
        review: "Na kontrolu",
        listeners: "TCP porty",
        incomplete: "Neúplné",
        empty: "Žiadne zodpovedajúce procesy.",
        ready: "Spustite ručnú analýzu procesov a počúvajúcich portov.",
        summary: "Procesy: %d · TCP porty: %d · Na kontrolu: %d",
        listenerReadFailed: "Počúvajúce porty TCP sa nepodarilo úplne načítať. Niektoré porty môžu chýbať.",
        partial: "Niektoré údaje sú neúplné alebo nedostupné. Pozrite filter Neúplné; aj zoznam portov TCP môže byť čiastočný.",
        valid: "Platný podpis identity",
        adHoc: "Podpis ad hoc",
        unsigned: "Bez podpisu",
        invalid: "Neplatný podpis identity",
        unavailable: "Podpis nedostupný",
        local: "Len tento Mac",
        network: "Sieťové rozhranie",
        unknownScope: "Neznámy rozsah",
        invalidReason: "Podpis identity procesu neprešiel overením. Skontrolujte pôvod aplikácie; toto samo osebe nepreukazuje malvér.",
        unsignedNetworkReason: "Proces bez podpisu alebo s podpisom ad hoc počúva v sieti. Pri vývojových nástrojoch to môže byť bežné.",
        temporaryReason: "Program v dočasnom priečinku počúva v sieti. Skontrolujte, či ste ho chceli spustiť.",
        identityChanged: "Proces skončil, zmenil sa alebo nebolo možné overiť jeho identitu. Analyzujte znova.",
        failed: "Procesy sa nepodarilo načítať. Skúste znova."
    )

    static let ru = SecurityScanFeatureStrings(
        title: "Безопасность",
        hubDescription: "Ручная проверка процессов, подписей идентичности и прослушиваемых TCP-портов",
        scan: "Проверить",
        scanning: "Проверка…",
        scope: "Локальный снимок с правами вашего пользователя; macOS может скрывать данные. Проверяются подписи идентичности, а не все файлы или вредоносное ПО. Прослушивание сети не подтверждает доступность.",
        filter: "Поиск по имени, PID, пути или порту",
        all: "Все",
        review: "Проверить",
        listeners: "TCP-порты",
        incomplete: "Неполные",
        empty: "Подходящих процессов нет.",
        ready: "Запустите ручную проверку процессов и прослушиваемых портов.",
        summary: "Процессы: %d · TCP-порты: %d · На проверку: %d",
        listenerReadFailed: "Данные о прослушиваемых TCP-портах прочитаны не полностью. Некоторые порты могут отсутствовать.",
        partial: "Некоторые данные недоступны или неполны. Откройте фильтр «Неполные»; список TCP-портов также может быть неполным.",
        valid: "Подпись идентичности действительна",
        adHoc: "Подпись ad hoc",
        unsigned: "Без подписи",
        invalid: "Подпись идентичности недействительна",
        unavailable: "Подпись недоступна",
        local: "Только этот Mac",
        network: "Сетевой интерфейс",
        unknownScope: "Неизвестная область",
        invalidReason: "Подпись идентичности процесса не прошла проверку. Проверьте источник приложения; само по себе это не доказывает наличие вредоносного ПО.",
        unsignedNetworkReason: "Процесс без подписи или с подписью ad hoc прослушивает сеть. Для инструментов разработки это может быть нормально.",
        temporaryReason: "Исполняемый файл во временной папке прослушивает сеть. Убедитесь, что вы намеревались его запустить.",
        identityChanged: "Процесс завершился, изменился или его идентичность не удалось проверить. Повторите проверку.",
        failed: "Не удалось прочитать процессы. Повторите попытку."
    )

    static let uk = SecurityScanFeatureStrings(
        title: "Безпека",
        hubDescription: "Ручна перевірка процесів, підписів ідентичності та портів TCP, що прослуховуються",
        scan: "Перевірити",
        scanning: "Перевірка…",
        scope: "Локальний знімок із правами вашого користувача; macOS може приховувати дані. Перевіряються підписи ідентичності, а не всі файли чи шкідливе ПЗ. Прослуховування мережі не підтверджує доступність.",
        filter: "Пошук за назвою, PID, шляхом або портом",
        all: "Усі",
        review: "Переглянути",
        listeners: "Порти TCP",
        incomplete: "Неповні",
        empty: "Відповідних процесів немає.",
        ready: "Запустіть ручну перевірку процесів і портів, що прослуховуються.",
        summary: "Процеси: %d · Порти TCP: %d · Для перевірки: %d",
        listenerReadFailed: "Дані про порти TCP, що прослуховуються, прочитано не повністю. Деякі порти можуть бути відсутні.",
        partial: "Деякі дані недоступні або неповні. Відкрийте фільтр «Неповні»; список портів TCP також може бути частковим.",
        valid: "Підпис ідентичності дійсний",
        adHoc: "Підпис ad hoc",
        unsigned: "Без підпису",
        invalid: "Підпис ідентичності недійсний",
        unavailable: "Підпис недоступний",
        local: "Лише цей Mac",
        network: "Мережевий інтерфейс",
        unknownScope: "Невідома область",
        invalidReason: "Підпис ідентичності процесу не пройшов перевірку. Перевірте джерело застосунку; саме по собі це не доводить наявності шкідливого ПЗ.",
        unsignedNetworkReason: "Процес без підпису або з підписом ad hoc прослуховує мережу. Для засобів розробки це може бути нормально.",
        temporaryReason: "Виконуваний файл у тимчасовій папці прослуховує мережу. Перевірте, чи ви мали намір його запустити.",
        identityChanged: "Процес завершився, змінився або його ідентичність не вдалося перевірити. Повторіть перевірку.",
        failed: "Не вдалося прочитати процеси. Спробуйте ще раз."
    )

    static let tr = SecurityScanFeatureStrings(
        title: "Güvenlik",
        hubDescription: "Çalışan süreçleri, kimlik imzalarını ve dinleyen TCP portlarını elle inceleyin",
        scan: "Şimdi tara",
        scanning: "Taranıyor…",
        scope: "Kullanıcı izinlerinizle yerel anlık görüntü; macOS bazı verileri gizleyebilir. Kimlik imzalarını denetler; tüm dosyaları veya kötü amaçlı yazılımları taramaz. Ağda dinleme erişilebilirliği doğrulamaz.",
        filter: "Ad, PID, yol veya port ara",
        all: "Tümü",
        review: "İncele",
        listeners: "TCP dinleme",
        incomplete: "Eksik",
        empty: "Eşleşen süreç yok.",
        ready: "Süreçleri ve dinleyen portları görmek için elle tarama başlatın.",
        summary: "Süreç: %d · TCP dinleme: %d · İncelenecek: %d",
        listenerReadFailed: "TCP dinleme verileri tam okunamadı. Listede bazı portlar eksik olabilir.",
        partial: "Bazı okumalar eksik veya kullanılamıyor. Eksik filtresine bakın; TCP port listesi de kısmi olabilir.",
        valid: "Kimlik imzası geçerli",
        adHoc: "Ad hoc imza",
        unsigned: "İmzasız",
        invalid: "Kimlik imzası geçersiz",
        unavailable: "İmza kullanılamıyor",
        local: "Yalnızca bu Mac",
        network: "Ağ arayüzü",
        unknownScope: "Bilinmeyen kapsam",
        invalidReason: "Sürecin kimlik imzası doğrulanamadı. Uygulamanın kaynağını inceleyin; bu tek başına kötü amaçlı yazılım kanıtı değildir.",
        unsignedNetworkReason: "İmzasız veya ad hoc imzalı bir süreç ağda dinliyor. Geliştirme araçlarında bu normal olabilir.",
        temporaryReason: "Geçici klasördeki bir çalıştırılabilir dosya ağda dinliyor. Bunu çalıştırmayı bekleyip beklemediğinizi kontrol edin.",
        identityChanged: "Süreç sonlandı, değişti veya kimliği doğrulanamadı. Yeniden tarayın.",
        failed: "Süreçler okunamadı. Yeniden deneyin."
    )

    static let ja = SecurityScanFeatureStrings(
        title: "セキュリティ",
        hubDescription: "プロセス、識別署名、待ち受けTCPポートを手動で確認",
        scan: "今すぐスキャン",
        scanning: "スキャン中…",
        scope: "ユーザー権限で取得するローカルのスナップショットです。macOSが一部の情報を隠す場合があります。識別署名を確認しますが、全ファイルやマルウェアの検査ではありません。ネットワーク待ち受けは接続可能性を保証しません。",
        filter: "名前、PID、パス、ポートを検索",
        all: "すべて",
        review: "要確認",
        listeners: "TCP待ち受け",
        incomplete: "未確認",
        empty: "一致するプロセスはありません。",
        ready: "手動スキャンを開始すると、プロセスと待ち受けポートを表示します。",
        summary: "プロセス: %d · TCP待ち受け: %d · 要確認: %d",
        listenerReadFailed: "TCP待ち受け情報を完全に読み取れませんでした。一覧にないポートがある場合があります。",
        partial: "取得できない情報や不完全な情報があります。「未確認」フィルタを確認してください。TCPポート一覧も一部のみの場合があります。",
        valid: "識別署名は有効",
        adHoc: "アドホック署名",
        unsigned: "署名なし",
        invalid: "識別署名は無効",
        unavailable: "署名を確認できません",
        local: "このMacのみ",
        network: "ネットワークインターフェイス",
        unknownScope: "範囲不明",
        invalidReason: "プロセスの識別署名の検証に失敗しました。アプリの入手元を確認してください。これだけでマルウェアとは判断できません。",
        unsignedNetworkReason: "署名なし、またはアドホック署名のプロセスがネットワークで待ち受けています。開発ツールでは正常な場合があります。",
        temporaryReason: "一時フォルダ内の実行ファイルがネットワークで待ち受けています。実行する予定だったか確認してください。",
        identityChanged: "プロセスが終了、変更されたか、識別情報を確認できませんでした。再スキャンしてください。",
        failed: "プロセスを読み取れませんでした。再試行してください。"
    )

    static let ko = SecurityScanFeatureStrings(
        title: "보안",
        hubDescription: "프로세스, 식별 서명 및 수신 대기 TCP 포트를 수동으로 확인",
        scan: "지금 검사",
        scanning: "검사 중…",
        scope: "사용자 권한으로 읽는 로컬 스냅샷입니다. macOS가 일부 데이터를 숨길 수 있습니다. 식별 서명을 확인하며 모든 파일이나 악성 코드를 검사하지는 않습니다. 네트워크 수신 대기는 접근 가능성을 보장하지 않습니다.",
        filter: "이름, PID, 경로 또는 포트 검색",
        all: "전체",
        review: "검토",
        listeners: "TCP 수신",
        incomplete: "불완전",
        empty: "일치하는 프로세스가 없습니다.",
        ready: "수동 검사를 시작하여 프로세스와 수신 대기 포트를 확인하세요.",
        summary: "프로세스: %d · TCP 수신: %d · 검토: %d",
        listenerReadFailed: "TCP 수신 대기 정보를 모두 읽지 못했습니다. 목록에 일부 포트가 없을 수 있습니다.",
        partial: "일부 정보를 읽지 못했거나 불완전합니다. 불완전 필터를 확인하세요. TCP 포트 목록도 일부만 표시될 수 있습니다.",
        valid: "식별 서명 유효",
        adHoc: "애드혹 서명",
        unsigned: "서명 없음",
        invalid: "식별 서명 무효",
        unavailable: "서명 확인 불가",
        local: "이 Mac만",
        network: "네트워크 인터페이스",
        unknownScope: "범위 알 수 없음",
        invalidReason: "프로세스의 식별 서명 검증에 실패했습니다. 앱의 출처를 확인하세요. 이것만으로 악성 코드라고 판단할 수는 없습니다.",
        unsignedNetworkReason: "서명되지 않았거나 애드혹 서명된 프로세스가 네트워크에서 수신 대기 중입니다. 개발 도구에서는 정상일 수 있습니다.",
        temporaryReason: "임시 폴더의 실행 파일이 네트워크에서 수신 대기 중입니다. 실행하려던 프로그램인지 확인하세요.",
        identityChanged: "프로세스가 종료되거나 변경되었거나 식별 정보를 확인할 수 없습니다. 다시 검사하세요.",
        failed: "프로세스를 읽지 못했습니다. 다시 시도하세요."
    )

    static let zhHans = SecurityScanFeatureStrings(
        title: "安全",
        hubDescription: "手动检查进程、身份签名和监听中的 TCP 端口",
        scan: "立即扫描",
        scanning: "扫描中…",
        scope: "使用当前用户权限获取本地快照；macOS 可能隐藏部分数据。检查身份签名，不检查所有应用文件或恶意软件。网络监听不代表端口可从外部访问。",
        filter: "搜索名称、PID、路径或端口",
        all: "全部",
        review: "待检查",
        listeners: "TCP 监听",
        incomplete: "不完整",
        empty: "没有匹配的进程。",
        ready: "开始手动扫描以查看进程和监听端口。",
        summary: "进程：%d · TCP 监听：%d · 待检查：%d",
        listenerReadFailed: "无法完整读取 TCP 监听信息。列表中可能缺少部分端口。",
        partial: "部分数据不可用或不完整。请查看“不完整”筛选；TCP 端口列表也可能不完整。",
        valid: "身份签名有效",
        adHoc: "临时签名",
        unsigned: "未签名",
        invalid: "身份签名无效",
        unavailable: "签名不可用",
        local: "仅此 Mac",
        network: "网络接口",
        unknownScope: "范围未知",
        invalidReason: "进程的身份签名验证失败。请检查应用来源；仅凭这一点不能判断为恶意软件。",
        unsignedNetworkReason: "未签名或使用临时签名的进程正在网络接口上监听。开发工具出现此情况可能是正常的。",
        temporaryReason: "临时文件夹中的可执行文件正在网络接口上监听。请确认是否是您计划运行的程序。",
        identityChanged: "进程已结束、发生变化或无法验证身份。请重新扫描。",
        failed: "无法读取进程。请重试。"
    )

    static let zhTW = SecurityScanFeatureStrings(
        title: "安全性",
        hubDescription: "手動檢查程序、身分簽章和監聽中的 TCP 連接埠",
        scan: "立即掃描",
        scanning: "掃描中…",
        scope: "使用目前使用者權限取得本機快照；macOS 可能隱藏部分資料。檢查身分簽章，不檢查所有 App 檔案或惡意軟體。網路監聽不代表外部可以連線。",
        filter: "搜尋名稱、PID、路徑或連接埠",
        all: "全部",
        review: "待檢查",
        listeners: "TCP 監聽",
        incomplete: "不完整",
        empty: "沒有符合的程序。",
        ready: "開始手動掃描以查看程序和監聽連接埠。",
        summary: "程序：%d · TCP 監聽：%d · 待檢查：%d",
        listenerReadFailed: "無法完整讀取 TCP 監聽資訊。清單中可能缺少部分連接埠。",
        partial: "部分資料無法取得或不完整。請查看「不完整」篩選；TCP 連接埠清單也可能不完整。",
        valid: "身分簽章有效",
        adHoc: "臨時簽章",
        unsigned: "未簽署",
        invalid: "身分簽章無效",
        unavailable: "簽章無法取得",
        local: "僅此 Mac",
        network: "網路介面",
        unknownScope: "範圍未知",
        invalidReason: "程序的身分簽章驗證失敗。請檢查 App 來源；僅憑這一點無法判定為惡意軟體。",
        unsignedNetworkReason: "未簽署或使用臨時簽章的程序正在網路介面上監聽。開發工具出現此情況可能是正常的。",
        temporaryReason: "暫存資料夾中的執行檔正在網路介面上監聽。請確認是否為您打算執行的程式。",
        identityChanged: "程序已結束、發生變化或無法驗證身分。請重新掃描。",
        failed: "無法讀取程序。請重試。"
    )

    static let zhHK = SecurityScanFeatureStrings(
        title: "安全性",
        hubDescription: "手動檢查程序、身份簽章和監聽中的 TCP 連接埠",
        scan: "立即掃描",
        scanning: "掃描中…",
        scope: "使用目前使用者權限取得本機快照；macOS 可能隱藏部分資料。檢查身份簽章，不檢查所有 App 檔案或惡意軟件。網絡監聽不代表外部可以連線。",
        filter: "搜尋名稱、PID、路徑或連接埠",
        all: "全部",
        review: "待檢查",
        listeners: "TCP 監聽",
        incomplete: "不完整",
        empty: "沒有符合的程序。",
        ready: "開始手動掃描以查看程序和監聽連接埠。",
        summary: "程序：%d · TCP 監聽：%d · 待檢查：%d",
        listenerReadFailed: "無法完整讀取 TCP 監聽資訊。清單中可能缺少部分連接埠。",
        partial: "部分資料無法取得或不完整。請查看「不完整」篩選；TCP 連接埠清單也可能不完整。",
        valid: "身份簽章有效",
        adHoc: "臨時簽章",
        unsigned: "未簽署",
        invalid: "身份簽章無效",
        unavailable: "簽章無法取得",
        local: "僅此 Mac",
        network: "網絡介面",
        unknownScope: "範圍未知",
        invalidReason: "程序的身份簽章驗證失敗。請檢查 App 來源；僅憑這一點無法判定為惡意軟件。",
        unsignedNetworkReason: "未簽署或使用臨時簽章的程序正在網絡介面上監聽。開發工具出現此情況可能是正常的。",
        temporaryReason: "暫存資料夾中的執行檔正在網絡介面上監聽。請確認是否為你打算執行的程式。",
        identityChanged: "程序已結束、發生變化或無法驗證身份。請重新掃描。",
        failed: "無法讀取程序。請重試。"
    )

}

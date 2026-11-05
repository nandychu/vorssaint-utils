// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

struct AudioEqualizerFeatureStrings {
    let title: String
    let description: String
    let enabled: String
    let output: String
    let preset: String
    let preamp: String
    let bands: String
    let save: String
    let name: String
    let delete: String
    let reset: String
    let flat: String
    let bass: String
    let voice: String
    let treble: String
    let custom: String
    let mixerRequired: String
    let scope: String
    let noOutput: String
    let permission: String
    let settings: String
    let deviceHint: String
    let autoPreamp: String
    let autoPreampHint: String
}

extension FeatureStrings {
    static func audioEqualizer(_ language: AppLanguage) -> AudioEqualizerFeatureStrings {
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

extension AudioEqualizerFeatureStrings {
    static let enUS = AudioEqualizerFeatureStrings(
        title: "Equalizer",
        description: "Ten audio bands, preamp, and presets remembered for each output device",
        enabled: "Enable equalizer",
        output: "Output device",
        preset: "Preset",
        preamp: "Preamp",
        bands: "Frequency bands",
        save: "Save preset",
        name: "Preset name",
        delete: "Delete preset",
        reset: "Reset to flat",
        flat: "Flat",
        bass: "Bass boost",
        voice: "Voice",
        treble: "Treble boost",
        custom: "Custom",
        mixerRequired: "Install Volume mixer in Features to use the equalizer.",
        scope: "Applies to Volume mixer apps on physical outputs. Hidden apps, protected call apps, and audio routed separately by an app remain outside this module.",
        noOutput: "No supported output is available.",
        permission: "Audio processing could not start. Check System Audio Recording permission, then turn the equalizer off and on again.",
        settings: "Open audio permissions",
        deviceHint: "Choose an output to edit its profile. Its settings apply whenever Vorssaint plays audio through that device.",
        autoPreamp: "Auto preamp",
        autoPreampHint: "Uses fixed headroom for boosted bands without compressing the music. When off, lower the preamp if boosts distort."
    )

    static let es = AudioEqualizerFeatureStrings(
        title: "Ecualizador",
        description: "Diez bandas, preamplificador y presets recordados para cada dispositivo de salida",
        enabled: "Activar ecualizador",
        output: "Dispositivo de salida",
        preset: "Preset",
        preamp: "Preamplificador",
        bands: "Bandas de frecuencia",
        save: "Guardar preset",
        name: "Nombre del preset",
        delete: "Eliminar preset",
        reset: "Restablecer a plano",
        flat: "Plano",
        bass: "Refuerzo de graves",
        voice: "Voz",
        treble: "Refuerzo de agudos",
        custom: "Personalizado",
        mixerRequired: "Instala Mezclador de volumen en Funciones para usar el ecualizador.",
        scope: "Se aplica a las apps del mezclador en salidas físicas. Las apps ocultas, las llamadas protegidas y el audio que una app dirige por separado quedan fuera del módulo.",
        noOutput: "No hay ninguna salida compatible disponible.",
        permission: "No se pudo iniciar el procesamiento de audio. Revisa el permiso de grabación de audio del sistema y vuelve a desactivar y activar el ecualizador.",
        settings: "Abrir permisos de audio",
        deviceHint: "Elige una salida para editar su perfil. Sus ajustes se aplican cuando Vorssaint reproduce audio por ese dispositivo.",
        autoPreamp: "Preamp. automático",
        autoPreampHint: "Deja margen fijo para las bandas reforzadas sin comprimir la música. Si está desactivado y los refuerzos distorsionan, baja el preamplificador."
    )

    static let ptBR = AudioEqualizerFeatureStrings(
        title: "Equalizador",
        description: "Dez bandas, pré-amplificador e predefinições para cada saída de áudio",
        enabled: "Ativar equalizador",
        output: "Dispositivo de saída",
        preset: "Predefinição",
        preamp: "Pré-amplificador",
        bands: "Bandas de frequência",
        save: "Salvar predefinição",
        name: "Nome da predefinição",
        delete: "Excluir predefinição",
        reset: "Redefinir para plano",
        flat: "Plano",
        bass: "Reforço de graves",
        voice: "Voz",
        treble: "Reforço de agudos",
        custom: "Personalizado",
        mixerRequired: "Instale o Mixer de volume em Recursos para usar o equalizador.",
        scope: "Aplica-se aos apps do mixer em saídas físicas. Apps ocultos, chamadas protegidas e áudio roteado separadamente pelo app ficam fora do módulo.",
        noOutput: "Nenhuma saída compatível disponível.",
        permission: "Não foi possível iniciar o processamento. Verifique a permissão de gravação de áudio do sistema e desative e reative o equalizador.",
        settings: "Abrir permissões de áudio",
        deviceHint: "Escolha uma saída para editar seu perfil. As configurações são aplicadas quando o Vorssaint reproduz áudio nesse dispositivo.",
        autoPreamp: "Pré-amplificador automático",
        autoPreampHint: "Reserva margem fixa para bandas reforçadas sem comprimir a música. Quando desativado, reduza o pré-amplificador se houver distorção."
    )

    static let de = AudioEqualizerFeatureStrings(
        title: "Equalizer",
        description: "Zehn Bänder, Vorverstärkung und Presets für jedes Ausgabegerät",
        enabled: "Equalizer aktivieren",
        output: "Ausgabegerät",
        preset: "Preset",
        preamp: "Vorverstärkung",
        bands: "Frequenzbänder",
        save: "Preset speichern",
        name: "Preset-Name",
        delete: "Preset löschen",
        reset: "Auf neutral zurücksetzen",
        flat: "Neutral",
        bass: "Bassverstärkung",
        voice: "Stimme",
        treble: "Höhenverstärkung",
        custom: "Benutzerdefiniert",
        mixerRequired: "Installiere den Lautstärkemixer unter Funktionen, um den Equalizer zu verwenden.",
        scope: "Gilt für Mixer-Apps auf physischen Ausgängen. Ausgeblendete Apps, geschützte Anruf-Apps und separat geroutetes Audio bleiben ausgenommen.",
        noOutput: "Kein unterstützter Ausgang verfügbar.",
        permission: "Audioverarbeitung konnte nicht starten. Prüfe die Berechtigung zur Systemaudioaufnahme und schalte den Equalizer aus und wieder ein.",
        settings: "Audioberechtigungen öffnen",
        deviceHint: "Wähle einen Ausgang zum Bearbeiten seines Profils. Die Einstellungen gelten, wenn Vorssaint Audio über dieses Gerät wiedergibt.",
        autoPreamp: "Automatische Vorverstärkung",
        autoPreampHint: "Schafft festen Pegelspielraum für angehobene Bänder, ohne die Musik zu komprimieren. Falls deaktiviert, bei Verzerrung die Vorverstärkung senken."
    )

    static let fr = AudioEqualizerFeatureStrings(
        title: "Égaliseur",
        description: "Dix bandes, préampli et préréglages mémorisés pour chaque sortie",
        enabled: "Activer l’égaliseur",
        output: "Périphérique de sortie",
        preset: "Préréglage",
        preamp: "Préampli",
        bands: "Bandes de fréquences",
        save: "Enregistrer le préréglage",
        name: "Nom du préréglage",
        delete: "Supprimer le préréglage",
        reset: "Réinitialiser à neutre",
        flat: "Neutre",
        bass: "Renfort des basses",
        voice: "Voix",
        treble: "Renfort des aigus",
        custom: "Personnalisé",
        mixerRequired: "Installez le Mélangeur de volume dans Fonctionnalités pour utiliser l’égaliseur.",
        scope: "S’applique aux apps du mélangeur sur les sorties physiques. Les apps masquées, les appels protégés et l’audio routé séparément sont exclus.",
        noOutput: "Aucune sortie compatible disponible.",
        permission: "Le traitement audio n’a pas démarré. Vérifiez l’autorisation d’enregistrement audio du système, puis désactivez et réactivez l’égaliseur.",
        settings: "Ouvrir les autorisations audio",
        deviceHint: "Choisissez une sortie pour modifier son profil. Ses réglages s’appliquent lorsque Vorssaint diffuse du son sur ce périphérique.",
        autoPreamp: "Préampli automatique",
        autoPreampHint: "Préserve une marge fixe pour les bandes amplifiées sans compresser la musique. Si désactivé, baissez le préampli en cas de distorsion."
    )

    static let it = AudioEqualizerFeatureStrings(
        title: "Equalizzatore",
        description: "Dieci bande, preamplificatore e preset memorizzati per ogni uscita",
        enabled: "Attiva equalizzatore",
        output: "Dispositivo di uscita",
        preset: "Preset",
        preamp: "Preamplificatore",
        bands: "Bande di frequenza",
        save: "Salva preset",
        name: "Nome del preset",
        delete: "Elimina preset",
        reset: "Ripristina neutro",
        flat: "Neutro",
        bass: "Enfasi bassi",
        voice: "Voce",
        treble: "Enfasi alti",
        custom: "Personalizzato",
        mixerRequired: "Installa Mixer volume in Funzioni per usare l’equalizzatore.",
        scope: "Si applica alle app del mixer sulle uscite fisiche. App nascoste, chiamate protette e audio instradato separatamente sono esclusi.",
        noOutput: "Nessuna uscita compatibile disponibile.",
        permission: "Impossibile avviare l’elaborazione audio. Controlla il permesso di registrazione audio di sistema, poi disattiva e riattiva l’equalizzatore.",
        settings: "Apri permessi audio",
        deviceHint: "Scegli un’uscita per modificarne il profilo. Le impostazioni si applicano quando Vorssaint riproduce audio su quel dispositivo.",
        autoPreamp: "Preamplificatore automatico",
        autoPreampHint: "Mantiene un margine fisso per le bande amplificate senza comprimere la musica. Se disattivato, riduci il preamplificatore in caso di distorsione."
    )

    static let sk = AudioEqualizerFeatureStrings(
        title: "Ekvalizér",
        description: "Desať pásiem, predzosilňovač a predvoľby pre každý výstup",
        enabled: "Zapnúť ekvalizér",
        output: "Výstupné zariadenie",
        preset: "Predvoľba",
        preamp: "Predzosilňovač",
        bands: "Frekvenčné pásma",
        save: "Uložiť predvoľbu",
        name: "Názov predvoľby",
        delete: "Odstrániť predvoľbu",
        reset: "Obnoviť neutrálne",
        flat: "Neutrálne",
        bass: "Zvýraznenie basov",
        voice: "Hlas",
        treble: "Zvýraznenie výšok",
        custom: "Vlastné",
        mixerRequired: "Ak chcete používať ekvalizér, nainštalujte Mixér hlasitosti v časti Funkcie.",
        scope: "Platí pre aplikácie mixéra na fyzických výstupoch. Skryté aplikácie, chránené hovory a samostatne smerovaný zvuk sú vynechané.",
        noOutput: "Nie je dostupný podporovaný výstup.",
        permission: "Spracovanie zvuku sa nespustilo. Skontrolujte povolenie na nahrávanie systémového zvuku a vypnite a znova zapnite ekvalizér.",
        settings: "Otvoriť povolenia zvuku",
        deviceHint: "Vyberte výstup na úpravu profilu. Nastavenia platia, keď Vorssaint prehráva zvuk cez toto zariadenie.",
        autoPreamp: "Automatický predzosilňovač",
        autoPreampHint: "Ponecháva pevnú rezervu pre zosilnené pásma bez kompresie hudby. Pri vypnutí znížte predzosilnenie, ak zvuk skresľuje."
    )

    static let ru = AudioEqualizerFeatureStrings(
        title: "Эквалайзер",
        description: "Десять полос, предусилитель и пресеты для каждого устройства вывода",
        enabled: "Включить эквалайзер",
        output: "Устройство вывода",
        preset: "Пресет",
        preamp: "Предусилитель",
        bands: "Полосы частот",
        save: "Сохранить пресет",
        name: "Название пресета",
        delete: "Удалить пресет",
        reset: "Сбросить к нейтральному",
        flat: "Нейтральный",
        bass: "Усиление басов",
        voice: "Голос",
        treble: "Усиление высоких",
        custom: "Свой",
        mixerRequired: "Установите Микшер громкости в разделе Функции для работы эквалайзера.",
        scope: "Применяется к приложениям микшера на физических выходах. Скрытые приложения, защищённые звонки и отдельно направляемый звук исключены.",
        noOutput: "Нет поддерживаемого выхода.",
        permission: "Не удалось начать обработку звука. Проверьте разрешение на запись системного аудио, затем выключите и включите эквалайзер.",
        settings: "Открыть разрешения аудио",
        deviceHint: "Выберите выход для настройки профиля. Настройки применяются, когда Vorssaint воспроизводит звук через это устройство.",
        autoPreamp: "Автопредусиление",
        autoPreampHint: "Оставляет постоянный запас для усиленных полос без сжатия музыки. Если выключено, уменьшите предусиление при искажениях."
    )

    static let uk = AudioEqualizerFeatureStrings(
        title: "Еквалайзер",
        description: "Десять смуг, передпідсилювач і пресети для кожного пристрою виведення",
        enabled: "Увімкнути еквалайзер",
        output: "Пристрій виведення",
        preset: "Пресет",
        preamp: "Передпідсилювач",
        bands: "Смуги частот",
        save: "Зберегти пресет",
        name: "Назва пресету",
        delete: "Видалити пресет",
        reset: "Скинути до нейтрального",
        flat: "Нейтральний",
        bass: "Підсилення басів",
        voice: "Голос",
        treble: "Підсилення високих",
        custom: "Власний",
        mixerRequired: "Установіть Мікшер гучності в розділі Функції для роботи еквалайзера.",
        scope: "Застосовується до застосунків мікшера на фізичних виходах. Приховані застосунки, захищені дзвінки й окремо спрямований звук виключені.",
        noOutput: "Немає підтримуваного виходу.",
        permission: "Не вдалося почати обробку звуку. Перевірте дозвіл на запис системного аудіо, а потім вимкніть і ввімкніть еквалайзер.",
        settings: "Відкрити дозволи аудіо",
        deviceHint: "Виберіть вихід для редагування профілю. Налаштування діють, коли Vorssaint відтворює звук через цей пристрій.",
        autoPreamp: "Автопідсилення",
        autoPreampHint: "Залишає постійний запас для підсилених смуг без стискання музики. Якщо вимкнено, зменште підсилення за наявності спотворень."
    )

    static let tr = AudioEqualizerFeatureStrings(
        title: "Ekolayzır",
        description: "Her çıkış aygıtı için on bant, ön yükseltici ve kayıtlı ön ayarlar",
        enabled: "Ekolayzırı etkinleştir",
        output: "Çıkış aygıtı",
        preset: "Ön ayar",
        preamp: "Ön yükseltici",
        bands: "Frekans bantları",
        save: "Ön ayarı kaydet",
        name: "Ön ayar adı",
        delete: "Ön ayarı sil",
        reset: "Düz ayara sıfırla",
        flat: "Düz",
        bass: "Bas artırma",
        voice: "Ses",
        treble: "Tiz artırma",
        custom: "Özel",
        mixerRequired: "Ekolayzırı kullanmak için Özellikler bölümünden Ses mikserini yükleyin.",
        scope: "Fiziksel çıkışlardaki mikser uygulamalarına uygulanır. Gizli uygulamalar, korunan aramalar ve ayrı yönlendirilen ses kapsam dışıdır.",
        noOutput: "Desteklenen çıkış yok.",
        permission: "Ses işleme başlatılamadı. Sistem sesi kaydı iznini kontrol edip ekolayzırı kapatıp açın.",
        settings: "Ses izinlerini aç",
        deviceHint: "Profilini düzenlemek için bir çıkış seçin. Ayarlar, Vorssaint o aygıttan ses çalarken uygulanır.",
        autoPreamp: "Otomatik ön yükseltme",
        autoPreampHint: "Müziği sıkıştırmadan yükseltilen bantlar için sabit pay bırakır. Kapalıyken bozulma olursa ön yükseltmeyi azaltın."
    )

    static let ja = AudioEqualizerFeatureStrings(
        title: "イコライザ",
        description: "10バンド、プリアンプ、出力デバイスごとに記憶するプリセット",
        enabled: "イコライザを有効にする",
        output: "出力デバイス",
        preset: "プリセット",
        preamp: "プリアンプ",
        bands: "周波数バンド",
        save: "プリセットを保存",
        name: "プリセット名",
        delete: "プリセットを削除",
        reset: "フラットに戻す",
        flat: "フラット",
        bass: "低音強調",
        voice: "音声",
        treble: "高音強調",
        custom: "カスタム",
        mixerRequired: "イコライザを使うには「機能」で音量ミキサーをインストールしてください。",
        scope: "物理出力を使うミキサー対象アプリに適用します。非表示アプリ、保護された通話、アプリが個別に出力する音声は対象外です。",
        noOutput: "対応する出力がありません。",
        permission: "音声処理を開始できませんでした。システム音声の録音権限を確認し、イコライザをオフにしてからオンにしてください。",
        settings: "音声の権限を開く",
        deviceHint: "出力を選んでプロファイルを編集します。Vorssaintがそのデバイスで再生すると設定が適用されます。",
        autoPreamp: "自動プリアンプ",
        autoPreampHint: "音楽を圧縮せず、強調した帯域に一定の余裕を確保します。オフで音が歪む場合はプリアンプを下げてください。"
    )

    static let ko = AudioEqualizerFeatureStrings(
        title: "이퀄라이저",
        description: "출력 장치별로 기억하는 10개 밴드, 프리앰프 및 프리셋",
        enabled: "이퀄라이저 활성화",
        output: "출력 장치",
        preset: "프리셋",
        preamp: "프리앰프",
        bands: "주파수 밴드",
        save: "프리셋 저장",
        name: "프리셋 이름",
        delete: "프리셋 삭제",
        reset: "플랫으로 초기화",
        flat: "플랫",
        bass: "저음 강조",
        voice: "음성",
        treble: "고음 강조",
        custom: "사용자 설정",
        mixerRequired: "이퀄라이저를 사용하려면 기능에서 볼륨 믹서를 설치하세요.",
        scope: "물리적 출력을 사용하는 믹서 앱에 적용됩니다. 숨긴 앱, 보호된 통화 및 앱이 별도로 출력하는 오디오는 제외됩니다.",
        noOutput: "지원되는 출력이 없습니다.",
        permission: "오디오 처리를 시작하지 못했습니다. 시스템 오디오 녹음 권한을 확인한 후 이퀄라이저를 껐다 켜세요.",
        settings: "오디오 권한 열기",
        deviceHint: "출력을 선택하여 프로필을 편집하세요. Vorssaint가 해당 장치로 오디오를 재생할 때 설정이 적용됩니다.",
        autoPreamp: "자동 프리앰프",
        autoPreampHint: "음악을 압축하지 않고 증폭된 대역에 일정한 여유를 확보합니다. 꺼진 상태에서 소리가 왜곡되면 프리앰프를 낮추세요."
    )

    static let zhHans = AudioEqualizerFeatureStrings(
        title: "均衡器",
        description: "十个频段、前置增益及按输出设备记忆的预设",
        enabled: "启用均衡器",
        output: "输出设备",
        preset: "预设",
        preamp: "前置增益",
        bands: "频段",
        save: "保存预设",
        name: "预设名称",
        delete: "删除预设",
        reset: "重置为平直",
        flat: "平直",
        bass: "低音增强",
        voice: "人声",
        treble: "高音增强",
        custom: "自定义",
        mixerRequired: "请在“功能”中安装音量混音器以使用均衡器。",
        scope: "适用于通过物理输出播放的混音器应用。隐藏应用、受保护通话及应用单独路由的音频不在范围内。",
        noOutput: "没有可用的受支持输出。",
        permission: "无法启动音频处理。请检查系统音频录制权限，然后关闭并重新开启均衡器。",
        settings: "打开音频权限",
        deviceHint: "选择输出以编辑其配置。Vorssaint 通过该设备播放音频时会应用这些设置。",
        autoPreamp: "自动前置增益",
        autoPreampHint: "为增强的频段预留固定余量，不压缩音乐。关闭时若出现失真，请降低前置增益。"
    )

    static let zhTW = AudioEqualizerFeatureStrings(
        title: "等化器",
        description: "十個頻段、前級增益及按輸出裝置記憶的預設",
        enabled: "啟用等化器",
        output: "輸出裝置",
        preset: "預設",
        preamp: "前級增益",
        bands: "頻段",
        save: "儲存預設",
        name: "預設名稱",
        delete: "刪除預設",
        reset: "重設為平直",
        flat: "平直",
        bass: "低音增強",
        voice: "人聲",
        treble: "高音增強",
        custom: "自訂",
        mixerRequired: "請在「功能」中安裝音量混音器以使用等化器。",
        scope: "適用於透過實體輸出播放的混音器 App。隱藏 App、受保護通話及 App 個別路由的音訊不在範圍內。",
        noOutput: "沒有可用的支援輸出。",
        permission: "無法啟動音訊處理。請檢查系統音訊錄製權限，再關閉並重新開啟等化器。",
        settings: "開啟音訊權限",
        deviceHint: "選擇輸出以編輯其設定檔。Vorssaint 透過該裝置播放音訊時會套用這些設定。",
        autoPreamp: "自動前級增益",
        autoPreampHint: "為增強的頻段保留固定餘裕，不壓縮音樂。關閉時若出現失真，請降低前級增益。"
    )

    static let zhHK = AudioEqualizerFeatureStrings(
        title: "等化器",
        description: "十個頻段、前級增益及按輸出裝置記憶的預設",
        enabled: "啟用等化器",
        output: "輸出裝置",
        preset: "預設",
        preamp: "前級增益",
        bands: "頻段",
        save: "儲存預設",
        name: "預設名稱",
        delete: "刪除預設",
        reset: "重設為平直",
        flat: "平直",
        bass: "低音增強",
        voice: "人聲",
        treble: "高音增強",
        custom: "自訂",
        mixerRequired: "請在「功能」中安裝音量混音器以使用等化器。",
        scope: "適用於透過實體輸出播放的混音器 App。隱藏 App、受保護通話及 App 個別路由的音訊不在範圍內。",
        noOutput: "沒有可用的支援輸出。",
        permission: "無法啟動音訊處理。請檢查系統音訊錄製權限，再關閉並重新開啟等化器。",
        settings: "開啟音訊權限",
        deviceHint: "選擇輸出以編輯其設定檔。Vorssaint 透過該裝置播放音訊時會套用這些設定。",
        autoPreamp: "自動前級增益",
        autoPreampHint: "為增強的頻段保留固定餘裕，不壓縮音樂。關閉時若出現失真，請降低前級增益。"
    )

}

struct AudioEqualizerPlaybackStrings {
    let off: String
    let waiting: String
    let processing: String
    let differentOutput: String
}

extension FeatureStrings {
    static func audioEqualizerPlayback(_ language: AppLanguage) -> AudioEqualizerPlaybackStrings {
        switch language {
        case .enUS:
            return .init(off: "Equalizer off",
                         waiting: "Waiting for audio on this output",
                         processing: "Processing",
                         differentOutput: "The system is using another output. Select a physical output in Sound settings to hear this profile.")
        case .es:
            return .init(off: "Ecualizador desactivado",
                         waiting: "Esperando audio en esta salida",
                         processing: "Procesando",
                         differentOutput: "El sistema usa otra salida. Selecciona una salida física en los ajustes de Sonido para escuchar este perfil.")
        case .ptBR:
            return .init(off: "Equalizador desativado",
                         waiting: "Aguardando áudio nesta saída",
                         processing: "Processando",
                         differentOutput: "O sistema usa outra saída. Selecione uma saída física nos ajustes de Som para ouvir este perfil.")
        case .de:
            return .init(off: "Equalizer aus",
                         waiting: "Warte auf Audio an diesem Ausgang",
                         processing: "Verarbeitung",
                         differentOutput: "Das System verwendet einen anderen Ausgang. Wähle in den Toneinstellungen einen physischen Ausgang, um dieses Profil zu hören.")
        case .fr:
            return .init(off: "Égaliseur désactivé",
                         waiting: "En attente d’audio sur cette sortie",
                         processing: "Traitement",
                         differentOutput: "Le système utilise une autre sortie. Sélectionnez une sortie physique dans les réglages Son pour entendre ce profil.")
        case .it:
            return .init(off: "Equalizzatore disattivato",
                         waiting: "In attesa di audio su questa uscita",
                         processing: "Elaborazione",
                         differentOutput: "Il sistema usa un’altra uscita. Seleziona un’uscita fisica nelle impostazioni Suono per ascoltare questo profilo.")
        case .sk:
            return .init(off: "Ekvalizér vypnutý",
                         waiting: "Čaká sa na zvuk na tomto výstupe",
                         processing: "Spracovanie",
                         differentOutput: "Systém používa iný výstup. V nastaveniach zvuku vyberte fyzický výstup, aby ste počuli tento profil.")
        case .ru:
            return .init(off: "Эквалайзер выключен",
                         waiting: "Ожидание звука на этом выходе",
                         processing: "Обработка",
                         differentOutput: "Система использует другой выход. Выберите физический выход в настройках звука, чтобы услышать этот профиль.")
        case .uk:
            return .init(off: "Еквалайзер вимкнено",
                         waiting: "Очікування звуку на цьому виході",
                         processing: "Обробка",
                         differentOutput: "Система використовує інший вихід. Виберіть фізичний вихід у налаштуваннях звуку, щоб почути цей профіль.")
        case .tr:
            return .init(off: "Ekolayzır kapalı",
                         waiting: "Bu çıkışta ses bekleniyor",
                         processing: "İşleniyor",
                         differentOutput: "Sistem başka bir çıkış kullanıyor. Bu profili duymak için Ses ayarlarında fiziksel bir çıkış seçin.")
        case .ja:
            return .init(off: "イコライザはオフです",
                         waiting: "この出力の音声を待機中",
                         processing: "処理中",
                         differentOutput: "システムは別の出力を使用しています。このプロファイルを聴くには、サウンド設定で物理出力を選択してください。")
        case .ko:
            return .init(off: "이퀄라이저 꺼짐",
                         waiting: "이 출력의 오디오 대기 중",
                         processing: "처리 중",
                         differentOutput: "시스템에서 다른 출력을 사용하고 있습니다. 이 프로필을 들으려면 사운드 설정에서 물리적 출력을 선택하세요.")
        case .zhHans:
            return .init(off: "均衡器已关闭",
                         waiting: "正在等待此输出的音频",
                         processing: "正在处理",
                         differentOutput: "系统正在使用其他输出。请在声音设置中选择物理输出以聆听此配置。")
        case .zhTW:
            return .init(off: "等化器已關閉",
                         waiting: "正在等待此輸出的音訊",
                         processing: "正在處理",
                         differentOutput: "系統正在使用其他輸出。請在聲音設定中選擇實體輸出以聆聽此設定檔。")
        case .zhHK:
            return .init(off: "等化器已關閉",
                         waiting: "正在等待此輸出的音訊",
                         processing: "正在處理",
                         differentOutput: "系統正在使用其他輸出。請在聲音設定中選擇實體輸出以聆聽此設定檔。")
        }
    }
}

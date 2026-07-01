import AVFoundation

final class SpeechService {
    static let shared = SpeechService()

    private let synthesizer = AVSpeechSynthesizer()
    private let voice = AVSpeechSynthesisVoice(language: "pt-BR")

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        #if canImport(UIKit)
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .spokenAudio,
                options: [.duckOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print("SpeechService: erro ao configurar áudio -", error.localizedDescription)
        }
        #endif
    }

    func speak(_ text: String, rate: Float = AVSpeechUtteranceDefaultSpeechRate * 0.9) {
        guard !text.isEmpty else { return }
        stop()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice ?? AVSpeechSynthesisVoice(language: "pt-BR")
        utterance.rate = rate
        utterance.pitchMultiplier = 1.15
        utterance.postUtteranceDelay = 0.05
        synthesizer.speak(utterance)
    }

    func speakLetter(_ letter: Letter) {
        speak(letter.pronunciation, rate: AVSpeechUtteranceDefaultSpeechRate * 0.8)
    }

    func speakSyllable(_ syllable: String) {
        speak(syllable, rate: AVSpeechUtteranceDefaultSpeechRate * 0.75)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

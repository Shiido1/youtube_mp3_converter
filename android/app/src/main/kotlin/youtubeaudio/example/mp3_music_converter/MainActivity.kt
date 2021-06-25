package youtubeaudio.example.mp3_music_converter
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var sharedData: String = ""

    override fun onCreate(
            savedInstanceState: Bundle?
    ) {
        super.onCreate(savedInstanceState)
        handleIntent()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
                "youtubeaudio.example.mp3_music_converter").setMethodCallHandler { call, result ->
            if (call.method == "getSharedData") {
                handleIntent()
                result.success(sharedData)
                sharedData = ""
            }
        }
    }


    private fun handleIntent() {
        // intent is a property of this activity
        // Only process the intent if it's a send intent and it's of type 'text'
        if (intent?.action == Intent.ACTION_VIEW || intent?.action == Intent.ACTION_SEND ) {
            intent.getStringExtra(Intent.EXTRA_TEXT)?.let { intentData ->
                sharedData = intentData
            }
        }
    }
}

package com.example.location_with_restapi
import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setLocale("en_US")
        MapKitFactory.setApiKey("118ed405-ab3e-45eb-b494-254aeb6d6b11") // Your generated API key
    }
}
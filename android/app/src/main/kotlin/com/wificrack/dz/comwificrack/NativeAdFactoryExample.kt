package com.wificrack.dz.comwificrack

import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryExample(
  private val layoutInflater: LayoutInflater,
) : NativeAdFactory {
  override fun createNativeAd(
    nativeAd: NativeAd,
    customOptions: MutableMap<String, Any>?,
  ): NativeAdView {
    val adView = layoutInflater.inflate(R.layout.native_ad_layout, null) as NativeAdView

    adView.mediaView = adView.findViewById<MediaView>(R.id.ad_media)
    adView.headlineView = adView.findViewById(R.id.ad_headline)
    adView.bodyView = adView.findViewById(R.id.ad_body)
    adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
    adView.iconView = adView.findViewById(R.id.ad_app_icon)
    adView.priceView = adView.findViewById(R.id.ad_price)
    adView.starRatingView = adView.findViewById(R.id.ad_stars)
    adView.storeView = adView.findViewById(R.id.ad_store)
    adView.advertiserView = adView.findViewById(R.id.ad_advertiser)

    (adView.headlineView as TextView).text = nativeAd.headline
    adView.mediaView?.mediaContent = nativeAd.mediaContent

    bindText(adView.bodyView as TextView, nativeAd.body)
    bindButton(adView.callToActionView as Button, nativeAd.callToAction)

    val iconView = adView.iconView as ImageView
    val iconDrawable = nativeAd.icon?.drawable
    if (iconDrawable == null) {
      iconView.visibility = View.GONE
    } else {
      iconView.setImageDrawable(iconDrawable)
      iconView.visibility = View.VISIBLE
    }

    bindText(adView.priceView as TextView, nativeAd.price)
    bindText(adView.storeView as TextView, nativeAd.store)
    bindText(adView.advertiserView as TextView, nativeAd.advertiser)

    val ratingView = adView.starRatingView as RatingBar
    val rating = nativeAd.starRating
    if (rating == null) {
      ratingView.visibility = View.GONE
    } else {
      ratingView.rating = rating.toFloat()
      ratingView.visibility = View.VISIBLE
    }

    adView.setNativeAd(nativeAd)
    return adView
  }

  private fun bindText(view: TextView, value: String?) {
    if (value.isNullOrBlank()) {
      view.visibility = View.GONE
    } else {
      view.text = value
      view.visibility = View.VISIBLE
    }
  }

  private fun bindButton(view: Button, value: String?) {
    if (value.isNullOrBlank()) {
      view.visibility = View.GONE
    } else {
      view.text = value
      view.visibility = View.VISIBLE
    }
  }
}

package pl.speednet.flutter.euvic_sdk_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import pl.speednet.euvictrackersdk.EuvicMobileSDK
import pl.speednet.euvictrackersdk.events.CustomParams
import pl.speednet.euvictrackersdk.events.Product

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        /**
         * Channel only for configuration data
         */
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, configurationChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "configure" -> {
                    val apiKey = call.argument<String>("apiKey")
                    val url = call.argument<String>("url")
                    val userId = call.argument<String>("userId")
                    val currency = call.argument<String>("currency")
                    val allowSensitiveData = call.argument<Boolean>("allowSensitiveData")

                    if (!apiKey.isNullOrEmpty() && !url.isNullOrEmpty()) {
                        EuvicMobileSDK.configure(
                            context = applicationContext,
                            apiKey = apiKey,
                            url = url,
                            userId = userId,
                            currency = currency,
                            allowSensitiveData = allowSensitiveData ?: true
                        )
                    }
                }
                "get_user_id" -> {
                    val id = EuvicMobileSDK.getCurrentUserId
                    result.success(id)
                }
            }
        }


        /**
         * Channel which handle sending events
         */
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setMethodCallHandler { call, _ ->
            when (call.method) {
                "home_page_visited_event" -> {
                    val customDataHashMap = call.getCustomDataHashMap()

                    EuvicMobileSDK.homepageVisitedEvent(
                        custom = mapToCustomParams(customDataHashMap)
                    )
                }
                "product_browsed_event" -> {
                    val product = call.getProduct()?.let { mapToProduct(it) }
                    val customDataHashMap = call.getCustomDataHashMap()

                    product?.let {
                        EuvicMobileSDK.productBrowsedEvent(
                            product = product,
                            custom = mapToCustomParams(customDataHashMap)
                        )
                    }
                }
                "product_added_event" -> {
                    val product = call.getProduct()?.let { mapToProduct(it) }
                    val customDataHashMap = call.getCustomDataHashMap()

                    product?.let {
                        EuvicMobileSDK.productAddedEvent(
                            product = product,
                            custom = mapToCustomParams(customDataHashMap)
                        )
                    }
                }
                "product_removed_event" -> {
                    val product = call.getProduct()?.let { mapToProduct(it) }
                    val customDataHashMap = call.getCustomDataHashMap()

                    product?.let {
                        EuvicMobileSDK.productRemovedEvent(
                            product = product,
                            custom = mapToCustomParams(customDataHashMap)
                        )
                    }
                }
                "category_browsed_event" -> {
                    val name = call.argument<String>("name")
                    val products = call.getProductList()?.let { mapToProductList(it) }
                    val customParams = call.getCustomDataHashMap()?.let { mapToCustomParams(it) }

                    if (name != null && !products.isNullOrEmpty()) {
                        EuvicMobileSDK.browsedCategoryEvent(
                            name = name,
                            products = products,
                            custom = customParams
                        )
                    }
                }
                "cart_event" -> {
                    val products = call.getProductList()?.let { mapToProductList(it) }
                    val customParams = call.getCustomDataHashMap()?.let { mapToCustomParams(it) }

                    if (!products.isNullOrEmpty()) {
                        EuvicMobileSDK.cartEvent(
                            products = products,
                            custom = customParams
                        )
                    }
                }
                "order_started_event" -> {
                    val customParams = call.getCustomDataHashMap()?.let { mapToCustomParams(it) }
                    EuvicMobileSDK.orderStartedEvent(
                        custom = customParams
                    )
                }
                "products_ordered_event" -> {
                    val orderId = call.argument<String>("orderId")
                    val saleValue = call.argument<String>("saleValue")
                    val currency = call.argument<String>("currency")
                    val products = call.getProductList()?.let { mapToProductList(it) }
                    val customParams = call.getCustomDataHashMap()?.let { mapToCustomParams(it) }

                    if (orderId != null && saleValue != null && !products.isNullOrEmpty()) {
                        EuvicMobileSDK.productsOrderedEvent(
                            orderId = orderId,
                            saleValue = saleValue,
                            currency = currency,
                            products = products,
                            custom = customParams
                        )
                    }
                }
            }

        }
    }

    private fun mapToProductList(list: List<Map<String, Any>>?): List<Product>? {
        return list?.mapNotNull { mapToProduct(it) }
    }

    private fun mapToProduct(map: Map<String, Any>?): Product? {
        val id = map?.get("id") as? String
        val price = map?.get("price") as? String
        val quantity = map?.get("quantity") as? Int
        val currency = map?.get("currency") as? String

        return if (id != null && price != null && quantity != null) {
            Product(
                id = id,
                price = price,
                quantity = quantity,
                currency = if (currency == "null") null else currency
            )
        } else {
            null
        }
    }

    private fun mapToCustomParams(map: Map<String, Any>?): (CustomParams.() -> Unit)? {
        if (map.isNullOrEmpty()) {
            return null
        }

        return {
            map.forEach { (key, value) ->
                when (value) {
                    is String -> param(key, value)
                    is Int -> param(key, value)
                    is Float -> param(key, value)
                    is Double -> param(key, value)
                }
            }
        }
    }

    private fun MethodCall.getCustomDataHashMap(): Map<String, Any>? {
        return this.argument<Map<String, Any>>("customData")
    }

    private fun MethodCall.getProduct(): Map<String, Any>? {
        return this.argument<Map<String, Any>>("product")
    }

    private fun MethodCall.getProductList(): List<Map<String, Any>>? {
        return this.argument<List<Map<String, Any>>>("products")
    }

    companion object {
        private const val configurationChannel = "configuration_channel"
        private const val eventChannel = "event_channel"
    }
}


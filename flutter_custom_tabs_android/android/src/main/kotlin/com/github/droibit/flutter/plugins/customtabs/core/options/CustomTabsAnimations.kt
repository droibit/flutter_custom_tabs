package com.github.droibit.flutter.plugins.customtabs.core.options

class CustomTabsAnimations private constructor(
    val startEnter: String?,
    val startExit: String?,
    val endEnter: String?,
    val endExit: String?
) {
    class Builder {
        private var startEnter: String? = null
        private var startExit: String? = null
        private var endEnter: String? = null
        private var endExit: String? = null

        fun setOptions(options: Map<String, Any>?): Builder {
            if (options == null) {
                return this
            }

            startEnter = options[KEY_START_ENTER] as String?
            startExit = options[KEY_START_EXIT] as String?
            endEnter = options[KEY_END_ENTER] as String?
            endExit = options[KEY_END_EXIT] as String?
            return this
        }

        fun setStartEnter(startEnter: String?): Builder {
            this.startEnter = startEnter
            return this
        }

        fun setStartExit(startExit: String?): Builder {
            this.startExit = startExit
            return this
        }

        fun setEndEnter(endEnter: String?): Builder {
            this.endEnter = endEnter
            return this
        }

        fun setEndExit(endExit: String?): Builder {
            this.endExit = endExit
            return this
        }

        fun build() = CustomTabsAnimations(startEnter, startExit, endEnter, endExit)

        private companion object {
            private const val KEY_START_ENTER = "startEnter"
            private const val KEY_START_EXIT = "startExit"
            private const val KEY_END_ENTER = "endEnter"
            private const val KEY_END_EXIT = "endExit"
        }
    }
}

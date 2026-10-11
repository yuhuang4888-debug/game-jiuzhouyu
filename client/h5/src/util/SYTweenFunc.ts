

export class SYTweenFunc {

    public static LINEAR = "linear" 	//线性
    public static EASE_IN = "easeIn"
    public static EASE_OUT = "easeOut"
    public static EASE_IN_OUT = "easeInOut"
    public static EASE_OUT_IN = "easeOutIn"
    public static EASE_IN_BACK = "easeInBack"
    public static EASE_OUT_BACK = "easeOutBack"
    public static EASE_IN_OUT_BACK = "easeInOutBack"
    public static EASE_OUT_IN_BACK = "easeOutInBack"
    public static EASE_IN_ELASTIC = "easeInElastic"
    public static EASE_OUT_ELASTIC = "easeOutElastic"
    public static EASE_IN_OUT_ELASTIC = "easeInOutElastic"
    public static EASE_OUT_IN_ELASTIC = "easeOutInElastic"
    public static EASE_IN_BOUNCE = "easeInBounce"
    public static EASE_OUT_BOUNCE = "easeOutBounce"
    public static EASE_IN_OUT_BOUNCE = "easeInOutBounce"
    public static EASE_OUT_IN_BOUNCE = "easeOutInBounce"
    public static EASE_IN_TO_OUT_BACK = "easeInToOutBack"
    public static PINGPONG = "pingPong"


    public static linear(ratio) {
        return ratio
    }
    public static easeIn(ratio) {
        return ratio * ratio * ratio
    }
    public static easeOut(ratio) {
        let invRatio = ratio - 1.0
        return invRatio * invRatio * invRatio + 1
    }
    public static easeInOut(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeIn, SYTweenFunc.easeOut, ratio)
    }
    public static easeOutIn(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeOut, SYTweenFunc.easeIn, ratio)
    }
    public static easeInBack(ratio) {
        let s = 1.70158
        return Math.pow(ratio, 2) * ((s + 1.0) * ratio - s)
    }
    public static easeOutBack(ratio) {
        let invRatio = ratio - 1.0
        let s = 1.70158
        return Math.pow(invRatio, 2) * ((s + 1.0) * invRatio + s) + 1.0
    }
    public static easeInOutBack(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeInBack, SYTweenFunc.easeOutBack, ratio)
    }
    public static easeOutInBack(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeOutBack, SYTweenFunc.easeInBack, ratio)
    }
    public static easeInElastic(ratio) {
        if (ratio == 0 || ratio == 1) {
            return ratio
        } else {
            let p = 0.3
            let s = p / 4.0
            let invRatio = ratio - 1
            return -1.0 * Math.pow(2.0, 10.0 * invRatio) * Math.sin((invRatio - s) * (2.0 * Math.PI) / p)
        }
    }
    public static easeOutElastic(ratio) {
        if (ratio == 0 || ratio == 1) {
            return ratio
        } else {
            let p = 0.3
            let s = p / 4.0
            return Math.pow(2.0, -10.0 * ratio) * Math.sin((ratio - s) * (2.0 * Math.PI) / p) + 1
        }
    }
    public static easeInOutElastic(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeInElastic, SYTweenFunc.easeOutElastic, ratio)
    }
    public static easeOutInElastic(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeOutElastic, SYTweenFunc.easeInElastic, ratio)
    }
    public static easeInBounce(ratio) {
        return 1.0 - SYTweenFunc.easeOutBounce(1.0 - ratio)
    }
    public static easeOutBounce(ratio) {
        let s = 7.5625
        let p = 2.75
        let l = null
        if (ratio < (1.0 / p)) {
            l = s * Math.pow(ratio, 2)
        } else {
            if (ratio < (2.0 / p)) {
                ratio = ratio - 1.5 / p
                l = s * Math.pow(ratio, 2) + 0.75
            } else {
                if (ratio < 2.5 / p) {
                    ratio = ratio - 2.25 / p
                    l = s * Math.pow(ratio, 2) + 0.9375
                } else {
                    ratio = ratio - 2.625 / p
                    l = s * Math.pow(ratio, 2) + 0.984375
                }
            }
        }
        return l
    }
    public static easeInOutBounce(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeInBounce, SYTweenFunc.easeOutBounce, ratio)
    }
    public static easeOutInBounce(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeOutBounce, SYTweenFunc.easeInBounce, ratio)
    }
    public static easeInToOutBack(ratio) {
        return SYTweenFunc.easeCombined(SYTweenFunc.easeIn, SYTweenFunc.easeOutBack, ratio)
    }
    public static easeCombined(startFunc, endFunc, ratio) {
        if (ratio < 0.5) {
            return 0.5 * startFunc(ratio * 2.0)
        } else {
            return 0.5 * endFunc((ratio - 0.5) * 2.0) + 0.5
        }
    }
    public static pingPong(ratio) {
        if (ratio < 0.5) {
            return SYTweenFunc.linear(ratio * 2)
        } else {
            return SYTweenFunc.linear(2 - ratio * 2)
        }
    }
}
// SYTweenFunc[SYTweenFunc.LINEAR] = SYTweenFunc.linear
// SYTweenFunc[SYTweenFunc.EASE_IN] = SYTweenFunc.easeIn
// SYTweenFunc[SYTweenFunc.EASE_OUT] = SYTweenFunc.easeOut
// SYTweenFunc[SYTweenFunc.EASE_IN_OUT] = SYTweenFunc.easeInOut
// SYTweenFunc[SYTweenFunc.EASE_OUT_IN] = SYTweenFunc.easeOutIn
// SYTweenFunc[SYTweenFunc.EASE_IN_BACK] = SYTweenFunc.easeInBack
// SYTweenFunc[SYTweenFunc.EASE_OUT_BACK] = SYTweenFunc.easeOutBack
// SYTweenFunc[SYTweenFunc.EASE_IN_OUT_BACK] = SYTweenFunc.easeInOutBack
// SYTweenFunc[SYTweenFunc.EASE_OUT_IN_BACK] = SYTweenFunc.easeOutInBack
// SYTweenFunc[SYTweenFunc.EASE_IN_ELASTIC] = SYTweenFunc.easeInElastic
// SYTweenFunc[SYTweenFunc.EASE_OUT_ELASTIC] = SYTweenFunc.easeOutElastic
// SYTweenFunc[SYTweenFunc.EASE_IN_OUT_ELASTIC] = SYTweenFunc.easeInOutElastic
// SYTweenFunc[SYTweenFunc.EASE_OUT_IN_ELASTIC] = SYTweenFunc.easeOutInElastic
// SYTweenFunc[SYTweenFunc.EASE_IN_BOUNCE] = SYTweenFunc.easeInBounce
// SYTweenFunc[SYTweenFunc.EASE_OUT_BOUNCE] = SYTweenFunc.easeOutBounce
// SYTweenFunc[SYTweenFunc.EASE_IN_OUT_BOUNCE] = SYTweenFunc.easeInOutBounce
// SYTweenFunc[SYTweenFunc.EASE_OUT_IN_BOUNCE] = SYTweenFunc.easeOutInBounce
// SYTweenFunc[SYTweenFunc.EASE_IN_TO_OUT_BACK] = SYTweenFunc.easeInToOutBack
// SYTweenFunc[SYTweenFunc.PINGPONG] = SYTweenFunc.pingPong

window["SYTweenFunc"] = SYTweenFunc
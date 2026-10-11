export class Mathf {
	// public static Deg2Rad = Math.rad(1)
	public static Epsilon = 1.4013e-45
	// public static Infinity = Math.huge
	// public static NegativeInfinity = -Math.huge
	public static PI = Math.PI
	// public static Rad2Deg = Math.deg(1)
			
	public static Abs = Math.abs
	public static Acos = Math.acos
	public static Asin = Math.asin
	public static Atan = Math.atan
	public static Atan2 = Math.atan2
	public static Ceil = Math.ceil
	public static Cos = Math.cos
	public static Exp = Math.exp
	public static Floor = Math.floor
	public static Log = Math.log
	// public static Log10 = Math.log10
	public static Max = Math.max
	public static Min = Math.min
	public static Pow = Math.pow
	public static Sin = Math.sin
	public static Sqrt = Math.sqrt
	public static Tan = Math.tan
	// public static Deg = Math.deg
	// public static Rad = Math.rad
	public static Random = Math.random

	public static Sign(num) {  
		if (num > 0 ) {
			num = 1
		} else if (num < 0 ) {
			num = -1
		}else{
			num = 0
		}
	
		return num
	}
	
	public static Approximately(a, b) {
		return Math.abs(b - a) < Math.max(1e-6 * Math.max(Math.abs(a), Math.abs(b)), 1.121039e-44)
	}
	
	public static Clamp(value, min, max) {
		if (value < min ) {
			value = min
		} else if (value > max ) {
			value = max    
		}
		
		return value
	}
	
	public static Clamp01(value) {
		if (value < 0 ) {
			return 0
		} else if (value > 1 ) {
			return 1   
		}
		
		return value
	}
	
	public static DeltaAngle(current, target) {    
		let num = Mathf.Repeat(target - current, 360)
	
		if (num > 180 ) {
			num = num - 360
		}
	
		return num
	}
	
	public static Gamma(value, absmax, gamma) { 
		let flag = false
		
		if (value < 0)
		{
			flag = true
		}
		
		let num = Math.abs(value)
		
		if (num > absmax)
		{
			return (! flag) && num || -num
		}
		
		let num2 = Math.pow(num / absmax, gamma) * absmax
		return (! flag) && num2 || -num2
	}
	
	public static InverseLerp(from, to, value) {
		if (from < to ) {      
			if (value < from ) { 
				return 0
			}
	
			if (value > to ) {      
				return 1
			}
	
			value = value - from
			value = value/(to - from)
			return value
		}
	
		if (from <= to ) {
			return 0
		}
	
		if (value < to ) {
			return 1
		}
	
		if (value > from ) {
			return 0
		}
	
		return 1 - ((value - to) / (from - to))
	}
	
	public static Lerp(from, to, t) {
		return from + (to - from) * Mathf.Clamp01(t)
	}
	
	public static LerpAngle(a, b, t) {
		let num = Mathf.Repeat(b - a, 360)
	
		if (num > 180 ) {
			num = num - 360
		}
	
		return a + num * Mathf.Clamp01(t)
	}
	
	public static LerpUnclamped(a, b, t) {
		return a + (b - a) * t;
	}
	
	public static MoveTowards(current, target, maxDelta) {
		if (Math.abs(target - current) <= maxDelta ) {
			return target
		}
	
		return current + Mathf.Sign(target - current) * maxDelta
	}
	
	public static MoveTowardsAngle(current, target, maxDelta) {
		target = current + Mathf.DeltaAngle(current, target)
		return Mathf.MoveTowards(current, target, maxDelta)
	}
	
	public static PingPong(t, length) {
		t = Mathf.Repeat(t, length * 2)
		return length - Math.abs(t - length)
	}
	
	public static Repeat(t, length) {    
		return t - (Math.floor(t / length) * length)
	}
	
	public static Round(num) {
		return Math.floor(num + 0.5)
	}
	
	// public static SmoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime) {
	// 	maxSpeed = maxSpeed || Mathf.Infinity
	// 	deltaTime = deltaTime || Time.deltaTime
	// 	smoothTime = Mathf.Max(0.0001, smoothTime)
	// 	let num = 2 / smoothTime
	// 	let num2 = num * deltaTime
	// 	let num3 = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)
	// 	let num4 = current - target
	// 	let num5 = target
	// 	let max = maxSpeed * smoothTime
	// 	num4 = Mathf.Clamp(num4, -max, max)
	// 	target = current - num4
	// 	let num7 = (currentVelocity + (num * num4)) * deltaTime
	// 	currentVelocity = (currentVelocity - num * num7) * num3
	// 	let num8 = target + (num4 + num7) * num3
		
	// 	if ((num5 > current) == (num8 > num5))
	// 	{
	// 		num8 = num5
	// 		currentVelocity = (num8 - num5) / deltaTime		
	// 	}
		
	// 	return num8
	// }
	
	// public static SmoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime) {
	// 	deltaTime = deltaTime || Time.deltaTime
	// 	maxSpeed = maxSpeed || Mathf.Infinity	
	// 	target = current + Mathf.DeltaAngle(current, target)
	// 	return Mathf.SmoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
	// }
	
	
	public static SmoothStep(from, to, t) {
		t = Mathf.Clamp01(t)
		t = -2 * t * t * t + 3 * t * t
		return to * t + from * (1 - t)
	}
	
	// public static HorizontalAngle(dir) { 
	// 	return Math.deg(Math.atan2(dir.x, dir.z))
	// }
	
	public static IsNan(number) {
		return ! (number == number)
	}
	
}

window["Mathf"] = Mathf
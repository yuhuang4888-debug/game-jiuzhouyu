import { Status } from "./Status";
import { GlobalEventSystem } from "./DeclareGlobalVar";
import { SceneEventType } from "../common/EventName";
import { SpecialCharKey } from "../common/SpecialCharKey";
// TypeScript file
export class TimeUtil {
	static eng_faster_time: number = 0;
	/**一天秒数 */
	static OneDayMs = 24 * 3600 * 1000;

	public static getClientTime() {
		return Status.NowTime;
	}
	public static getServerTime() {
		return Math.floor((Laya.timer.currTimer + this.eng_faster_time) / 1000 + 0.5);
	}
	public static getServerTimeMs() {
		return Laya.timer.currTimer + this.eng_faster_time;
	}
	public static getClientTimeMs() {
		return Laya.timer.currTimer;
	}
	public static notifyServerTime(server_time) {
		TimeUtil.eng_faster_time = server_time - Laya.timer.currTimer;
		GlobalEventSystem.Fire(SceneEventType.NOTIFY_SERVER_TIME);
	}
	/*
		@param:second
		@return 00:00
	*/
	public static timeConvert8(second) {
		let mm = Math.floor(second / 60);
		let m_str = mm <= 9 ? "0" + mm : mm;
		let ss = second % 60;
		let s_str = ss <= 9 ? ":0" + ss : ":" + ss;
		return m_str + s_str;
	}
	/**
	 * @param  服务器传来的时间戳time
	 * @returns 什么前
	 */
	public static GetTimeStrByServerTime(time): string {
		let dec_time = this.getServerTime() - time;
		if (dec_time <= 0)
			return "刚刚";
		let tem = 0;
		let month = Math.floor(dec_time / (3600 * 24 * 30));
		tem = dec_time % (3600 * 24 * 30);
		let day = Math.floor(tem / (3600 * 24));
		tem = tem % (3600 * 24);
		let h = Math.floor(tem / 3600);
		tem = tem % 3600;
		let m = Math.floor(tem / 60);
		tem = tem % 60;
		let s = tem;
		if (month != 0)
			return `${month}月前`;
		else if (day != 0)
			return `${day}天前`;
		else if (h != 0)
			return `${h}小时前`;
		else if (m != 0)
			return `${m}分钟前`;
		else if (s != 0)
			return `${s}秒前`;
		else
			return "";
	}
	/*
	  @param:second
	  @return 2014-06-18 10:33:24
  */
	public static timeFormat(second) {
		let date = new Date(second * 1000); //时间戳为10位需*1000，时间戳为13位的话不需乘1000
		let Y = date.getFullYear() + '-';
		let M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
		let D = (date.getDate() < 10 ? '0' + date.getDate() : date.getDate()) + ' ';
		let h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
		let m = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
		let s = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds();
		return Y + M + D + h + m + s;
	}
	public static convertTime(times) {
		let timeStr = "";
		let second = Math.floor(times % 60);
		let minute = Math.floor(times / 60);
		if (minute >= 60) {
			times = Math.floor(minute / 60);
			timeStr = `${timeStr}${times > 9 ? times : `0${times}`}`;
			timeStr = `${timeStr}:`;
			minute = minute % 60;
			timeStr = `${timeStr}${minute > 9 ? minute : `0${minute}`}`;
			timeStr = `${timeStr}:`;
			timeStr = `${timeStr}${second > 9 ? second : `0${second}`}`;
		}
		else {
			timeStr = `${timeStr}00:`;
			timeStr = `${timeStr}${minute > 9 ? minute : `0${minute}`}`;
			timeStr = `${timeStr}:`;
			timeStr = `${timeStr}${second > 9 ? second : `0${second}`}`;
		}
		return timeStr;
	}
	//时间差
	public static convertTimeColor(times, stype?) {
		let D = Math.floor(times / 60 / 60 / 24);
		let h = Math.floor(times / 60 / 60) % 24;
		let m = Math.floor(times / 60) % 60;
		let s = times % 60;
		let timeStr = "";
		if (D > 0) {
			if (h > 0) {
				timeStr = `${D}天${h}时`;
			}
			else {
				timeStr = `${D}天`;
			}
		}
		else {
			timeStr = `${timeStr}${h > 9 ? h : `0${h}`}`;
			timeStr = `${timeStr}:`;
			timeStr = `${timeStr}${m > 9 ? m : `0${m}`}`;
			timeStr = `${timeStr}:`;
			timeStr = `${timeStr}${s > 9 ? s : `0${s}`}`;
		}
		return timeStr;
	}
	public static convertTimeCN(times, stype?) {
		let d = Math.floor(times / 60 / 60 / 24)
		let h = Math.floor(times / 60 / 60) % 24
		let m = Math.floor(times / 60) % 60
		let s = times % 60
		let timeStr = ""

		if (d > 0) {
			timeStr = h > 0 ? `${d}天${h}时` : `${d}天`
		} else if (h > 0) {
			timeStr = m > 0 ? `${h}时${m}分` : `${h}时`
		} else if (m > 0) {
			timeStr = s > 0 ? `${m}分${s}秒` : `${m}分`
		} else {
			timeStr = `${s}秒`
		}
		return timeStr
	}
	//second不能传时间差 会有时区问题
	public static timeConversion(second, stype?) {
		let date = new Date(second * 1000); //时间戳为10位需*1000，时间戳为13位的话不需乘1000
		let Y = date.getFullYear();
		let M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1);
		let D = (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
		let h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours());
		let m = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes());
		let s = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds();
		switch(stype)
		{
			case "mm-dd hh:MM":
				return `${M}-${D} ${h}:${m}`;
			case "yyyy/mm/dd hh:MM:ss":
				return `${Y}/${M}/${D} ${h}:${m}:${s}`;
			case "yyyy/mm/dd \n hh:MM:ss":
				return `${Y}/${M}/${D}\n${h}:${m}:${s}`;
			case "yyyy/mm/dd hh:MM":
				return `${Y}年${M}月${D}日 ${h}:${m}`;
			case stype == "yyyy-mm-dd":
				return `${Y}年${M}月${D}日`;
			case "yyyy-mm-dd hh:MM:ss":
				return `${Y}-${M}-${D} ${h}:${m}:${s}`;
			case "hh:MM:ss":
				return `${h}:${m}:${s}`;
			case "hh:MM":
				return `${h}:${m}`;
			case "MDhh:mm":
				return `${M}月${D}日${h}:${m}`;
			case "MDHM":
				return `${M}月${D}日${h}时${m}分`;
			case "MMDD":
				return `${M}月${D}日`;
			case "yyyy-mm-dd":
				return `${Y}-${M}-${D}`
			case "dd-hh-mm" :
				if (D > 0)
					return `${D}天${h}小时${m}分`;
				else
					return `${h}小时${m}分`;
			case "dd-hh-mm-ss":
				if (D > 0)
					return `${D}天${h}小时${m}分${s}秒`;
				else
					return `${h}小时${m}分${s}秒`;
			case "mm-ss":
				return `${m}分${s}秒`;
			default:
				return `${Y}-${M}-${D}`;
		}
	}

	public static timeConversionWithMillisecond(timeStr, stype) {
		if (timeStr == undefined) return
		timeStr = Number(timeStr)
		if (timeStr < 0) timeStr = 0
		let cur_type = stype ? stype : "date"

		//let timeStr = Math.floor(timeStr / 1000)
		let milli = timeStr / 1000 - Math.floor(timeStr / 1000)
		let date = new Date(timeStr)
		let monthStr = date.getMonth() < 10 ? "0" + date.getMonth() : date.getMonth()
		let dateStr = date.getDate() < 10 ? "0" + date.getDate() : date.getDate()
		let hoursStr = date.getHours() < 10 ? "0" + date.getHours() : date.getHours()
		let minutesStr = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()
		let secondStr = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds()
		//let milli = date.getMilliseconds()
		//milli = milli
		// let str = timeStr % 86400000
		// let len = string.len(str)
		// let millisecond = string.sub(str, len - 2, len)
		milli = Math.floor(milli * 100)
		let millisecond = milli < 10 ? "0" + milli : milli

		if (cur_type == "yy/mm/dd hh:mm:ss.ms")
			return date.getFullYear() + "/" + monthStr + "/" + dateStr + " " + hoursStr + ":" + minutesStr + ":" + secondStr + "." + millisecond
		else if (cur_type == "hh:mm:ss.ms")
			return hoursStr + ":" + minutesStr + ":" + secondStr + "." + millisecond
		else if (cur_type == "mm:ss.ms")
			return minutesStr + ":" + secondStr + "." + millisecond
		else
			return monthStr + SpecialCharKey.TimeUtil1 + date.getDate() + " " + hoursStr + ":" + minutesStr
	}




	//时间差
	public static timeConvert(second, stype?) {
		let D = Math.floor(second / 60 / 60 / 24);
		let h = Math.floor(second / 60 / 60) % 24;
		let m = Math.floor(second / 60) % 60;
		let s = second % 60;
		switch(stype)
		{
			case "hh:MM:ss":
				h = D * 24 + h;
				return `${h > 9 ? h : `0${h}`}:${m > 9 ? m : `0${m}`}:${s > 9 ? s : `0${s}`}`;
			case "mm:ss":
				return `${m > 9 ? m : `0${m}`}:${s > 9 ? s : `0${s}`}`;
			case "dd-hh-mm":
				if (D > 0)
					return `${D}天${h}小时${m}分`;
				else
					return `${h}小时${m}分`;
			case "dd-hh-mm-ss":
				if (D > 0)
					return `${D}天${h}小时${m}分${s}秒`;
				else
					return `${h}小时${m}分${s}秒`;
			case "mm-ss":
				return `${m}分${s}秒`;
			case "hh-mm-ss":
				if (D > 0)
					return `${D}天${h}小时${m}分`;
				else
					return `${h}小时${m}分${s}秒`;
			case "dd-hh/hh-mm/mm-ss":
				if (D > 0)
					return `${D}天${h}时`;
				else if (h > 0)
					return `${h}小时${m}分`;
				else
					return `${m}分${s}秒`;
			case "hh-mm-ss2":
				if (h > 0)
					return `${h}小时${m}分${s}秒`;
				else
					return `${m}分${s}秒`;
			case "dd/hh/mm/ss":
				if (D > 0)
					return `${D}天`;
				else if (h > 0)
					return `${h}小时`;
				else if (m > 0)
					return `${m}分`;
				else
					`${s}秒`;
			case "hh/mm/ss":
				if (h > 0)
					return `${h}小时${m}分`;
				else if (m > 0)
					return `${m}分钟`;
				else
					return `${s}秒`;
			default:
				return `${m}:${s}`;
		}
	}
	//时间差(毫秒)
	public static timeConvertMS(msec, stype?) {
		let m = Math.floor(msec / 1000 / 60) % 60;
		let s = Math.floor(msec / 1000) % 60;
		let ms = msec % 1000;
		let m_str = m > 9 ? m : `0${m}`;
		let s_str = s > 9 ? s : `0${s}`;
		if (stype == "mm:ss.xx") {
			ms = Math.floor(ms / 10);
			let ms_str = ms > 9 ? ms : `0${ms}`;
			return `${m_str}:${s_str}.${ms_str}`;
		}
		else {
			let ms_str = window["Util"].PrefixInteger(ms, 3);
			return `${m_str}:${s_str}.${ms_str}`;
		}
	}
	/**
	 * 传入时间(毫秒)返回当前时分秒（秒）
	 */
	public static timeHMS(time): number {
		let date = new Date(time); //时间戳为10位需*1000，时间戳为13位的话不需乘1000
		let h = date.getHours();
		let m = date.getMinutes();
		let s = date.getSeconds();
		return h * 3600 + m * 60 + s;
	}
	public static HMStimeToS(h=0, m=0, s=0): number {
		return h * 3600 + m * 60 + s;
	}
	/**
	 * @param future_days 未来N天
	 * @returns 未来某一天0点时间戳
	 */
	public static GetFutureZeroStamp(future_days): number {
		let cur_timestamp = TimeUtil.getServerTime();
		let one_hour_timestamp = 24 * 60 * 60;
		let temp_time = cur_timestamp + one_hour_timestamp * future_days;
		let date = new Date(temp_time * 1000);
		date.setHours(0);
		date.setMinutes(0);
		date.setSeconds(0);
		return Math.round(date.getTime() / 1000);
	}
	/**
	* @param future_days 未来N天
	* @returns 传入时间的未来某一天0点时间戳
	*/
	public static GetTimeFutureZeroStamp(starTime, future_days, hour = 0): number {
		let cur_timestamp = starTime;
		let one_hour_timestamp = 24 * 60 * 60;
		let temp_time = cur_timestamp + one_hour_timestamp * future_days;
		let date = new Date(temp_time * 1000);
		date.setHours(hour);
		date.setMinutes(0);
		date.setSeconds(0);
		return Math.round(date.getTime() / 1000);
	}
	//通过分钟获取时长
	public static GetTimeLengthByMin(mins): string {
		if (mins < 60) {
			return `${mins}分钟`;
		}
		else {
			let hour = mins / 60;
			let m = mins - (hour * 60);
			if (m) {
				return `${hour}小时${m}分钟`;
			}
			else {
				return `${hour}小时`;
			}
		}
	}
	public static WeekNumToFont(num, isEn?) {
		let str = '';
		switch (num) {
			case 1:
				str = isEn ? 'Monday' : '一';
				break;
			case 2:
				str = isEn ? 'Tuesday' : '二';
				break;
			case 3:
				str = isEn ? 'Wednesday' : '三';
				break;
			case 4:
				str = isEn ? 'Thursday' : '四';
				break;
			case 5:
				str = isEn ? 'Friday' : '五';
				break;
			case 6:
				str = isEn ? 'Saturday' : '六';
				break;
			case 7:
				str = isEn ? 'Sunday' : '日';
				break;
		}
		return str;
	}
	public static GetHalfDesc(second) {
		let date = new Date(second * 1000);
		let h = date.getHours();
		return h > 12 ? "晚" : "早";
	}
	public static GetCountDays() {
		let curDate = new Date(Date.now());
		let curMonth = curDate.getMonth();
		curDate.setDate(0);
		return curDate.getDate();
	}
	//将本地时间转化成和服务器相同时区的时间
	public static GetZoneTime() {
		let local_zone = -(new Date().getTimezoneOffset() / 60); //包含了是否是夏令时
		let server_zone = TimeUtil.GetServerZone();
		// let off_dst = TimeUtil.IsDayLight() ? 1 : 0
		// let off_zone = server_zone - (local_zone + off_dst)
		let off_zone = server_zone - local_zone;
		let cur_date = TimeUtil.getServerTime() + off_zone * 3600;
		return cur_date;
	}
	//获取服务器所在时区
	public static GetServerZone() {
		if (window["PlatformManager"].IsEyouEnPlatform()) {
		    let location = window["LoginManager"].GetInstance().GetCurServer2Location();
		    if (location) {
		        if (location == 1) { //亚太 北京
		            return 8;
		        }
		        else if (location == 2) { //北美 纽约
		            return -5;
		        }
		        else if (location == 3) { //欧洲 伦敦
		            return 0;
		        }
		    }
		}
		return 8; //北京
	}
	//当前时间所在地区是否是夏令时
	public static IsDayLight() {
		var d1 = new Date(2009, 0, 1);
		var d2 = new Date(2009, 6, 1);
		let is_day_light = false;
		if (d1.getTimezoneOffset() != d2.getTimezoneOffset()) {
			is_day_light = true; //夏令时
		}
		return is_day_light;
	}


	public static GetWeekStrByOpenDay(day?) {
		day = Number(day)
		let openDay = window["ServerTimeModel"].GetInstance().GetOpenServerDay()
		let curTime = TimeUtil.getServerTime()
		let targetTime = curTime + (day - openDay) * 24 * 60 * 60
		let week = new Date(targetTime)
		return week.getDay()
	}

	/**
	* 自然日天数差(end - start)
	* @param start 开始时间（时间戳）
	* @param end 结束时间（时间戳）
	*/
	public static naturalDaysBetween(start: number, end: number): number {
		let startTime = this.startTimeOfDate(new Date(start));
		let endTime = this.startTimeOfDate(new Date(end));
		return (endTime.getTime() - startTime.getTime()) / this.OneDayMs;
	}

	private static startTimeOfDate(date: Date): Date {
		let time: Date = new Date(date.getTime());
		time.setHours(0, 0, 0, 0);
		return time;
	}



}



window["TimeUtil"] = TimeUtil
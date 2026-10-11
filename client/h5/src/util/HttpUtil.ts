import { SpecialCharKey } from "../common/SpecialCharKey";
import { ClientConfig } from "./DeclareGlobalVar";
import { GameError } from "./GameError";

export class HttpUtil {
    static is_http = true; // true http  false https
    static game_url = ""; // 游戏链接地址
    public constructor() {
    }
    public static ParseHttpType(url: string) {
        if (HttpUtil.is_http) {
            url = url.replace("https:", "http:");
        }
        else {
            url = url.replace("http:", "https:");
        }
        return url;
    }
    public static HttpPostRequest(url: string, post_param, call_func, timeout_value = 10, check_http = true) {
        // console.log("post_param=", post_param)
        let has_callback = false;
        let cc = ClientConfig;
        let base_url = timeout_value && cc && cc.url_account_path;
        let backup_base_url = timeout_value && cc && cc.backurl_account_path;
        let timeout_id;
        if (check_http) {
            url = HttpUtil.ParseHttpType(url);
            if (base_url) {
                base_url = HttpUtil.ParseHttpType(base_url);
            }
            if (backup_base_url) {
                backup_base_url = HttpUtil.ParseHttpType(backup_base_url);
            }
        }
        let error_request_times = 3
        let RealRequest = (url: string, post_param, call_func, timeout_value = 10, check_http = true) => {
            let request = new Laya.HttpRequest();
            let onPostComplete = (data) => {
                console.log("post data : "+data+url);
                if (timeout_id) {
                    window["GlobalTimerQuest"].CancelQuest(timeout_id);
                    timeout_id = null;
                }
                // let check_response = request.response;
                // if (typeof request.response == "string") {
                //     try {
                //         check_response = JSON.parse(request.response);
                //     }
                //     catch (e) {
                //         GameError.GetInstance().SendErrorToPHP(url + " HttpPostRequest 回调参数不是json格式 " + request.response);
                //         return;
                //     }
                // }
                // if (check_response) {
                //     if (check_response.ret == 999) //timeout
                //      {
                //         let Alert = window["Alert"]
                //         Alert.Show("检测到你的系统时区并非UTC+8，请在手机设置-日期与时间，开启【自动设置】。重新打开游戏即可登录");
                //         return;
                //     }
                // }
                if (base_url && backup_base_url && base_url != backup_base_url && url.indexOf(backup_base_url) >= 0) {
                    GameError.GetInstance().SendErrorToPHP("HttpPostRequest 请求备份php地址成功！！！！！backurl_account_path = " + url);
                }
                if (!has_callback) {
                    has_callback = true;
                }
                else {
                    return;
                }
                if (call_func) {
                    call_func(data);
                }
            };
            let onPostIOError = (event): void => {
                console.log("post error : " + event);
                if (timeout_id) {
                    window["GlobalTimerQuest"].CancelQuest(timeout_id);
                    timeout_id = null;
                }
                if (timeout_value) {
                    let status_str = "";
                    if (base_url && url.indexOf(base_url) >= 0) {
                        if(error_request_times > 1)
                        {
                            error_request_times --
                            GameError.GetInstance().SendErrorToPHP("HttpPostRequest 请求回调失败 " + status_str + "  url_account_path = " + url + "  发起备份php地址请求");
                            let backup_url = url.replace(base_url, backup_base_url);
                            RealRequest(backup_url, post_param, call_func, timeout_value, check_http);
                        }
                    }
                    else if (backup_base_url && url.indexOf(backup_base_url) >= 0) {
                        GameError.GetInstance().SendErrorToPHP("HttpPostRequest 请求备份php地址回调失败 " + status_str + " 备份地址backurl_account_path = " + url + "   终止该请求");
                    }
                }
            };
            let onPostProgress = (event): void => {
                console.log("post progress : "+ event)// + Math.floor(100 * event..bytesLoaded / event.bytesTotal) + "%");
            };
            request.once(Laya.Event.COMPLETE, this, onPostComplete);
            request.once(Laya.Event.ERROR, this, onPostIOError);
            request.once(Laya.Event.PROGRESS, this, onPostProgress);
            request.send(url, post_param, "post", "text");
            if (timeout_value) {
                timeout_id = window["GlobalTimerQuest"].AddDelayQuest(() => {
                    if (timeout_id) {
                        timeout_id = null;
                        let status_str = "";
                        if (base_url && url.indexOf(base_url) >= 0 && backup_base_url) {
                            GameError.GetInstance().SendErrorToPHP("HttpPostRequest 请求回调超时  " + status_str + " url_account_path = " + url + "  发起备份php地址请求");
                            let backup_url = url.replace(base_url, backup_base_url);
                            RealRequest(backup_url, post_param, call_func, timeout_value, check_http);
                        }
                        else if (backup_base_url && url.indexOf(backup_base_url) >= 0) {
                            GameError.GetInstance().SendErrorToPHP("HttpPostRequest 请求备份php地址回调超时 " + status_str + " 备份地址backurl_account_path = " + url + "   终止该请求");
                        }
                    }
                }, timeout_value);
            }
        };
        RealRequest(url, post_param, call_func, timeout_value, check_http);
    }
    public static HttpGetRequest(url: string, get_data, call_func, timeout_value = 10, data ="") {
        let get_params = "?";
        for (let key in get_data) {
            let value = get_data[key];
            get_params = get_params + String(key) + "=" + String(value) + "&";
        }
        get_params = get_params.substring(0, get_params.length - 1)
        let has_callback = false;
        let error_request_times = 3
        let cc = ClientConfig;
        let base_url = timeout_value && cc && cc.url_account_path;
        let backup_base_url = timeout_value && cc && cc.backurl_account_path;
        let timeout_id;
        url = HttpUtil.ParseHttpType(url);
        if (base_url) {
            base_url = HttpUtil.ParseHttpType(base_url);
        }
        if (backup_base_url) {
            backup_base_url = HttpUtil.ParseHttpType(backup_base_url);
        }
        let RealRequest = (url: string, get_params, call_func, timeout_value = 10) => {
            console.warn("------RealRequest------"+ url+get_params)
            var request = new Laya.HttpRequest();
            request.http.timeout = 10000
            // request.responseType = egret.HttpResponseType.TEXT;
            let completeHandler = (data: any) => {
                // var request = <egret.HttpRequest>event.currentTarget;
                console.warn("------completeHandler------"+ data);
                if (timeout_id) {
                    window["GlobalTimerQuest"].CancelQuest(timeout_id);
                    timeout_id = null;
                }

                // let check_response = request.response;
                // if (typeof request.response == "string") {
                //     try {
                //         check_response = JSON.parse(request.response);
                //     }
                //     catch (e) {
                //         GameError.GetInstance().SendErrorToPHP(url + " HttpGetRequest 回调参数不是json格式 " + request.response);
                //         return;
                //     }
                // }
                // if (check_response) {
                //     if (check_response.ret == 999) //timeout
                //      {
                //         let Alert = window["Alert"]
                //         Alert.Show("检测到你的系统时区并非UTC+8，请在手机设置-日期与时间，开启【自动设置】。重新打开游戏即可登录");
                //         return;
                //     }
                // }
                // if (base_url && backup_base_url && base_url != backup_base_url && url.indexOf(backup_base_url) >= 0) {
                //     GameError.GetInstance().SendErrorToPHP("HttpGetRequest 请求备份php地址成功！！！！！backurl_account_path = " + url + get_params);
                // }
                // if (!has_callback) {
                //     has_callback = true;
                // }
                // else {
                //     return;
                // }
                if (call_func) {
                    call_func(data);
                }
            };
            let errorHandler = (data:any) => {
                console.log("get error : " + data);
                if (timeout_id) {
                    window["GlobalTimerQuest"].CancelQuest(timeout_id);
                    timeout_id = null;
                }
                if (timeout_value) {
                    let status_str = "";
                    if (request && request["_xhr"]) {
                        status_str = "状态码 = " + request["_xhr"].status;
                    }
                    if(backup_base_url){
                        if(backup_base_url == base_url){
                            GameError.GetInstance().SendErrorToPHP("HttpGetRequest 请求备份php地址回调失败 " + status_str + " 备份地址backurl_account_path = " + url + get_params + "   终止该请求");
                        }
                        else{
                            if (base_url && url.indexOf(base_url) >= 0) {
                                if(error_request_times > 1)
                                {
                                    error_request_times --
                                    GameError.GetInstance().SendErrorToPHP("HttpGetRequest 请求回调失败 " + status_str + " url_account_path = " + url + get_params + "  发起备份php地址请求");
                                    let backup_url = url.replace(base_url, backup_base_url);
                                    RealRequest(backup_url, get_params, call_func, timeout_value);
                                }
                            }
                            else if (backup_base_url && url.indexOf(backup_base_url) >= 0) {
                                GameError.GetInstance().SendErrorToPHP("HttpGetRequest 请求备份php地址回调失败 " + status_str + " 备份地址backurl_account_path = " + url + get_params + "   终止该请求");
                            }
                        }
                    }
                    else{
                        GameError.GetInstance().SendErrorToPHP("HttpGetRequest 请求备份php地址回调失败 " + status_str + " 备份地址backurl_account_path = " + url + get_params + "   终止该请求");
                    }
                }
            };
            let processHandler = (data) => {
                console.warn("------onGetProgress------"+data)
                // console.warn("get progress : " + Math.floor(100 * event.bytesLoaded / event.bytesTotal) + "%");
            };
            request.once(Laya.Event.COMPLETE, this, completeHandler);
            request.once(Laya.Event.ERROR, this, errorHandler);
            request.on(Laya.Event.PROGRESS, this, processHandler);
            request.send(url + get_params, data, "get", "text");
            // request.open(url + get_params, egret.HttpMethod.GET);
            // request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
            // request.send();
            if (timeout_value) {
                timeout_id = window["GlobalTimerQuest"].AddDelayQuest(() => {
                    if (timeout_id) {
                        timeout_id = null;
                        let status_str = "";
                        if (base_url && url.indexOf(base_url) >= 0) {
                            GameError.GetInstance().SendErrorToPHP("HttpGetRequest 请求回调超时 " + status_str + " url_account_path = " + url + get_params + "  发起备份php地址请求");
                            let backup_url = url.replace(base_url, backup_base_url);
                            RealRequest(backup_url, get_params, call_func, timeout_value);
                        }
                        else if (backup_base_url && url.indexOf(backup_base_url) >= 0) {
                            GameError.GetInstance().SendErrorToPHP("HttpGetRequest 请求备份php地址回调超时 " + status_str + " 备份地址backurl_account_path = " + url + get_params + "   终止该请求");
                        }
                    }
                }, timeout_value);
            }
        };
        RealRequest(url, get_params, call_func);
    }
    //http请求加载json
    public static HttpLoadJson(base_url: string, target_url: string, call_func, timeout_value = 10, backup_base_url = `http:${SpecialCharKey.HttpUtil1}cosjzybak.suyougame.com/wx1/`) {
        let has_callback = false;
        let timeout_id;
        base_url = HttpUtil.ParseHttpType(base_url);
        if (backup_base_url) {
            backup_base_url = HttpUtil.ParseHttpType(backup_base_url);
        }
        let error_request_times = 3
        let RealRequest = (base_url: string, target_url: string, call_func, timeout_value = 10, force_request_backup_url = true) => {
            var request: Laya.HttpRequest = new Laya.HttpRequest();
            var url = base_url + target_url;
            var respHandler = function (evt: Laya.Event): void {
                // console.warn("respHandler1111111111:", evt);
                // let request_response = request.response.trim();
                // try {
                //     JSON.parse(request_response);
                // }
                // catch (error) {
                //     request_response = null;
                //     GameError.GetInstance().SendErrorToPHP(`HttpLoadJson error :url ${url} stack ${error}`);
                // }
                if (timeout_id) {
                    window["GlobalTimerQuest"].CancelQuest(timeout_id);
                    timeout_id = null;
                }
                if (base_url && backup_base_url && base_url != backup_base_url && url.indexOf(backup_base_url) >= 0) {
                    GameError.GetInstance().SendErrorToPHP("HttpLoadJson 请求备份php地址成功！！！！！backurl_account_path = " + url);
                }
                if (!has_callback) {
                    has_callback = true;
                }
                else {
                    return;
                }
                if (call_func) {
                    call_func(evt);
                }
                // let obj = JSON.parse(request.response)
            };
            var errorHandler = function (evt)
            {
                console.warn("errorHandler:"+url+evt);
                if(error_request_times > 1)
                {
                    error_request_times --
                    if (force_request_backup_url) {
                        RealRequest(backup_base_url, target_url, call_func, timeout_value, false);
                    }
                }
            }
            var progressHandler = function (evt): void {
                console.warn("progress:", url, evt);
            };
            url = HttpUtil.ParseHttpType(url);
            console.warn("HttpLoadJson url:", url);
            request.once(Laya.Event.COMPLETE, this, respHandler);
            request.once(Laya.Event.ERROR, this, errorHandler);
            request.once(Laya.Event.PROGRESS, this, progressHandler);
            request.send(url, null, "get", "json");
            if (timeout_value) {
                timeout_id = window["GlobalTimerQuest"].AddDelayQuest(() => {
                    if (timeout_id) {
                        timeout_id = null;
                        let status_str = "";
                        if (force_request_backup_url) {
                            GameError.GetInstance().SendErrorToPHP("HttpLoadJson 请求回调超时 " + status_str + " url_account_path = " + url + "  发起备份php地址请求");
                            RealRequest(backup_base_url, target_url, call_func, timeout_value, false);
                        }
                        else if (backup_base_url && url.indexOf(backup_base_url) >= 0) {
                            GameError.GetInstance().SendErrorToPHP("HttpLoadJson 请求备份php地址回调超时 " + status_str + " 备份地址backurl_account_path = " + url + "   终止该请求");
                        }
                    }
                }, timeout_value);
            }
        };
        RealRequest(base_url, target_url, call_func, timeout_value, !!backup_base_url);
    }
}

window["HttpUtil"] = HttpUtil

import { LayerManager } from "../common/LayerManager";
import { Config } from "../common/Config";
import { GlobalEventSystem, ClientConfig } from "./DeclareGlobalVar";
import { EventName, SceneEventType } from "../common/EventName";
import { WordManager } from "../common/WordManager";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { ErlangParser } from "./ErlangParser";
import { GameError } from "./GameError";
import { HashObject } from "../common/BaseClass";
import { table } from "../common/table";
import { HttpUtil } from "./HttpUtil";
import { md5 } from "./md5";
import { SpecialCharKey } from "../common/SpecialCharKey";
// import { LoginModel } from "../login/LoginModel";

// TypeScript file
export enum DEVICE_OS {
    IOS,
    ANDORID,
    WINDOWS_PC,
    IOS_APP
}
window["DEVICE_OS"] = DEVICE_OS;
export class Util {
    private static _version_msg = "";
    private static _liuhai_height;
    private static _decice_info = null;
    private static _wx_sys_info = null;
    public static is_wxgame_bebug = false;
    public static is_debug = false;
    public static use_ktx = false;
    public static word_fotmat_reg = new RegExp(SpecialCharKey.Util1)

    public static meituan_is_support_recharge = null; //美团是否支持充值
    public static tempVector3 = new Laya.Vector3()
    // static _BasicLayout = new eui.BasicLayout();
    public static GetVersionMsg() {
        return local_Util._version_msg;
    }
    public static SetVersionMsg(msg) {
        local_Util._version_msg = msg || "";
    }
    //设置图片颜色值
    // public static SetUIColor(image?: eui.Image | eui.Button, color: Vector3 = null) {
    //     if (color) {
    //         // 将16进制颜色分割成rgb值
    //         let spliceColor = (color: Vector3) => {
    //             let result = { r: -1, g: -1, b: -1 };
    //             result.r = color.x % 256;
    //             result.g = color.y % 256;
    //             result.b = color.z % 256;
    //             return result;
    //         };
    //         let result = spliceColor(color);
    //         let colorMatrix = [
    //             1, 0, 0, 0, 0,
    //             0, 1, 0, 0, 0,
    //             0, 0, 1, 0, 0,
    //             0, 0, 0, 1, 0
    //         ];
    //         colorMatrix[0] = result.r / 255;
    //         colorMatrix[6] = result.g / 255;
    //         colorMatrix[12] = result.b / 255;
    //         let colorFilter = new egret.ColorMatrixFilter(colorMatrix);
    //         if (image) {
    //             image.filters = [colorFilter];
    //         }
    //         return colorFilter;
    //     }
    //     else {
    //         if (image) {
    //             image.filters = null;
    //         }
    //         return null;
    //     }
    // }
    /**
     * 设置图片描边
     * */
    // public static SetUIStroke(image?: eui.Image | eui.Button, color?, alpha?, blurX?, blurY?, strength?, quality?, inner?, knockout?) {
    //     color = color || 0x33CCFF; /// 光晕的颜色，十六进制，不包含透明度
    //     alpha = alpha || 0.8; /// 光晕的颜色透明度，是对 color 参数的透明度设定。有效值为 0.0 到 1.0。例如，0.8 设置透明度值为 80%。
    //     blurX = blurX || 35; /// 水平模糊量。有效值为 0 到 255.0（浮点）
    //     blurY = blurY || 35; /// 垂直模糊量。有效值为 0 到 255.0（浮点）
    //     strength = strength || 3; /// 压印的强度，值越大，压印的颜色越深，而且发光与背景之间的对比度也越强。有效值为 0 到 255。暂未实现
    //     quality = quality || egret.BitmapFilterQuality.HIGH; /// 应用滤镜的次数，建议用 BitmapFilterQuality 类的常量来体现
    //     inner = inner == null ? true : inner; /// 指定发光是否为内侧发光，暂未实现
    //     knockout = knockout == null ? false : knockout; /// 指定对象是否具有挖空效果，暂未实现
    //     var glowFilter: egret.GlowFilter = new egret.GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
    //     if (image) {
    //         image.filters = [glowFilter];
    //     }
    //     return glowFilter;
    // }
    /**
     * 添加点击需要有动画的点击事件
     * @param showClickMovie 是否显示动画
     * @param is_tap_down_callback 是否按下就回调
     * @param not_contain_obj btn下不触发的对象
     */
    public static AddClickEvent(btn: Laya.UIComponent, call_back: Function, thisObject, showClickMovie: Boolean = false, useCapture?: boolean, priority?: number, is_tap_down_callback = false, not_contain_obj?, show_sound_effect = true) {
        if (btn && btn.parent) {
            let parent = btn.parent, x, y, scaleX, scaleY, pivot_x, pivot_y, anchor_x, anchor_y, left, right, top, bottom, horizontalCenter, verticalCenter, is_validate = false, layout;
            scaleX = btn.scaleX;
            scaleY = btn.scaleY;
            let _setItemChanged
            if (showClickMovie) {
                let onBtnDownHandler = (e: Laya.Event) => {
                    if (not_contain_obj && e.target == not_contain_obj) {
                        return;
                    }
                    if (parent instanceof Laya.LayoutBox) {
                        _setItemChanged = parent["_setItemChanged"]
                        parent["_setItemChanged"] = () => {

                        }
                    }
                    is_validate = true;
                    x = btn.x;
                    y = btn.y;
                    pivot_x = btn.pivotX;
                    pivot_y = btn.pivotY;
                    anchor_x = btn.anchorX || 0;
                    anchor_y = btn.anchorY || 0;
                    left = btn.left;
                    right = btn.right;
                    top = btn.top;
                    bottom = btn.bottom;
                    horizontalCenter = btn.centerX;
                    verticalCenter = btn.centerY;
                    // if (parent.layout) {
                    //     // layout = parent.layout
                    //     // parent.layout = local_Util._BasicLayout
                    //     // includeInLayout = btn.includeInLayout
                    //     // btn.includeInLayout = false
                    //     layout = parent.layout;
                    //     parent.layout = undefined;
                    // }
                    btn.left = NaN;
                    btn.right = NaN;
                    btn.top = NaN;
                    btn.bottom = NaN;
                    btn.centerX = NaN;
                    btn.centerY = NaN;
                    btn.anchorX = 0.5;
                    btn.anchorY = 0.5;
                    if (scaleX > 0) {
                        btn.x = x + (btn.anchorX - anchor_x) * btn.displayWidth;
                    }
                    else {
                        btn.x = x - (btn.anchorX - anchor_x) * btn.displayWidth;
                    }
                    if (scaleY > 0) {
                        btn.y = y + (btn.anchorY - anchor_y) * btn.displayHeight;
                    }
                    else {
                        btn.y = y - (btn.anchorY - anchor_y) * btn.displayHeight;
                    }
                    btn.scaleX = 0.9 * scaleX;
                    btn.scaleY = 0.9 * scaleY;
                    btn.runCallLater(btn["_sizeChanged"]);
                    if (show_sound_effect) {
                        window["SoundManager"].GetInstance().PlaySoundEffect("2_dianji");
                    }
                    // btn.scaleX = 0.98 * scaleX
                    // btn.scaleY = 0.98 * scaleY
                    // egret.Tween.get(btn).to({ scaleX: 0.9 * scaleX, scaleY: 0.9 * scaleY }, 100).call(() => { egret.Tween.removeTweens(btn) })
                    if (is_tap_down_callback && call_back) {
                        call_back(e);
                    }
                };
                let onBtnUpHandler = (e: Laya.Event) => {
                    if (not_contain_obj && e.target == not_contain_obj) {
                        return;
                    }
                    if (!is_validate)
                        return;
                    is_validate = false;
                    // egret.Tween.removeTweens(btn)
                    // egret.Tween.get(btn).to({ scaleX: scaleX, scaleY: scaleY }, 100).call(() => {
                    // egret.Tween.removeTweens(btn)
                    if (_setItemChanged) {
                        parent["_setItemChanged"] = _setItemChanged
                    }
                    btn.scaleX = scaleX;
                    btn.scaleY = scaleY;
                    btn.pivotX = pivot_x;
                    btn.pivotY = pivot_y;
                    btn.anchorX = anchor_x;
                    btn.anchorY = anchor_y;
                    btn.x = x;
                    btn.y = y;
                    btn.left = left;
                    btn.right = right;
                    btn.top = top;
                    btn.bottom = bottom;
                    btn.centerX = horizontalCenter;
                    btn.centerY = verticalCenter;
                    // if (layout)
                    //     // btn.includeInLayout = includeInLayout
                    //     parent.layout = layout;
                    // // if (!is_tap_down_callback && e.type == Laya.Event.TOUCH_END) {
                    // //     if (call_back) {
                    // //         call_back(e)
                    // //     }
                    // // }
                    // // })
                };
                let onBtnTapHandler = (e: Laya.Event) => {
                    if (not_contain_obj && e.target == not_contain_obj) {
                        return;
                    }
                    if (call_back) {
                        call_back(e);
                    }
                };
                let egret_event = Laya.Event;
                btn.on(egret_event.MOUSE_DOWN, thisObject, onBtnDownHandler);
                btn.on(egret_event.MOUSE_UP, thisObject, onBtnUpHandler);
                btn.on(egret_event.MOUSE_OUT, thisObject, onBtnUpHandler);
                // btn.on(egret_event.TOUCH_CANCEL, thisObject, onBtnUpHandler);
                if (!is_tap_down_callback) {
                    btn.on(egret_event.CLICK, thisObject, onBtnTapHandler); //确保时间冒泡机制顺利进行  MOUSE_UP会比TOUCH_TAP先执行
                }
                // btn.once(Laya.Event.REMOVED, (event: egret.Event) => {
                //     btn.off(Laya.Event.MOUSE_DOWN, thisObject, onBtnDownHandler, useCapture);
                //     btn.off(Laya.Event.MOUSE_UP, thisObject, onBtnUpHandler, useCapture);
                //     btn.off(Laya.Event.MOUSE_OUT, thisObject, onBtnUpHandler, useCapture);
                //     // btn.off(Laya.Event.TOUCH_CANCEL, thisObject, onBtnUpHandler, useCapture);
                //     if (!is_tap_down_callback) {
                //         btn.off(Laya.Event.CLICK, thisObject, onBtnTapHandler, useCapture);
                //     }
                // thisObject, });
            }
            else {
                btn.on(Laya.Event.CLICK, thisObject, call_back);
                // btn.once(Laya.Event.REMOVED, thisObject, (event: Laya.Event) => {
                //     btn.off(Laya.Event.CLICK, thisObject, call_back);
                // })
            }
        }
    }
    // private static GrayFilter = new egret.ColorMatrixFilter([
    //     0.3, 0.6, 0, 0, 0,
    //     0.3, 0.6, 0, 0, 0,
    //     0.3, 0.6, 0, 0, 0,
    //     0, 0, 0, 1, 0
    // ]);
    // private static WhiteFilter = new egret.ColorMatrixFilter([
    //     1, 0, 0, 0, 0,
    //     0, 1, 0, 0, 0,
    //     0, 0, 1, 0, 0,
    //     0, 0, 0, 1, 0
    // ]);
    // /**
    //  * 组件置灰
    //  * @param component 需要置灰的组件
    //  * @param bool 是否置灰
    //  */
    // public static SetImageGray(component?: any, bool?: Boolean) {
    //     if (bool) {
    //         if (component) {
    //             component.filters = [local_Util.GrayFilter];
    //         }
    //         return local_Util.GrayFilter;
    //     }
    //     else {
    //         if (component) {
    //             component.filters = null;
    //         }
    //         return null;
    //     }
    // }

    public static SetImageGray(component: Laya.UIComponent, bool: boolean) {
        if (component) {
            component.gray = bool
        }
    }
    //判断字典表是否长度为0
    public static IsTableEmpty(table) {
        if (table) {
            for (let i in table) {
                if (table[i] != null) {
                    return false;
                }
            }
        }
        return true;
    }
    //获取table长度 
    //judge_value 是否判断表的值
    public static TableSize(table, judge_value: boolean = false) {
        let len = 0;
        if (table) {
            if (judge_value) {
                let obj
                for (let index in table) {
                    obj = table[index]
                    if (obj) {
                        len++;
                    }
                }
            } else {
                for (let index in table) {
                    len++;
                }
            }

        }
        return len;
    }
    //无符号的32位转换成有符号的32位
    public static UnsignToSigned(number) {
        if (number >= 4000000000) //无符号的数大于这个数默认为负数了
            return -1 * ~(number - 1);
        else
            return number;
    }
    public static ErrorCodeShow(code, strParam?: string) {
        window["ResManager"].GetInstance().GetGameConfigWithAutoDestory("config_error_code", (cfg) => {
            let tmp = cfg[code];
            let str = `未知返回码 ${code}`;
            if (tmp) {
                str = tmp.about ? tmp.about : tmp;
                if (strParam) {
                    let args = strParam.split("#&");
                    let v: string;
                    for (let i = 0; i < args.length; i++) {
                        v = args[i];
                        str = str.replace("{" + (i + 1) + "}", v);
                    }
                }
            }

            let bagJumpCodeId = [1500003, 1500112, 1500113, 1500031, 1500131, 1500132, 1500133, 1500134,
                1500135, 1500137, 6220002, 3000010, 4010004, 4160000, 4160001, 1500101, 1810022, 2330014]
            if (bagJumpCodeId.indexOf(code) > -1) {
                GlobalEventSystem.Fire(EventName.JUMP_VIEW_TO_CLEAN_BAG, code, str);
                return
            }
            let Message = window["Message"]
            Message.show(str);
        }, false);
    }
    //随机数
    public static RandomRange(min: number = 0, max: number = 1) {
        return Math.floor(Math.random() * (max - min + 1) + min);
    }
    public static Clamp = (min, max, n) => Math.max(min, Math.min(max, n));
    //字符串添加颜色
    // public static HtmlColorTxt(content: string, color: number): string;
    // public static HtmlColorTxt(content: string, color: string): string;
    // public static HtmlColorTxt(content: string, color: Enum_ColorUtil): string;
    public static HtmlColorTxt(content: number | string, color: number | string) {
        // if (typeof color == "string")
        //     return `<font color=${color}>${content}</font>`
        // else if (typeof color == "number")
        //     return `<font color=${color}>${content}</font>`
        return `<font color=${color}>${content}</font>`;
    }
    public static HtmlCrudetxt(content) {
        return `<b>${content}</b>`;
    }
    //转换成HTML样式
    public static StrToHTML(content: string) {
        //  return (new Laya.HtmlTextParser).parse(content);
        //暂时返回原字符串
        return content
    }
    //字符串添加颜色 转换成HTML样式
    // public static ColorTxtToHTML(content: string, color: number): egret.ITextElement[];
    // public static ColorTxtToHTML(content: string, color: string): egret.ITextElement[];
    // public static ColorTxtToHTML(content: number | string, color: number | string): egret.ITextElement[] {
    // return (new egret.HtmlTextParser).parse(local_Util.HtmlColorTxt(content, color));
    // }
    //获得玩吧渠道编号
    public static GetWBGamePackageCode() {
        let package_code;
        let plat_fome = ""// PlatformManager.GetPlatformName();
        if (plat_fome.search("yy_sh921_lj_qq_P0007292") != -1)
            package_code = "P0007292";
        else if (plat_fome.search("yy_sh921_lj_qq_ios_P0007291") != -1)
            package_code = "P0007291";
        return package_code;
    }

    public static SetLargeScreenImageSize(obj: Laya.Image, img_width, img_height) {
        if (!Laya.Browser.onPC && obj) {//!Laya.Browser.onPC &&
            let stage = LayerManager.GetInstance().stage;
            if (stage.width / stage.height > 870 / 1560) {
                obj.width = stage.width;
                obj.height = img_height * (stage.width / img_width);
            } else if (stage.width / stage.height < 720 / 1280) {
                obj.height = stage.height;
                obj.width = img_width * (stage.height / img_height);
            }
        }
    }
    //获取设备系统
    public static GetDeviceOS() {
        let curr_os = -1;
        if (local_Util.IsWXGame() || local_Util.IsQQGame()) {
            if (!local_Util._wx_sys_info && window["wx"] && window["wx"].getSystemInfoSync) {
                let sys_info = window["wx"].getSystemInfoSync();
                local_Util._wx_sys_info = sys_info;
            }
            if (local_Util._wx_sys_info) {
                if (local_Util._wx_sys_info.system.indexOf("Android") >= 0 || local_Util._wx_sys_info.system.indexOf("android") >= 0) {
                    curr_os = DEVICE_OS.ANDORID;
                }
                else {
                    curr_os = DEVICE_OS.IOS;
                }
            }
        } else if (local_Util.IsBaiduGame()) {
            let sys_info = window["swan"] && window["swan"].getSystemInfoSync();
            if (sys_info) {
                if (sys_info.system.indexOf("Android") >= 0) {
                    curr_os = DEVICE_OS.ANDORID;
                }
                else {
                    curr_os = DEVICE_OS.IOS;
                }
            }
        } else if (local_Util.IsQuickGame()) {
            curr_os = DEVICE_OS.ANDORID;
        } else {
            // let os = window["Capabilities_os"] || egret.Capabilities.os;
            // if (os == "iOS") {
            //     if (egret.Capabilities.runtimeType == egret.RuntimeType.RUNTIME2) {
            //         curr_os = DEVICE_OS.IOS_APP;
            //     }
            //     else {
            //         curr_os = DEVICE_OS.IOS;
            //     }
            // }
            // else if (os == "Android") {
            //     curr_os = DEVICE_OS.ANDORID;
            // }
            // else if (os == "Windows PC") {
            //     curr_os = DEVICE_OS.WINDOWS_PC;
            // }
        }
        return curr_os;
    }
    //深拷贝对象
    public static DeepCopy(source) {
        var result: any;
        if (source) {
            // //  let _type = Object.getPrototypeOf(source) 
            // //  if (_type && _type.constructor.name == "Array"){
            // if (Array.isArray(source)) {
            //     result = [];
            // }
            // else {
            //     result = {};
            // }
            // for (var key in source) {
            //     result[key] = typeof source[key] == 'object' ? local_Util.DeepCopy(source[key]) : source[key];
            // }

            result = JSON.parse(JSON.stringify(source))
        }
        return result;
    }
    public static coe_arr = {
        "1": 10,
        "2": 0.5,
        "3": 10,
        "4": 10,
        "5": 10,
        "6": 10,
        "7": 5,
        "8": 5,
        "15": 10,
        "16": 10,
        "18": 0,
        "46": 7.5,
        "47": 7.5,
        "300": 1,
        "301": 1,
        "302": 1,
        "303": 1,
        "304": 1,
        "305": 1,
        "306": 1,
        "307": 1,
        "308": 1,
    };
    //特别的属性战力计算
    private static special_coe_arr = {
        "9": { "contain": ["att", "wreck"], "ratio": 80 },
        "10": { "contain": ["hp", "def"], "ratio": 80 },
        "11": { "contain": ["att", "wreck"], "ratio": 100 },
        "12": { "contain": ["hp", "def"], "ratio": 100 },
        "13": { "contain": ["att", "wreck"], "ratio": 100 },
        "14": { "contain": ["att", "wreck"], "ratio": 100 },
        "17": { "contain": ["att", "wreck"], "ratio": 50 },
        "19": { "contain": ["att", "wreck"], "ratio": 30 },
        "20": { "contain": ["hp", "def"], "ratio": 30 },
        "21": { "contain": ["att", "wreck"], "ratio": 20 },
        "22": { "contain": ["hp", "def"], "ratio": 20 },
        "23": { "contain": ["att", "wreck"], "ratio": 5 },
        "24": { "contain": ["hp", "def"], "ratio": 5 },
        "25": { "contain": ["hp", "def"], "ratio": 50 },
        "27": { "contain": ["att", "wreck"], "ratio": 30 },
        "28": { "contain": ["hp", "def"], "ratio": 10 },
        "29": { "contain": ["att", "wreck"], "ratio": 50 },
        "39": { "contain": ["hp", "def"], "ratio": 50 },
    };
    /**
     * 获取技能战力
     */
    public static GetSkillPower(skill_id: string | number, skill_lv: number) {
        let skill_cfg = Config.PRELOAD_SERVER_CONFIG.config_skill[skill_id];
        if (!skill_cfg)
            return 0;
        let lv_data = JSON.parse(skill_cfg.lv_data);
        if (!lv_data)
            return 0;
        let index = Math.max(skill_lv - 1, 0);
        if (!lv_data[index])
            return 0;
        lv_data = lv_data[index];
        if (lv_data.power == "0") {
            let list = [];
            for (let info of lv_data.base_attr) {
                let data = info.split(",");
                list.push([data[1], data[2]]);
            }
            return local_Util.CalAttrPower(list, false);
        }
        else {
            return lv_data.power;
        }
    }
    /**
     * 计算战斗力
     * @param attr_list 数据
     * @param isJson 是否JSON格式
     * @param point 倍率
     */
    public static CalAttrPower(attr_list, need_json_parse: boolean = true, need_erlang_parse: boolean = false) {
        //简单的一些属性 战斗力计算比例 （负责的另外算，如伤害加深 = （玩家攻击，破甲所得战力 * 80%）* 伤害加深数值）
        // let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
        let RoleManager = window["RoleManager"]
        let power = 0, coe_arr_val, special_coe_arr_val, role = RoleManager.GetInstance().mainRoleInfo;
        if (Object.prototype.toString.call(attr_list) === "[object String]") {
            if (need_json_parse)
                attr_list = JSON.parse(attr_list);
            if (need_erlang_parse) {
                attr_list = ErlangParser.GetInstance().parse(attr_list);
            }
        } else {
            attr_list = this.DeepCopy(attr_list);
        }
        //特殊类型的战力计算 如：伤害加深 = （玩家攻击，破甲所得战力 * 80%）* 伤害加深数值
        let CalSpecialAttrPower = (val) => {
            let value = 0;
            let arr_tmp;
            special_coe_arr_val = local_Util.special_coe_arr[val[0]];
            if (special_coe_arr_val) {
                for (let attr_id of special_coe_arr_val.contain) {
                    if (role && role[attr_id] != undefined) {
                        value += role[attr_id];
                    }
                }
                value = value * (special_coe_arr_val.ratio / 100) * (val[1] / 10000);
            }
            return value;
        };
        for (let val of attr_list) {
            // coe_arr_val = cfg[val[0]]
            // if (!coe_arr_val) continue
            // coe_arr_val = coe_arr_val.cal_ratio
            // power += coe_arr_val * val[1]
            coe_arr_val = local_Util.coe_arr[val[0]];
            if (coe_arr_val) {
                power += coe_arr_val * val[1];
            }
            else {
                power += CalSpecialAttrPower(val);
            }
        }
        return Math.round(power);
    }
    //是否包含屏蔽词
    public static HasFilterWord(msg: string, language_cfg = null, filter_callback = null, scene = 3) {
        let has_filter_word = false
        let plat_mgr = window["PlatformManager"].GetInstance()
        if (local_Util.IsWXGame() && window[plat_mgr.sdk_name]) {
            if (!window["PlatformManager"].IsSiLangPlatform()) {
                scene = 3
            }
            let query = {
                content: msg,
                scene: scene
            }
            window[plat_mgr.sdk_name]["checkMsgSec"](function (res) {
                console.log(plat_mgr.sdk_name + '小程序敏感内容 ' + msg + ' 检测返回', res);
                if (res && ((res.data && res.data.result && res.data.result.label == 100) || (res.result && res.result.label == 100))) {
                    has_filter_word = false
                } else {
                    has_filter_word = true
                }
                if (filter_callback) {
                    filter_callback(has_filter_word)
                }
            }, query);
            return
        } else if (plat_mgr.link_is_check_word && window[plat_mgr.sdk_name]) {
            let query = {
                cnt: msg,
                is_check_word: 1
            }
            window[plat_mgr.sdk_name]["checkWord"](query, function (res) {
                console.log(plat_mgr.sdk_name + '链接端敏感内容检测返回', res);
                if (local_Util.IsTableEmpty(res)) {
                    has_filter_word = false
                } else {
                    has_filter_word = true
                }
                if (filter_callback) {
                    filter_callback(has_filter_word)
                }
            });
            return
        } else if (local_Util.IsQQGame()) {
            let package_code = plat_mgr.GetQQPackageCode();
            if (!package_code || !ClientConfig.msg_sec_check_php) {
                if (filter_callback) {
                    filter_callback(false);
                }
                return;
            }
            let cur_time = String(Math.floor(new Date().getTime() / 1000)),
                login_key = window["LoginModel"].LoginKey,
                now_method = "word",
                get_params = {
                    "time": cur_time,
                    "sign": md5.hex_md5(String(login_key + cur_time + now_method)).toLowerCase(),
                    "method": now_method,
                    "game": "jzy",
                    "package_code": package_code,
                    "content": msg,
                };
            let call_func = (data) => {
                console.log('QQ敏感内容检测返回', data);
                if (data) {
                    data = JSON.parse(data);
                    has_filter_word = data.code != 0
                }
                if (filter_callback) {
                    filter_callback(has_filter_word)
                }
            };
            /**time=1569147732&sign=facf1869109662cd06fb2696e5baea30&method=word&game=jzy */
            HttpUtil.HttpGetRequest(ClientConfig.msg_sec_check_php, get_params, call_func);
            return
        } else if (Util.IsKSGame()) {
            let call_func = (e) => {
                //{"data":{"errcode":"0","errmsg":"ok","result":{"suggest":"pass","label":100}}}
                //判断data.result.label 是否等于100，非100代表当前内容是屏蔽词
                console.log("------checkMsgSec------", msg, e)
                has_filter_word = e.data.result.label != 100
                if (filter_callback) {
                    filter_callback(has_filter_word)
                }
            }
            window["ShSdk"].checkMsgSec(call_func, {
                content: msg
            })
            return
        } else if (language_cfg) {
            //去掉特殊符号和空格再匹配
            msg = msg.replace(local_Util.word_fotmat_reg, "");
            for (let word of language_cfg) {
                if (msg.indexOf(word) != -1) {
                    has_filter_word = true
                    break
                }
            }
        }
        if (filter_callback) {
            filter_callback(has_filter_word)
        }
    }
    // //替换屏蔽词为*号
    // public static FilterMsg(msg: string) {
    //     if (PlatformManager.GetInstance().is_alpha || PlatformManager.GetInstance().need_alpha_open_charge) {
    //         if (Config.PRELOAD_CLIENT_CONFIG.ConfigLanguageMaskAlpha) {
    //             for (let word of Config.PRELOAD_CLIENT_CONFIG.ConfigLanguageMaskAlpha) {
    //                 if (msg.indexOf(word) != -1)
    //                     msg = msg.replace(word, new Array(word.length + 1).join("*"))
    //             }
    //         }
    //     } else {
    //         if (Config.PRELOAD_CLIENT_CONFIG.ConfigLanguageMask) {
    //             for (let word of Config.PRELOAD_CLIENT_CONFIG.ConfigLanguageMask) {
    //                 // msg = msg.replace(word, new Array(word.length + 1).join("*"))
    //                 // let word = `,${Config.PRELOAD_CLIENT_CONFIG.ConfigLanguageMask.content},`
    //                 if (msg.indexOf(word) != -1)
    //                     msg = msg.replace(word, new Array(word.length + 1).join("*"))
    //             }
    //         }
    //     }
    //     return msg
    // }
    /**
     * 2个属性合成一个数组[[id,value],[id2,value2]]
     */
    public static addAttrList(attr_list1: any, attr_list2: any): any {
        let attDic = {};
        let attList: Array<any> = [];
        for (let attr1 of attr_list1) {
            attDic[attr1[0]] = attr1;
        }
        for (let attr2 of attr_list2) {
            attList = attDic[attr2[0]];
            if (!attList)
                attList = attr2;
            else
                attList[1] = attList[1] + attr2[1];
            attDic[attList[0]] = attList;
        }
        let newList: Array<any> = [];
        for (let key in attDic) {
            if (attDic.hasOwnProperty(key)) {
                let att = attDic[key];
                // att[1] = att[1];
                newList.push(att);
            }
        }
        return newList;
    }
    public static LoadScript(url: string, load_completed_call_back?) {
        var s = document.createElement('script');
        s.async = false;
        s.src = url;
        let call_back = () => {
            s.parentNode.removeChild(s);
            s.removeEventListener('load', call_back, false);
            if (load_completed_call_back) {
                load_completed_call_back();
            }
            // window["ShSdk"].login(() =>{});
        };
        s.addEventListener('load', call_back, false);
        document.body.appendChild(s);
    }
    //注册目标属性改变事件
    public static RegisterPropertyChangeEvent(target: any, property: string, call_back) {
        // if (target && property) {
        //     if (!target[`${property}_watcher`]) {
        //         let watcher = eui.Watcher.watch(target, [property], () => {
        //             if (call_back) {
        //                 call_back();
        //             }
        //         }, this);
        //         target[`${property}_watcher`] = watcher;
        //     }
        //     if (!target[`$stage_watcher`]) {
        //         let watcher = eui.Watcher.watch(target, ["$stage"], () => {
        //             if (!target.$stage) {
        //                 watcher.unwatch();
        //                 delete target["$stage_watcher"];
        //                 for (let pro in target) {
        //                     if (target.hasOwnProperty(pro) && pro.substring(pro.length - 8, pro.length) == "_watcher") {
        //                         let w = target[pro];
        //                         if (w && w instanceof eui.Watcher) {
        //                             w.unwatch();
        //                             delete target[pro];
        //                         }
        //                     }
        //                 }
        //             }
        //         }, this);
        //         target[`$stage_watcher`] = watcher;
        //     }
        // }
    }
    //当滚动条里的项目高度不相等的时候 初始化list的时候调用一下这个接口
    // public static OptimizeInequalHeightScroll(list: eui.List) {
    //     if (!list["scrollV_watcher"]) {
    //         list.useVirtualLayout = false;
    //         local_Util.RegisterPropertyChangeEvent(list, "scrollV", (value) => {
    //             let len = list.numChildren;
    //             let item: eui.UIComponent;
    //             let curr_h = 0;
    //             let scrollV = list.scrollV;
    //             let height = list.height;
    //             for (let i = 0; i < len; i++) {
    //                 item = list.getVirtualElementAt(i);
    //                 if (item) {
    //                     if ((item.y + item.height) <= scrollV || item.y > (scrollV + height)) {
    //                         item.touchEnabled = item.visible = false;
    //                     }
    //                     else {
    //                         item.touchEnabled = item.visible = true;
    //                     }
    //                 }
    //             }
    //         });
    //         list.scrollV = list.scrollV + 0.00001; //默认触发一下
    //     }
    // }
    /**
     * 飘特效
     * @param beginObj 起点对象
     * @param endObj 终点对象
     * @param x      终点x(必须全局坐标)
     * @param y      终点y(必须全局坐标)
     * @param call_back 回调
     * @param scalx  缩放x
     * @param scalY  缩放y
     * @param duration 缓动时间
     */
    public static flyTo(beginObj, endObj?, x?, y?, call_back?, scalx = 0, scaly = 0, duration = 800): void {
        // if (!endObj && (!x || !y))
        //     return;
        // let endPoint;
        // let endx = 0;
        // let endy = 0;
        // if (endObj) {
        //     endPoint = endObj.localToGlobal();
        //     endx = endPoint.x + endObj.width / 2;
        //     endy = endPoint.y + endObj.height / 2;
        // }
        // else if (x && y) {
        //     endx = x;
        //     endy = y;
        // }
        // else
        //     return;
        // endPoint = beginObj.parent == LayerManager.GetInstance().stage ? endPoint : beginObj.parent.globalToLocal(endx, endy);
        // egret.Tween.get(beginObj).to({ x: endPoint.x, y: endPoint.y, scaleX: scalx, scaleY: scaly }, duration, egret.Ease.circOut).call(() => {
        //     if (call_back)
        //         call_back();
        //     egret.Tween.removeTweens(beginObj);
        // });
    }
    /**
     * 飘底部ICON
     * @param beginobj 起点对象
     * @param icontype 底部icon的类型 例如: MainFunc.Role
     * @param call_back 回调
     * @param scalx  缩放x
     * @param scalY  缩放y
     * @param duration 缓动时间
     */
    public static flyToDownUIIcon(beginobj, icontype, call_back?, scalx = 0, scaly = 0, duration = 800): void {
        let obj = { beginobj: beginobj, icontype: icontype, call_back: call_back, scalx: scalx, scaly: scaly, duration: duration };
        GlobalEventSystem.Fire(EventName.FLY_TO_ICON, obj);
    }
    /**
     * 总的旋转角度(指针)
     * @param Scores 转盘拆分份数
     * @param Skew 第一个奖区起始点与0点位置的偏移比例
     * @param Qmin 转过最少圈数
     * @param Qmax 转过最多圈数
     * @param awardPosition 奖品所在奖区
     * @param offset 指针所停位置离奖区边缘的比例(占一格的比例)
     * @return 总的旋转角度
     * 例如：getRotationLong(13,-0.5,15,18,Math.random()*13,0.5)
     */
    public static getRotationLong(Scores: number, Skew: number, Qmin: number, Qmax: number, awardPosition: number, offset: number): number {
        var _q: number = 360 * (Math.floor(local_Util.RandomRange(0, 1) * (Qmax - Qmin)) + Qmin); //整圈圈数
        var _Skew: number = (360 / Scores) * Skew; //第一个奖区起始点与0点位置的偏移比例
        var _location: number = (360 / Scores) * awardPosition; //目标奖区的起始点
        var _offset: number = (360 / Scores) * offset;
        return _q + _Skew + _location + _offset;
    }
    /**
     * 总的旋转角度(转盘)
     * @param Scores 转盘拆分份数
     * @param Skew 第一个奖区起始点与0点位置的偏移比例
     * @param Qmin 转过最少圈数
     * @param Qmax 转过最多圈数
     * @param awardPosition 奖品所在奖区
     * @param offset 指针所停位置离奖区边缘的比例(占一格的比例)
     * @return 总的旋转角度
     * 例如：getRotationLong(13,-0.5,15,18,Math.random()*13,0.5)
     */
    public static getRotationLong2(Scores: number, Skew: number, Qmin: number, Qmax: number, awardPosition: number, offset: number): number {
        var _q: number = 360 * (Math.floor(local_Util.RandomRange(0, 1) * (Qmax - Qmin)) + Qmin); //整圈圈数
        var _Skew: number = (360 / Scores) * Skew; //第一个奖区起始点与0点位置的偏移比例
        var _location: number = 360 - (360 / Scores) * awardPosition; //目标奖区的起始点
        var _offset: number = (360 / Scores) * offset;
        return _q + _Skew + _location + _offset;
    }
    public static PrintNotDeleteMeItem(target) {
        // if (local_Util.IsDebug()) {
        //     let checkNoDeleteItem = (obj: BaseComponent, contain?) => {
        //         for (let key in obj) {
        //             if (obj[key]) {
        //                 if (obj[key] instanceof BaseComponent) {
        //                     let SceneObj = window["SceneObj"]
        //                     let NameBoard = window["NameBoard"]
        //                     if (!(obj[key] instanceof SceneObj) && key != "_parent") {//|| obj[key] instanceof NameBoard
        //                         if (!obj[key].use_delete_method) {
        //                             let Alert = window["Alert"]
        //                             Alert.RepeatShow((obj["constructor"].name || contain["constructor"].name) + "." + obj[key]["constructor"].name + "\n没有调用DeleteMe");
        //                             checkNoDeleteItem(obj[key]);
        //                         }
        //                     }
        //                 }
        //                 else if (typeof obj[key] == "object" || Array.isArray(obj[key]))
        //                 // }else if(Array.isArray(obj[key]))
        //                 {
        //                     let state = true;
        //                     for (let i in obj[key]) {
        //                         if (obj[key] && !(obj[key][i] instanceof BaseComponent)) {
        //                             state = false;
        //                             break;
        //                         }
        //                     }
        //                     if (state) {
        //                         checkNoDeleteItem(obj[key], obj);
        //                     }
        //                 }
        //             }
        //         }
        //     };
        //     egret.callLater(checkNoDeleteItem, this, target);
        // }
    }
    //删除游戏启动界面
    public static RemoveGameStartLoading() {
        if (local_Util.IsMiniGame()) {
            let loading_view = window["wxLoadingView"];
            if (loading_view) {
                if (local_Util.IsTTGame() || local_Util.IsMTGame() || local_Util.IsBiliBiliGame()) {
                    window["wxLoadingView"].scaleX = 0;
                }
                else {
                    loading_view.destroy()
                    window["wxLoadingView"] = null;
                }
            }

            if (local_Util.IsUCGame()) {
                var d = document.getElementById("loadingDiv");
                if (d) {
                    document.body.removeChild(d);
                }
            }
        }
        else if (local_Util.IsConch()) {
            let loading_view = window["loadingView"];
            if (loading_view && loading_view["hideLoadingView"]) {
                // loading_view.parent.setChildIndex(loading_view, 999);
                loading_view["hideLoadingView"]();
            }
        }
        else {
            var d = document.getElementById("loadingDiv");
            if (d) {
                document.body.removeChild(d);
            }
        }
        if (window["timeSi"]) {
            clearInterval(window["timeSi"]);
            window["timeSi"] = null;
        }
    }
    //删除版本号提示
    public static RemoveVersionText() {
        if (local_Util.IsMiniGame()) {
            let version_text = window["version_text"];
            if (version_text) {
                if (local_Util.IsTTGame() || local_Util.IsBiliBiliGame()) {
                    window["version_text"].scaleX = 0;
                }
                else {
                    version_text.removeSelf()
                    window["version_text"] = null;
                }
            }
        }
        else {
            var d = document.getElementById("version_text");
            if (d) {
                // d.style.top = "0%"
                // d.style.left = "0%"
                document.body.removeChild(d);
            }
        }
    }
    //是否是原生项目
    // public static IsRuntime2() {
    //     return window["runtime2"]; //egret.Capabilities.runtimeType == egret.RuntimeType.RUNTIME2
    // }
    //是否本地调试模式
    public static IsDebug() {
        return local_Util.is_debug
        // return DEBUG && !local_Util.IsMiniGame();
        // return !LoginModel.GetInstance().plat_name// Laya.Browser.onPC &&  GameConfig.debug
    }
    //是否wxgame的调试版
    public static IsWXGameDebug() {
        return local_Util.is_wxgame_bebug;
    }
    //是否webgl渲染模式
    public static IsWebGLRenderMode() {
        // return egret.Capabilities.renderMode == "webgl";
        return false
    }
    //是否canvas渲染模式
    public static IsCanvasRenderMode() {
        // return egret.Capabilities.renderMode == "canvas";
        return false
    }
    public static IsWXGame() {
        return Laya.Browser.onMiniGame && !Util.IsKSGame() && !Util.IsMTGame()
    }

    public static IsKSGame() {
        //@ts-ignore
        return typeof KSGameGlobal != 'undefined'
    }

    //是否在原生端
    public static IsConch() {
        return window["conch"]
    }
    //是否在IOS原生端
    public static IsIOSConch() {
        return Util.IsConch() && window["conchConfig"].getOS() == "Conch-ios"
    }
    //字节跳动
    public static IsTTGame() {
        return Laya.Browser.onTTMiniGame
    }
    //bilibili
    public static IsBiliBiliGame() {
        return Laya.Browser.onBLMiniGame
    }
    //美团
    public static IsMTGame() {
        return window["mt"];
    }
    //QQ小游戏
    public static IsQQGame() {
        return Laya.Browser.onQQMiniGame
    }
    //百度小游戏
    public static IsBaiduGame() {
        return false
        // return egret.Capabilities.runtimeType == egret.RuntimeType.BAIDUGAME;
    }
    //是否华为快游戏
    public static IsHuaweiFastGame() {
        return false//window["hbs"];
    }
    //是否是魅族快游戏
    public static IsMeiZuFastGame() {
        //@ts-ignore
        return Laya.Browser.onMZMiniGame
    }
    //是否OPPO快游戏
    public static IsOPPOFastGame() {
        return Laya.Browser.onQGMiniGame
    }
    //是否Vivo快游戏
    public static IsVivoFastGame() {
        return Laya.Browser.onVVMiniGame
    }
    //是否小米快游戏
    public static IsMiFastGame() {
        return Laya.Browser.onKGMiniGame
    }
    //是否uc小游戏
    public static IsUCGame() {
        return window["uc"];
    }
    //是否小游戏  包括微信小游戏 华为快游戏等所有快游戏
    public static IsMiniGame() {
        return local_Util.IsWXGame()
            || local_Util.IsQQGame()
            || local_Util.IsQuickGame()
            || local_Util.IsUCGame()
            || local_Util.IsBiliBiliGame()
            || local_Util.IsKSGame()
            || local_Util.IsMTGame()
            || local_Util.IsTTGame()
    }
    //是否需要调整钻石金币位置  华为快游戏等所有快游戏 vivo
    public static IsTranPos() {
        return false
    }
    //是否快游戏  包括华为，oppo，魅族等快游戏
    public static IsQuickGame() {
        return local_Util.IsOPPOFastGame() || local_Util.IsVivoFastGame() || local_Util.IsMiFastGame() || local_Util.IsMeiZuFastGame()
    }
    //是否需要读本地,目前英文原生包ios审核服用
    public static IsNeedLoadLocal() {
        return false
        // return local_Util.IsRuntime2() && window["PlatformManager"].GetInstance().is_wx_alpha && ClientConfig.need_load_local;
    }
    //设置渲染分辨率
    public static SetRenderResolution(ratio: number) {
        // if (egret.sys.DisplayList.$canvasScaleFactor != ratio) {
        //     egret.sys.DisplayList.$canvasScaleFactor = ratio;
        //     egret.updateAllScreens();
        // }
    }

    public static GetLiuhaiHeight(stage?: Laya.Stage) {
        if (local_Util._liuhai_height == null) {
            if (ClientConfig && !ClientConfig.nuUse_liuhai && Laya.Browser.onMobile) {
                let stage = Laya.stage
                let ratio = stage.height / stage.width;
                if (ratio >= 2) {
                    local_Util._liuhai_height = 60
                }
            }
            if (local_Util._liuhai_height == null)
                local_Util._liuhai_height = 0
        }
        return local_Util._liuhai_height
    }
    public static ShowFPS() {
        let list = document.querySelectorAll(".egret-player");
        if (list && list[0]) {
            let temp = list[0]["egret-player"];
            if (temp) {
                let player = temp.player;
                if (player) {
                    let fpsStyle = { bgAlpha: "0.5", size: 12, textColor: "0xffffff", x: 0, y: 200 };
                    player.displayFPS(true, false, false, fpsStyle);
                }
            }
        }
    }
    public static ShowCongratulationView(reward_list, time?) {
        if (!reward_list || reward_list.length == 0)
            return;
        let vo = reward_list[0];
        if (vo.typeId != undefined) {
            for (let obj of reward_list) {
                obj[0] = obj.style;
                obj[1] = obj.typeId;
                obj[2] = obj.count;
            }
        }
        let view = new window["CongratulationObtainView"](reward_list, time)
        view.Open()
    }

    public static ShowDrop(reward_list, pos, call_back?, role_id?, show_type?) {
        if (reward_list && reward_list.length > 0) {
            let reward = reward_list[0]
            let list

            if (reward.vo) {
                list = []
                for (let reward of reward_list) {
                    table.insert(list, [
                        reward.vo.style,
                        reward.vo.typeId,
                        1,
                    ])
                }
            }
            else if (reward.typeId != null) {
                list = []
                for (let reward of reward_list) {
                    table.insert(list, [
                        reward.style,
                        reward.typeId,
                        1,
                    ])
                }
            } else {
                list = reward_list
            }

            if (show_type == null) {
                show_type = 2
            }

            let vo = {
                map_id: window["SceneManager"].GetInstance().GetSceneId(),
                drop_list: []
            }

            if (role_id == null) {
                role_id = window["RoleManager"].GetInstance().GetMainRoleId()
            }

            // let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods
            let login_real_ratio = window["SceneObj"].GetLogicRealRatio()
            for (let i = 0; i < list.length; i++) {
                let reward = list[i]
                let local_showType = show_type
                window["Drop"].ClientCount++
                // 如果在reward_list里面有设置show_type会优先使用
                if (reward_list[i].show_type != null) {
                    local_showType = reward_list[i].show_type
                }

                let random_x = pos.x + (Math.random() - 0.5) * 300
                let random_y = pos.y + (Math.random() - 0.5) * 300
                //bao xiang diao luo yao pan duan zhang ai qu
                if (local_showType == 0) {
                    let logic_x = random_x / login_real_ratio.x
                    let logic_y = random_y / login_real_ratio.y
                    if (window["SceneManager"].GetInstance().IsBlockXY(logic_x, logic_y)) {
                        let pos = window["SourceOperateMove"].FindNoBlockPos(new window["Vector2"](logic_x, logic_y))
                        random_x = pos.x * login_real_ratio.x
                        random_y = pos.y * login_real_ratio.y
                    }
                }
                table.insert(vo.drop_list, {
                    drop_id: window["Drop"].ClientCount,
                    drop_type: reward[0],
                    type_id: reward[1],
                    drop_num: 1,
                    camp: 0,
                    team_id: 0,
                    server_id: 0,
                    role_id: role_id,
                    show_type: local_showType,
                    mon_pos_x: pos.x,
                    mon_pos_y: pos.y,
                    pos_x: random_x,
                    pos_y: random_y,
                    is_fake: true
                })
            }

            GlobalEventSystem.Fire(SceneEventType.DEAL_WITH_SCENE_DROP_LIST_VO, vo)
            if (call_back)
                setTimeout(call_back, 2500)
        }
    }

    public static CheckDevice(check_name: string) {
        if (!local_Util._decice_info) {
            let canvas = document.createElement('canvas');
            let gl = canvas.getContext('experimental-webgl');
            if (!gl)
                return false;
            // let debugInfo = gl.getExtension('WEBGL_debug_renderer_info');
            // local_Util._decice_info = gl.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL);
        }
        if (check_name == "iphonex") {
            if ((local_Util._decice_info.indexOf("Apple") > -1 && local_Util._decice_info.indexOf("A11") > -1) && (window.screen.width == 375 && window.screen.height == 812)) {
                return true;
            }
        }
        else if (check_name == "iphone8") {
            if ((local_Util._decice_info.indexOf("Apple") > -1 && local_Util._decice_info.indexOf("A11") > -1) && (window.screen.width == 375 && window.screen.height == 667)) {
                return true;
            }
        }
        return false;
    }
    public static CheckMoney(value, call_back?, is_bind_diamond = true, not_show = true, go_to_recharge?) {
        let RoleManager = window["RoleManager"]
        let bool = false, vo = RoleManager.GetInstance().GetMainRoleVo(), bind_diamond = vo.jinLock, diamond = vo.jin;
        let go_to_recharge_func = () => {
            if (not_show)
                return;
            else {
                if (go_to_recharge)
                    go_to_recharge()
            }

        };
        if (is_bind_diamond) {
            if (value > bind_diamond) {
                if (value > bind_diamond + diamond) {
                    go_to_recharge_func();
                }
                else {
                    let Alert = window["Alert"], Alert_Type = window["Alert_Type"]
                    Alert.Show("绑玉不足是否使用勾玉代替？", Alert_Type.Two, () => {
                        call_back();
                    });
                    Alert.SetIsCharge(true)
                }
            }
            else {
                bool = true;
            }
        }
        else {
            if (value > diamond) {
                go_to_recharge_func();
            }
            else {
                bool = true;
            }
        }
        return bool;
    }
    // static SetGoodsIcon(img: eui.Image, style, type_id, self) {
    // }
    public static GetAttrStr(attr_list: Array<any>, color: number | string): string {
        let str = "";
        if (!attr_list)
            return str;
        for (let i = 0; i < attr_list.length; i++) {
            let attr = attr_list[i];
            let line = i + 1 != attr_list.length ? "<br/>" : "";
            let value = WordManager.ConvertToPercentValue(attr[0], attr[1]);
            str = str + `${WordManager.GetProperties(attr[0])}：${local_Util.HtmlColorTxt(value, color)}` + line;
        }
        return str;
    }
    //删除颜色标签
    public static DeleteColorTag(str: string) {
        str = str.replace(/<font.*?>/g, "").replace(/<\/font>/g, "");
        //str.replace(/0x[0-9a-fA-F]{6}/g, "4a3a32")
        return str;
    }
    /**
      * 振动对象
      */
    // public static Vibration(display: egret.DisplayObject): void {
    // display.removeEventListener(egret.Event.ENTER_FRAME, this.OnSceneEnterFrame, this);
    // display["i"] = 0;
    // display.addEventListener(egret.Event.ENTER_FRAME, this.OnSceneEnterFrame, this);
    // display.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.OnDisplayRemoved, this);
    // }
    private static vibrationArrayY: Array<number> = [-1, 1, 2, -2, -3, 3, 2, -2, 0];
    private static vibrationArrayX: Array<number> = [-1, 1, 2, -2, -3, 3, 2, -2, 0];
    // private static OnDisplayRemoved(event: egret.Event) {
    //     var display = event.currentTarget as egret.DisplayObject;
    //     display.removeEventListener(egret.Event.ENTER_FRAME, this.OnSceneEnterFrame, this);
    //     display.removeEventListener(egret.Event.REMOVED_FROM_STAGE, this.OnDisplayRemoved, this);
    // }
    // private static OnSceneEnterFrame(event: egret.Event) {
    //     var display = event.currentTarget as egret.DisplayObject;
    //     if (display["i"] < this.vibrationArrayY.length) {
    //         display.y += this.vibrationArrayY[display["i"]];
    //         display.x += this.vibrationArrayX[display["i"]];
    //     }
    //     else {
    //         display.removeEventListener(egret.Event.ENTER_FRAME, this.OnSceneEnterFrame, this);
    //         display.removeEventListener(egret.Event.REMOVED_FROM_STAGE, this.OnDisplayRemoved, this);
    //         display["i"] = 0;
    //     }
    //     display["i"]++;
    // }
    //钻石不足
    // public static NotEnougnDiamond(text?, call_fun?) {
    //     if (window["PlatformManager"].GetInstance().is_alpha) {
    //         let close_fun = () => { };
    //         let str = `您的绑玉或勾玉不足`;
    //         let Alert = window["Alert"]
    //         let Alert_Type = window["Alert_Type"]
    //         Alert.Show(str, Alert_Type.One, close_fun, undefined, "确定");
    //     }
    //     else {
    //         let ok_callback = () => {
    //             if (call_fun) {
    //                 call_fun();
    //             }
    //             else {
    //                 window["OpenFun"].OpenFunHandler(21);
    //             }
    //         };
    //         let str = "";
    //         if (text) {
    //             str = text;
    //         }
    //         else {
    //             str = `勾玉不足，是否前往充值`;
    //         }
    //         let Alert = window["Alert"]
    //         let Alert_Type = window["Alert_Type"]
    //         Alert.Show(str, Alert_Type.Two, ok_callback)
    //     }
    // }

    //需要先设置好宽高再设置遮罩
    public static SetCircleMask(com, off_x?, off_y?, radius?, source?) {
        // if (com["has_set_circle_mask"]) {
        //     return;
        // }
        // com.parent && com.parent["validateNow"] && com.parent["validateNow"]();
        // let img = new eui.Image();
        // img.source = source || "common_json.uiwg_005a_png";
        // if (radius) {
        //     img.width = img.height = radius * 2;
        // }
        // else {
        //     img.width = com.width;
        //     img.height = com.height;
        // }
        // img.x = com.x + (off_x || 0);
        // img.y = com.y + (off_y || 0);
        // img.scaleX = com.scaleX;
        // img.scaleY = com.scaleY;
        // com.parent.addChild(img);
        // com.mask = img;
        // com["has_set_circle_mask"] = img;
    }

    public static PrefixInteger(num, length) {
        return (Array(length).join('0') + num).slice(-length);
    }

    //屏幕横屏遮罩
    public static OrientationChange() {

    }

    //微信分享提示
    public static WXShareHint() {
        GlobalEventSystem.Fire(EventName.OPEN_VIEW, "FriendInviteShareView");
    }

    //美团当前版本是否支持充值
    public static MTSupportRecharge() {
        if (local_Util.IsMTGame() && window["mt_sys_info"] && window["mt_sys_info"].version && Laya.Browser.onAndroid
            && local_Util.meituan_is_support_recharge == null) {
            let version = window["mt_sys_info"].version;
            let arr = version.split(".");
            console.warn("美团当前版本-----------:", arr);
            local_Util.meituan_is_support_recharge = false;
            if (arr && arr[0] && arr[1] && arr[2]) {
                let version_no = Number(arr[2]) * 1 + Number(arr[1]) * 1000 + Number(arr[0]) * 1000000;
                let min_version = 200 * 1 + 6 * 1000 + 11 * 1000000; //最低版本号 "11.6.200"
                if (version_no >= min_version) {
                    console.warn("美团当前版本-----支持充值----");
                    local_Util.meituan_is_support_recharge = true;
                }
            }
        }
        if (local_Util.meituan_is_support_recharge) {
            console.warn("美团当前版本-----支持充值----");
        }
        else {
            console.warn("美团当前版本-----不支持充值----");
        }
        return local_Util.meituan_is_support_recharge;
    }

    //判断游戏对象是否已经被销毁为 null
    public static IsNull(obj: Laya.Sprite | Laya.Sprite3D | Laya.Component) {
        if (!obj) { return true }
        return obj.destroyed
    }

    public static FindBone(sprite: Laya.Sprite3D, bone_name) {
        let find_sprite
        if (!local_Util.IsNull(sprite)) {

            let num = sprite.numChildren
            let child: Laya.Sprite3D
            for (let i = 0; i < num; i++) {
                child = sprite.getChildAt(i) as Laya.Sprite3D
                if (child) {
                    if (child.name == bone_name) {
                        find_sprite = child
                    }
                    else {
                        find_sprite = local_Util.FindBone(child, bone_name)
                    }
                }
                if (find_sprite) {
                    break
                }
            }
        }
        return find_sprite
    }

    public static GetComponentsInChildren(sprite: Laya.Sprite3D, type) {
        let list = []

        let loop_func = (sprite) => {
            let num = sprite.numChildren
            let child
            for (let i = 0; i < num; i++) {
                child = sprite.getChildAt(i)
                if (child instanceof type) {
                    list.push(child)
                }
                else {
                    loop_func(child)
                }
            }
        }
        loop_func(sprite)
        return list
    }

    //只在第一层子节点内搜索组件
    public static GetComponent(sprite: Laya.Sprite3D, type) {
        let num = sprite.numChildren
        let child
        for (let i = 0; i < num; i++) {
            child = sprite.getChildAt(i)
            if (child instanceof type) {
                return child
            }
        }
    }

    //只在第一层子节点内搜索组件
    public static GetComponents(sprite: Laya.Sprite3D, type) {
        let list = []
        let num = sprite.numChildren
        let child
        for (let i = 0; i < num; i++) {
            child = sprite.getChildAt(i)
            if (child instanceof type) {
                list.push(child)
            }
        }
        return list
    }
    public static TableContains(list, item) {
        if (list && item != null) {
            return list.indexOf(item) != -1
        }
    }

    //通过figure_type来获取对应的值
    public static GetFigureId(figure_list, figure_type) {
        if (figure_list)
            for (let v of figure_list)
                if (v.figure_type == figure_type)
                    return v.figure_id;
        return 0
    }

    /**
     * 获取人物的衣服id和贴图id
     * @param vo 人物vo
     * @param revelation_equip_figuire_cfg 天启配置
     * @param suit_clt_cfg 史诗套装配置
     * @param temple_awaken_suit_cfg 神殿觉醒配置
     * @param not_check_god 不检查降神状态
     * @returns 
     */
    public static GetRoleClotheId = (vo, revelation_equip_figuire_cfg?, suit_clt_cfg?, temple_awaken_suit_cfg?, not_check_god = true) => {
        if (!vo) return [0, 0]

        //当前是降神状态
        if (vo.vo_type && vo.CheckIsGod() && !not_check_god)
            return [0, 0]

        //天启
        let config_revelation_equip_figuire = revelation_equip_figuire_cfg || Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_figuire
        if (vo.revelation_suit != 0 && config_revelation_equip_figuire) {
            return local_Util.GetRevelationClothesRes(vo.revelation_suit, vo.sex, config_revelation_equip_figuire)
        }

        //史诗套装
        let config_suit_clt = suit_clt_cfg || Config.PRELOAD_SERVER_CONFIG.config_suit_clt
        if (vo.suit_fashion_id != 0 && config_suit_clt) {
            return local_Util.GetSuitActivityClothesRes(vo.suit_fashion_id, vo.career, config_suit_clt)
        }

        //神殿觉醒
        let config_temple_awaken_suit = temple_awaken_suit_cfg || Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_suit
        if (vo.figure_list && local_Util.GetFigureId(vo.figure_list, 11) > 0 && config_temple_awaken_suit) {
            return [Number(config_temple_awaken_suit["1001@" + vo.career].figure_id), 0]
        }

        let ModelPartPos = window["ModelPartPos"]

        //时装
        let model_res_list = vo.fashion_model_list;
        if (model_res_list) {
            for (let v of model_res_list) {
                if (v.part_pos == ModelPartPos.Clothe && v.fashion_model_id > 0)
                    return [v.fashion_model_id, v.fashion_chartlet_id]
            }
        }

        //等级模型
        model_res_list = vo.level_model_list;
        if (model_res_list) {
            for (let v of model_res_list) {
                if (v.part_pos == ModelPartPos.Clothe && v.level_model_id > 0)
                    return [v.level_model_id, 0]
            }
        }

        return [0, 0]
    };

    /**
     * 获取人物的头发id和贴图id
     * @param vo 人物vo
     * @param revelation_equip_figuire_cfg 天启配置
     * @param suit_clt_cfg 史诗套装配置
     * @param temple_awaken_kv_cfg 史诗套装配置
     * @returns 
     */
    public static GetRoleHeadId = (vo, revelation_equip_figuire_cfg?, suit_clt_cfg?, temple_awaken_kv_cfg?) => {
        if (!vo) return [0, 0]

        //天启
        let config_revelation_equip_figuire = revelation_equip_figuire_cfg || Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_figuire
        if (vo.revelation_suit != 0 && config_revelation_equip_figuire) {
            return local_Util.GetRevelationHairRes(vo.revelation_suit, vo.sex, config_revelation_equip_figuire)
        }

        //史诗套装
        let config_suit_clt = suit_clt_cfg || Config.PRELOAD_SERVER_CONFIG.config_suit_clt
        if (vo.suit_fashion_id != 0 && config_suit_clt)
            return local_Util.GetSuitActivityHairRes(vo.suit_fashion_id, vo.career, config_suit_clt)

        //神殿觉醒
        let config_temple_awaken_kv = temple_awaken_kv_cfg || Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv
        if (vo.figure_list && local_Util.GetFigureId(vo.figure_list, 11) > 0 && config_temple_awaken_kv) {
            let head_model_id = Number(ErlangParser.GetInstance().Parse(config_temple_awaken_kv[7].value)[vo.sex - 1][1])
            return [head_model_id, 0]
        }

        let FashionPartPos = window["FashionPartPos"]
        let model_res_list = vo.fashion_model_list
        if (model_res_list) {
            let v
            for (let k in model_res_list) {
                v = model_res_list[k]
                if (v.part_pos == FashionPartPos.Head && v.fashion_model_id > 0) {
                    return [v.fashion_model_id, v.fashion_chartlet_id]
                }
            }
        }

        model_res_list = vo.level_model_list
        if (model_res_list) {
            let v
            for (let k in model_res_list) {
                v = model_res_list[k]
                if (v.part_pos == FashionPartPos.Head && v.level_model_id)
                    return [v.level_model_id, 0]

            }
        }

        return [0, 0]
    }

    public static GetRevelationClothesRes(id, sex, cfgs?) {
        let cfg = cfgs || Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_figuire
        if (cfg && cfg[id]) {
            let resList = JSON.parse(cfg[id].figure_id)
            for (let _ in resList) {
                var vo = resList[_]
                if (Number(vo[0]) == sex) {
                    return [Number(vo[1]), Number(vo[2])]
                }
            }
        }
        return [0, 0]
    }

    public static GetRevelationHairRes(id, sex, cfgs?) {
        let cfg = cfgs || Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_figuire
        if (cfg && cfg[id]) {
            let resList = JSON.parse(cfg[id].figure_id)
            for (let _ in resList) {
                var vo = resList[_]
                if (Number(vo[0]) == sex) {
                    return [Number(vo[3]), Number(vo[4])]
                }
            }
        }
        return [0, 0]
    }

    public static GetSuitActivityClothesRes(id, career, cfgs?) {
        let cfg_suit = cfgs || Config.PRELOAD_SERVER_CONFIG.config_suit_clt
        let cfg = cfg_suit[id + "@" + career]
        if (cfg) {
            return [cfg.fashion_id, cfg.fashion_color]
        }
        return [0, 0]
    }

    public static GetSuitActivityHairRes(id, career, cfgs?) {
        let cfg_suit = cfgs || Config.PRELOAD_SERVER_CONFIG.config_suit_clt
        let cfg = cfg_suit[id + "@" + career]
        if (cfg) {
            return [cfg.hair_id, cfg.hair_color]
        }
        return [0, 0]
    }

    public static GetSuitActivityWeaponId(id, career, cfgs?) {
        let cfg_suit = cfgs || Config.PRELOAD_SERVER_CONFIG.config_suit_clt
        let cfg = cfg_suit[id + "@" + career]
        if (cfg) {
            return [cfg.equip_id, cfg.equip_color]
        }
        return [0, 0]
    }

    //先去时装模型列表的 再取等级模型id列表的武器
    public static GetWeaponClotheId = (obj) => {
        let model_res_list = obj.fashion_model_list;
        let ModelPartPos = window["ModelPartPos"]
        if (model_res_list)
            for (let v of model_res_list)
                if (v.part_pos == ModelPartPos.Weapon)
                    return v.fashion_model_id;
        let figure_list = obj.figure_list;
        if (figure_list)
            for (let v of figure_list)
                if (v.figure_type == FigureProtoVo.FigureType.Weapon)
                    return v.figure_id;
        model_res_list = obj.level_model_list;
        if (model_res_list)
            for (let v of model_res_list)
                if (v.part_pos == ModelPartPos.Weapon)
                    return v.level_model_id;
    };

    //先去时装模型列表的 再取等级模型id列表
    public static GetWingClotheId = (obj) => {
        if (obj.figure_list)
            for (let v of obj.figure_list)
                if (v.figure_type == FigureProtoVo.FigureType.Wing)
                    return v.figure_id;
    };

    //先去背饰模型列表的 再取等级模型id列表
    public static GetBackOrnamentId = (obj) => {
        if (obj.figure_list)
            for (let v of obj.figure_list)
                if (v.figure_type == FigureProtoVo.FigureType.NewBackOrnament)
                    return v.figure_id;
    };

    //先去时装模型列表的 再取等级模型id列表
    public static GetHorseClotheId = (obj) => {
        if (obj.figure_list)
            for (let v of obj.figure_list)
                if (v.figure_type == FigureProtoVo.FigureType.Horse)
                    return v.figure_id;
    };

    //
    public static GetLivenessId = (obj) => {
        if (obj.liveness_id) {
            return obj.liveness_id
        }
    };

    private static IsLag(time) {
        let frame_start_time = Laya.stage.getTimeFromFrameStart()
        return frame_start_time > time
    }

    public static RandomDeviceId = () => {
        var deviceId = (local_Util._S4() + local_Util._S4() + "-" + local_Util._S4() + "-" + local_Util._S4() + "-" + local_Util._S4() + "-" + local_Util._S4() + local_Util._S4() + local_Util._S4());
        deviceId = "WX" + deviceId.toUpperCase();
        // console.log("_deviceId:"+deviceId);
        return deviceId;
    }

    static _S4 = () => {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }

    static IsIOS16 = () => {
        if (!Laya.Browser.onIOS) return false
        var str = window.navigator.userAgent.toLowerCase();
        var ver = str.match(/cpu iphone os (.*?) like mac os/);
        if (!ver) {
            return false
        }

        let num = ver[1].replace(/_/g, ".").split('.')[0]
        return num == "16"
    }
}

export function Set3DLocalPosition(transform: Laya.Transform3D, x = 0, y = 0, z = 0) {
    let _localPosition = transform["_localPosition"]
    _localPosition.x = -x
    _localPosition.y = -y
    _localPosition.z = z
    transform.localPosition = _localPosition
}
window["Set3DLocalPosition"] = Set3DLocalPosition

export function Set3DLocalRotationEuler(transform: Laya.Transform3D, x = 0, y = 0, z = 0) {
    let _localRotationEuler = transform["_localRotationEuler"]
    _localRotationEuler.x = x
    _localRotationEuler.y = y
    _localRotationEuler.z = z
    transform.localRotationEuler = _localRotationEuler
}
window["Set3DLocalRotationEuler"] = Set3DLocalRotationEuler

export function Set3DLocalRotation(transform: Laya.Transform3D, x = 0, y = 0, z = 0, w = 1) {
    let _localRotation = transform["_localRotation"]
    _localRotation.x = x
    _localRotation.y = y
    _localRotation.z = z
    _localRotation.w = w
    transform.localRotation = _localRotation
}
window["Set3DLocalRotation"] = Set3DLocalRotation

export function Set3DLocalScale(transform: Laya.Transform3D, x = 1, y = 1, z = 1) {
    let _localScale = transform["_localScale"]
    _localScale.x = x
    _localScale.y = y
    _localScale.z = z
    transform.localScale = _localScale
}
window["Set3DLocalScale"] = Set3DLocalScale

export function Set3DPosition(transform, x, y, z) {
    let _position = transform["_position"]
    _position.x = -x
    _position.y = -y
    _position.z = z
    transform.position = _position
    // transform.localPosition = new Laya.Vector3(-x, -y, 100)
}
window["Set3DPosition"] = Set3DPosition
export function SetAnchoredPosition(gameObject, x, y) {
    if (gameObject) {
        gameObject.x = x
        gameObject.y = y
    }
}
window["SetAnchoredPosition"] = SetAnchoredPosition
export function Color(r, g, b, a) {
    if (r != undefined && g != undefined && b != undefined) {
        let R = Number((r * 255).toString(16)) < 10 ? "0" + (r * 255).toString(16) : (r * 255).toString(16)
        let G = Number((g * 255).toString(16)) < 10 ? "0" + (g * 255).toString(16) : (g * 255).toString(16)
        let B = Number((b * 255).toString(16)) < 10 ? "0" + (b * 255).toString(16) : (b * 255).toString(16)
        return String("#" + R + G + B)
    }

}
window["Color"] = Color
export function SetAnchoredPositionX(gameObject, x) {
    if (gameObject) {
        gameObject.x = x
    }
}
window["SetAnchoredPositionX"] = SetAnchoredPositionX
export function SetAnchoredPositionY(gameObject, y) {
    if (gameObject) {
        gameObject.y = y
    }
}
window["SetAnchoredPositionY"] = SetAnchoredPositionY
export function SetLocalScale(gameObject, x, y?, z?) {
    if (gameObject) {
        gameObject.scaleX = x
        gameObject.scaleY = y || x
    }
}
window["SetLocalScale"] = SetLocalScale
export function SetLocalScaleX(gameObject, v) {
    if (gameObject) {
        gameObject.scaleX = v
    }
}
window["SetLocalScaleX"] = SetLocalScaleX
export function SetLocalScaleY(gameObject, v) {
    if (gameObject) {
        gameObject.scaleY = v
    }
}
window["SetLocalScaleY"] = SetLocalScaleY
export function SetLocalPosition(gameObject, x, y, z?) {
    if (gameObject) {
        gameObject.x = x
        gameObject.y = y
    }
}
window["SetLocalPosition"] = SetLocalPosition
export function SetLocalPositionX(gameObject, x) {
    if (gameObject) {
        gameObject.x = x
    }
}
window["SetLocalPositionX"] = SetLocalPositionX
export function SetLocalPositionY(gameObject, y) {
    if (gameObject) {
        gameObject.y = y
    }
}
window["SetLocalPositionY"] = SetLocalPositionY
export function GetLocalPositionX(gameObject) {
    if (gameObject) {
        return gameObject.x
    }
    return 0
}
window["GetLocalPositionX"] = GetLocalPositionX
export function GetLocalPositionY(gameObject) {
    if (gameObject) {
        return gameObject.y
    }
    return 0
}
window["GetLocalPositionY"] = GetLocalPositionY
export function SetSizeDelta(gameObject, w, h) {
    if (gameObject) {
        gameObject.width = w
        gameObject.height = h
    }
}
window["SetSizeDelta"] = SetSizeDelta
export function GetSizeDeltaX(gameObject) {
    if (gameObject) {
        return gameObject.width
    }
    return 0
}
window["GetSizeDeltaX"] = GetSizeDeltaX
export function GetSizeDeltaY(gameObject) {
    if (gameObject) {
        return gameObject.height
    }
    return 0
}
window["GetSizeDeltaY"] = GetSizeDeltaY
export function SetSizeDeltaX(gameObject, w) {
    if (gameObject) {
        gameObject.width = w
    }
}
window["SetSizeDeltaX"] = SetSizeDeltaX
export function SetSizeDeltaY(gameObject, h) {
    if (gameObject) {
        gameObject.height = h
    }
}
window["SetSizeDeltaY"] = SetSizeDeltaY
export function GetAlpha(gameObject) {
    if (gameObject) {
        return gameObject.alpha
    }
}
window["GetAlpha"] = GetAlpha
export function SetAlpha(gameObject, alpha) {
    if (gameObject) {
        gameObject.alpha = alpha
    }
}
window["SetAlpha"] = SetAlpha
export class GlobalTimerQuest {
    public static timeIdToFunc = {}
    /**
     * 延迟调用
     * @param func 回调函数 必须是箭头函数  注意！！！！！！
     * @param time 延迟时间 秒
     * @returns 
     */
    public static AddDelayQuest(func, time) {
        Laya.timer.once(time * 1000, null, func)
        return func
    }

    public static CancelQuest(id) {
        if (id)
            Laya.timer.clear(null, id)
    }

    /**
     * 定时调用
     * @param func 回调函数 必须是箭头函数  注意！！！！！！
     * @param time 周期时间  秒
     * @param loop 
     * @returns 
     */
    public static AddPeriodQuest(func, time, loop = 0) {
        if (loop && loop > 0) {
            GameError.GetInstance().SendErrorToPHP("AddPeriodQuest 是无限循环函数，不能设置循环测试，请注意修改", true)
            // console.trace()
        }
        Laya.timer.loop(time * 1000, null, func)
        return func
    }
}
window["GlobalTimerQuest"] = GlobalTimerQuest
//获取图集中图片路径
export function AtlasUrl(module, resName) {
    return `resource/game/${module}/texture/${resName}.png`
}
window["AtlasUrl"] = AtlasUrl
export function Trim(str) {
    return str
}
window["Trim"] = Trim
export function HtmlColorTxt(str, color) {
    return "<font color=" + color + ">" + str + "</font>"
}
window["HtmlColorTxt"] = HtmlColorTxt
export function LoadLuaConfigAB(cfg_name, func) {
    func()
}
window["LoadLuaConfigAB"] = LoadLuaConfigAB
export function NotEnougnDiamond(str?, callback?) {
    if (window["PlatformManager"].GetInstance().is_alpha) {
        let close_fun = () => { };
        let str = `您的绑玉或勾玉不足`;
        // let Alert = window["Alert"]
        // let Alert_Type = window["Alert_Type"]
        //Alert.Show(str, Alert_Type.One, close_fun, undefined, "确定");
        let Alert = window["Alert"], Alert_Type = window["Alert_Type"]
        Alert.Show(str, Alert_Type.One, undefined)
    }
    else {
        let ok_callback = () => {
            if (callback) {
                callback()
            }
            else {
                //custom_act_model.state 为true，表示今天有领取过120活动的礼包，那就要跳转到充值界面，否则跳转到超值礼包
                let state = window["CustomActivityModel"].GetInstance().GetSuperGiftBuyState()
                if (state) {
                    window["OpenFun"].OpenFunHandler(21);
                } else {
                    window["OpenFun"].OpenFunHandler(249);
                }

                // OpenFun.OpenFunHandler(21)
            }
        };


        let msg = str ? str : "勾玉不足，是否前往充值"
        let Alert = window["Alert"], Alert_Type = window["Alert_Type"]
        Alert.Show(msg, Alert_Type.Two, ok_callback)
    }
}
window["NotEnougnDiamond"] = NotEnougnDiamond
export function LoadLuaClassAB(cfg_name, func) {
    func()
}
window["LoadLuaClassAB"] = LoadLuaClassAB
export function AddUnderLineAndClick(ref_target, text, func) {
    // text.addEventListener(egret.TextEvent.LINK, (e) => {
    //     func(e.text)
    // }, ref_target)
}
window["AddUnderLineAndClick"] = AddUnderLineAndClick
export function Split(str, sep) {
    if (str) {
        return str.split(sep)
    }
    return ""
}
window["Split"] = Split
export function CommonCrossFadeAnim(animator: Laya.Animator, action_name, cross_time, not_change_same_action = false) {
    if (!local_Util.IsNull(animator)) {
        let layer = animator.getControllerLayer()
        if (layer) {
            var playStateInfo = layer.getCurrentPlayState();
            var same_action_start_time = Number.NEGATIVE_INFINITY
            var curPlayState = playStateInfo.animatorState;
            if (curPlayState && curPlayState.name == action_name) {
                if (not_change_same_action) {
                    return
                } else {
                    same_action_start_time = 0
                }
            }
            if (layer.getAnimatorState(action_name)) {
                if (cross_time && cross_time > 0) {
                    return animator.crossFade(action_name, cross_time, 0, same_action_start_time)
                } else {
                    return animator.play(action_name, 0, same_action_start_time)
                }
            } else {
                if (action_name != "idle" && layer.getAnimatorState("idle")) {
                    if (cross_time && cross_time > 0) {
                        return animator.crossFade("idle", cross_time, 0, same_action_start_time)
                    } else {
                        return animator.play("idle", 0, same_action_start_time)
                    }
                }
            }
        }
    }
}
window["CommonCrossFadeAnim"] = CommonCrossFadeAnim
export function CommonPlayAnim(animator: Laya.Animator, action_name, not_change_same_action = false) {
    if (!local_Util.IsNull(animator)) {
        let layer = animator.getControllerLayer()
        if (layer) {
            var playStateInfo = layer.getCurrentPlayState();
            var same_action_start_time = Number.NEGATIVE_INFINITY
            var curPlayState = playStateInfo.animatorState;
            if (curPlayState && curPlayState.name == action_name) {
                if (not_change_same_action) {
                    return
                } else {
                    same_action_start_time = 0
                }
            }
            if (layer.getAnimatorState(action_name)) {
                return animator.play(action_name, 0, same_action_start_time)
            } else {
                if (action_name != "idle" && layer.getAnimatorState("idle")) {
                    return animator.play("idle", 0, same_action_start_time)
                }
            }
        }
    }
}
window["CommonPlayAnim"] = CommonPlayAnim
export function GetAnimatorState(animator: Laya.Animator, action_name, layer_index = 0) {
    if (!local_Util.IsNull(animator) && animator.getControllerLayer(layer_index)) {
        return animator.getControllerLayer(layer_index).getAnimatorState(action_name)
    }
}
window["GetAnimatorState"] = GetAnimatorState
export function SetMaterialTexture(material, texture) {
    if (material) {
        if (material as Laya.UnlitMaterial) {
            material.albedoTexture = texture
        }
    }
    // if(material.HasProperty("_MainTex")){
    // 	material.SetTexture("_MainTex", texture)
    // }
    // else if(material.HasProperty("_AmitTex")){
    // 	material.SetTexture("_AmitTex", texture)
    // }
}
window["SetMaterialTexture"] = SetMaterialTexture
export function GetMaterial(render_sprite3d) {
    if (local_Util.IsNull(render_sprite3d)) return
    let material
    if (render_sprite3d.skinnedMeshRenderer) {
        material = render_sprite3d.skinnedMeshRenderer.material
    }
    else if (render_sprite3d.meshRenderer) {
        material = render_sprite3d.meshRenderer.material
    }
    return material
}
window["SetMaterialTexture"] = SetMaterialTexture
export function GetMaterialTexture(material) {
    if (material) {
        if (material as Laya.UnlitMaterial) {
            return material.albedoTexture
        }
    }
}
window["GetMaterialTexture"] = GetMaterialTexture
export function IsInTable(value, list) {
    let revtab = {}
    for (let key in list) {
        let vo = list[key]
        revtab[vo] = true
    }

    return revtab[value]
}
window["IsInTable"] = IsInTable
export function GetTargetHashcode(target): number {
    if (target) {
        return target["$_GID"] || target.hashCode || (target.hashCode = HashObject.CreateHashcode())
    }
}
window["GetTargetHashcode"] = GetTargetHashcode
export function GetOption(key: string): string {
    return Laya.Utils.getQueryString(key)
    // if (window.location) {
    //     let search = location.search;
    //     if (search == "") {
    //         return "";
    //     }
    //     search = search.slice(1);
    //     let searchArr = search.split("&");
    //     let length = searchArr.length;
    //     for (let i:number = 0; i < length; i++) {
    //         let str = searchArr[i];
    //         let arr = str.split("=");
    //         if (arr[0] == key) {
    //             return arr[1];
    //         }
    //     }
    // }
    // return "";
}
window["GetOption"] = GetOption
/**
 * 将html文本居中
 * @param html_obj  html文本引用
 * @param x_w 注：{x:0, w:10} 外层范围的x 外层范围的宽w
 * @param y_h 注：{y:0, h:10} 外层范围的y 外层范围的高h
 */
export function SetHtmlCenter(html_obj, x_w?, y_h?) {
    if (x_w && x_w.w) {
        let x = x_w.x || 0
        let w = x_w.w

        html_obj.width = w
        html_obj.x = x + (w / 2 - html_obj.contextWidth / 2)
    }
    if (y_h && y_h.h) {
        let y = y_h.y || 0
        let h = y_h.h

        html_obj.height = h
        html_obj.y = y + (h / 2 - html_obj.contextHeight / 2)
    }
}
window["SetHtmlCenter"] = SetHtmlCenter
/**
 * 手动刷新 设置网格布局(目前只能从左到右且从上到下)
 * @param partner 父对象
 * @param layout_data 计算布局所需的数据集合{column,h_gap,v_gap,item_w,item_h}
 * @param single_center 只有一个的时候是否需要居中显示处理
 */
export function RefGridLayout(partner: Laya.Sprite, layout_data, single_center = true) {
    let frist_item_space = layout_data.frist_item_space || 0  //每排第一个前面空的位置
    let h_gap = layout_data.h_gap || 0				//横向单元格的间隙
    let v_gap = layout_data.v_gap || 0				//横向单元格的间隙
    let column = layout_data.column					//固定列数
    let row = 0										//当前行数（根据计算的单元格进行递增）
    let item_w = layout_data.item_w			        //每个子对象的宽
    let item_h = layout_data.item_h			        //每个子对象的高
    let partner_w = partner.width					//父对象总宽

    let cell_w = (partner_w / column) - (h_gap / 2)	//单元格宽
    let cell_h = item_h								//单元格高
    let space = (cell_w - item_w) / 2				//单元格内除子对象外的单边横向间隙

    let count = 0									//记录当前已计算的单元格

    let first_item: Laya.UIComponent
    for (let i = 0; i < partner.numChildren; i++) {
        let item = (<Laya.UIComponent>partner.getChildAt(i))
        if (item && item.visible) {
            let index = count % column				//横向，前面有几个单元格
            let first = index == 0 ? 0 : 1			//横向第一个不需要额外加一个space
            let frist_place = index == 0 ? frist_item_space : 0 //横向第一个加点空间
            if (index == 0 && count != 0) {			//是否需要换行
                row++
            }
            let x = (cell_w + h_gap) * index + space * first + frist_place
            let y = (cell_h + v_gap) * row
            item.pos(x, y)


            count++									//增加已计算单元格数量

            first_item = item
        }
    }

    //只有一个的时候是否需要居中处理
    if (single_center && count == 1 && first_item) {
        let x = (partner_w - item_w) / 2
        let y = 0
        first_item.pos(x, y)
    }

}
window["RefGridLayout"] = RefGridLayout

/**
 * 水平排布box中所有的子元素
 * @param box         box组件
 * @param space_x     水平的间距
 * @param cell_w      cell指定宽度(跳过异步加载的限制，适用组件大小一致)
 * @param is_hide  是否排除不可见的元素  true排除  false不排除  (默认排除)
 * @param align       水平布局方向 "center"/"left"/"right"
 */
export function RefBoxChildsLayout(box: Laya.Box, space_x = 0, cell_w = null, is_hide = true, align = "center") {

    //***目前还没支持子元素缩放后的宽度


    let i = 0
    let box_childs_len = box.numChildren
    let cont_w = 0
    switch (align) {
        case "center":
            let num = 0
            i = 0
            let all_w = 0
            let cell: any
            for (i = 0; i < box_childs_len; i++) {
                cell = box.getChildAt(i)
                if (cell) {
                    if (is_hide && !cell.visible) continue
                    num++
                    all_w += cell_w ? cell_w : (cell.contextWidth ? cell.contextWidth : cell.width)
                }
            }

            all_w += space_x * (num - 1)
            let centerX = (box.width - all_w) / 2
            let cur_x = centerX
            for (i = 0; i < box_childs_len; i++) {
                cell = box.getChildAt(i)
                if (cell) {
                    if (is_hide && !cell.visible) continue
                    let w = cell_w ? cell_w : (cell.contextWidth ? cell.contextWidth : cell.width)
                    let acX = cell.anchorX ? cell.anchorX : 0
                    cell.x = cur_x + (w * acX)
                    cur_x += w + space_x
                }
            }
            break
        case "left":

            cont_w = 0
            for (i = 0; i < box_childs_len; i++) {
                let cell: any = box.getChildAt(i)
                if (cell) {
                    if (is_hide && !cell.visible) continue
                    let wid = 0
                    if (cell_w) {
                        wid = cell_w
                    } else {
                        wid = cell.contextWidth ? cell.contextWidth : cell.width
                    }
                    cell.x = cont_w
                    cont_w += (space_x + wid)
                }
            }
            break
        case "right":

            cont_w = 0
            i = 0
            cont_w = Math.ceil(box.width)
            for (i = box_childs_len - 1; i >= 0; i--) {
                let cell: any = box.getChildAt(i)
                if (cell) {
                    if (is_hide && !cell.visible) continue
                    let wid = 0
                    if (cell_w) {
                        wid = cell_w
                    } else {
                        wid = cell.contextWidth ? cell.contextWidth : cell.width
                    }
                    let cell_gap = i == (box_childs_len - 1) ? 0 : space_x
                    let rx = cont_w - (cell_gap + wid)
                    cell.x = rx
                    cont_w = rx
                }
            }
            break
    }

}

window["RefBoxChildsLayout"] = RefBoxChildsLayout

/**
 * 将box中所有子元素垂直自上而下排列  最后重新设置box的高度
 * @param box  box组件
 * @param space_y 垂直的间距
 * @param filter_hider 忽略隐藏的元素  true排除  false不排除
 * @param ignore_last_space 排除最后一个空间
 */
export function RefBoxVLayout(box: Laya.Box, space_y = 0, filter_hider = false, ignore_last_space?) {
    let cell: any
    let sx = 0
    for (let i = 0; i < box.numChildren; i++) {
        cell = box.getChildAt(i)
        if (filter_hider && !cell.visible) continue
        cell.y = sx
        let wh = cell.contextHeight ? (cell.contextHeight * cell.scaleY) : (cell.height * cell.scaleY)
        sx += wh + space_y
    }

    if (ignore_last_space) {
        sx -= space_y
    }
    box.height = sx
}
window["RefBoxVLayout"] = RefBoxVLayout




/**
 * 通用设置HTML
 * @param html  html组件
 * @param obj   f   =fontsize,
 *              c   =color,
 *              w   =width,
 *              ww  =wordWrap
 *              a   =align
 *              lh  =lineHeright
 *              st  =stroke
 *              stc =stroke color
 *              li  =leading
 *              b   =bold
 */
export function SetHtmlStyle(html: Laya.HTMLDivElement, obj) {
    let fontsize = obj.f ? obj.f : 20
    let color = obj.c ? obj.c : 20
    let width = obj.w ? obj.w : null
    let wordWrap = obj.ww != null ? obj.ww : true
    let align = obj.a ? obj.a : null
    let lineHeight = obj.lh ? obj.lh : null
    let leading = obj.li ? obj.li : 0.1
    let stroke = obj.st ? obj.st : null
    let strokeColor = obj.stc ? obj.stc : null
    let bold = obj.b ? obj.b : false
    if (html) {
        html.style.fontSize = fontsize
        html.style.color = color
        if (align) html.style.align = align
        if (width) html.width = width
        if (lineHeight) {
            html.style.lineHeight = lineHeight
        }
        if (leading) {
            html.style.leading = leading//如果设置了0的行距 则默认用10的行距 这里设置0.1，不使用默认行距
        }
        if (stroke) html.style.stroke = stroke
        if (strokeColor) html.style.strokeColor = strokeColor
        if (bold) html.style.bold = bold
        html.style.wordWrap = wordWrap
    }
}

window["SetHtmlStyle"] = SetHtmlStyle


/**
 * List居中
*@param list 
*@param max       小于等于该长度将禁用左右滑动
*@param base_x    List在UI界面的位置
*@param cell_w    cell的宽度
 */
export function MakeListCenter(list: Laya.List, max, base_x, cell_w) {
    if (!list) return
    let d_len = list.array.length
    list.x = base_x
    if (d_len > max) {
        list.scrollBar.touchScrollEnable = true
    } else {
        let allw = d_len * cell_w + (d_len - 1) * list.spaceX
        list.x = (list.width - allw) / 2 + base_x
        list.scrollBar.touchScrollEnable = false
    }
}

window["MakeListCenter"] = MakeListCenter


/**
 * 神创等级转换
*@param level     需要转换的等级
 */
export function TransformLevel(level?) {
    let lv = level > 370 && "神创" + ((level - 370)) || level + ""
    return lv
}

window["TransformLevel"] = TransformLevel
/**
 * 充值活动 货币转换
 */
export function TransformCurrency(num?) {
    if (window["PlatformManager"].IsEyouEnPlatform()) {
        return num
    }
    return num / 10
}
window["TransformCurrency"] = TransformCurrency


/**
 * 播放特效  类似升级、激活的提示特效
 * type  null用默认  1用MainUIEffectGodSkillView 2用MainUIEffectPartnerSkillView
 */
export function PlayBigEffect(effName?, pos?, scale?, type?) {
    let obj = {
        name: effName,
        pos: pos,
        scale: scale
    }
    GlobalEventSystem.Fire(EventName.PLAY_BIG_EFFECT, obj, type);
}

window["PlayBigEffect"] = PlayBigEffect






export function GetQualifiedClassName(value: any): string {
    let type = typeof value;
    if (!value || (type != "object" && !value.prototype)) {
        return type;
    }
    let className: string = local_Util.IsDebug() ? value["constructor"].name : value["constructor"].class_name
    if (className) {
        if (className.indexOf("_") == 0)
            className = className.substring(1)
        return className
    }
    // let prototype:any = value.prototype ? value.prototype : Object.getPrototypeOf(value);
    // if (prototype.hasOwnProperty("__class__")) {
    //     return prototype["__class__"];
    // }
    // let constructorString:string = prototype.constructor.toString().trim();
    // className = constructorString.match(/\s\w+\s/).toString().replace(" ", "").replace(" ", "")
    // Object.defineProperty(prototype, "__class__", {
    //     value: className,
    //     enumerable: false,
    //     writable: true
    // });
    // return className;
}
window["GetQualifiedClassName"] = GetQualifiedClassName
export function ResetTransform(transform: Laya.Transform3D) {
    // transform.localPosition = new Laya.Vector3(0, 0, 0);
    // transform.localRotation = new Laya.Quaternion(0, 0, 0, 1)
    // transform.localScale = new Laya.Vector3(1, 1, 1)
    Set3DLocalPosition(transform)
    Set3DLocalRotation(transform)
    Set3DLocalScale(transform)
    Set3DLocalRotationEuler(transform)
}
window["ResetTransform"] = ResetTransform
export function ResetSkinnedMeshSprite3D(sprite_3d: Laya.Sprite3D) {
    if (local_Util.IsNull(sprite_3d)) return
    let skin_mesh_renderers = local_Util.GetComponents(sprite_3d, Laya.SkinnedMeshSprite3D)
    let skin_mesh_renderer: Laya.SkinnedMeshSprite3D
    for (let i = 0; i < skin_mesh_renderers.length; i++) {
        skin_mesh_renderer = skin_mesh_renderers[i]
        if (skin_mesh_renderer) {
            let unlit_material: Laya.UnlitMaterial = skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
            if (unlit_material) {
                unlit_material.albedoColor = new Laya.Vector4(1, 1, 1, 1)
            }
        }
    }
}
window["ResetSkinnedMeshSprite3D"] = ResetSkinnedMeshSprite3D
export function GetSkinnedMeshSprite3D(sprite: Laya.Sprite3D) {
    if (local_Util.IsNull(sprite)) return
    let sp
    for (let i = 0; i < sprite.numChildren; i++) {
        sp = sprite.getChildAt(i)
        if (sp instanceof Laya.SkinnedMeshSprite3D) {
            return sp
        }
    }
}
window["GetSkinnedMeshSprite3D"] = GetSkinnedMeshSprite3D
export function GetMeshSprite3D(sprite: Laya.Sprite3D) {
    if (local_Util.IsNull(sprite)) return
    let sp
    for (let i = 0; i < sprite.numChildren; i++) {
        sp = sprite.getChildAt(i)
        if (sp instanceof Laya.MeshSprite3D) {
            return sp
        }
    }
}
window["GetMeshSprite3D"] = GetMeshSprite3D
export function OverrideScrollBarChange(list: Laya) {
    this.runCallLater(this.changeCells);
    var scrollValue = this._scrollBar.value;
    var lineX = (this._isVertical ? this.repeatX : this.repeatY);
    var lineY = (this._isVertical ? this.repeatY : this.repeatX);
    var scrollLine = Math.floor(scrollValue / this._cellSize);
    if (!this.cacheContent) {
        var index = scrollLine * lineX;
        var num = 0;
        let down = false;
        var toIndex = 0;
        if (index > this._startIndex) {
            num = index - this._startIndex;
            down = true;
            toIndex = this._startIndex + lineX * (lineY + 1);
            this._isMoved = true;
            if (num > 0) {
                num = num - 1;
                index = this._startIndex + num
            }
        } else {
            index = index - 1
            if (index < this._startIndex) {
                num = this._startIndex - index;
                down = false;
                toIndex = this._startIndex - 1;
                this._isMoved = true;
            }
        }

        for (var i = 0; i < num; i++) {
            if (down) {
                var cell
                cell = this._cells.shift();
                this._cells[this._cells.length] = cell;
                var cellIndex = toIndex + i;
            }
            else {
                cell = this._cells.pop();
                this._cells.unshift(cell);
                cellIndex = toIndex - i;
            }
            var pos = Math.floor(cellIndex / lineX) * this._cellSize;
            this._isVertical ? cell.y = pos : cell.x = pos;
            this.renderItem(cell, cellIndex);
        }

        this._startIndex = index;
        this.changeSelectStatus();
    }
    else {
        num = (lineY + 1);
        if (this._createdLine - scrollLine < num) {
            this._createItems(this._createdLine, lineX, this._createdLine + num);
            this.renderItems(this._createdLine * lineX, 0);
            this._createdLine += num;
        }
    }
    var r = this._content._style.scrollRect;
    if (this._isVertical) {
        r.y = scrollValue - this._offset.y;
        r.x = -this._offset.x;
    }
    else {
        r.y = -this._offset.y;
        r.x = scrollValue - this._offset.x;
    }
    this._content.scrollRect = r;
}
window["OverrideScrollBarChange"] = OverrideScrollBarChange
export function GetSexByCareer(career, config_career) {
    let data
    for (let i in config_career) {
        data = config_career[i]
        if (data.career_id == career) {
            return data.sex
        }
    }
    return 1
}
window["GetSexByCareer"] = GetSexByCareer
export function GetParams(parms) {
    if (!parms) return ""
    let get_params = "?";
    for (let key in parms) {
        let value = parms[key];
        get_params = get_params + String(key) + "=" + String(value) + "&";
    }
    return get_params
}
var local_Util = Util
window["Util"] = Util
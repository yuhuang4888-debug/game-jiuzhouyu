
import { Config } from "./Config";
export class WordManager {
    public constructor() {
    }
    //属性
    public static GetProperties(id: number): string {
        let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr[id];
        if (cfg == null) {
            return "";
        }
        return cfg.name;
    }
    private static Equip_Pos_arr = ["武器", "头冠", "项链", "衣服", "护符", "裤子", "手镯", "护腕", "戒指", "鞋子"];
    //通过装备格子位置获取装备部位描述
    public static GetEquipPos(cell: number): string {
        // let pos_arr = ["武器", "头冠", "项链", "衣服", "护符", "裤子", "手镯", "护腕", "戒指", "鞋子"]
        let equip_pos = WordManager.Equip_Pos_arr[cell - 1] ? WordManager.Equip_Pos_arr[cell - 1] : "无类型";
        return equip_pos;
    }
    //职业名
    public static GetCareerLimit(career: number): string {
        let career_list = ["通用", "剑士", "武姬", "枪使", "弓手"];
        return career_list[career] ? career_list[career] : "通用";
    }
    //结社职位名
    public static GetGuildPosName(pos: number): string {
        if (pos == 1)
            return "会长";
        else if (pos == 2)
            return "副会长";
        else if (pos == 3)
            return "成员";
        else if (pos == 4)
            return "宝贝";
        else if (pos == 5)
            return "精英";
    }
    //特权卡名
    public static GetNobleCardsName(card: number): string {
        if (card == 1)
            return "黄金";
        else if (card == 2)
            return "铂金";
        else if (card == 3)
            return "至尊";
        else
            return "";
    }
    public static GetGoodsStyle(style: number): string {
        let cfg = Config.PRELOAD_SERVER_CONFIG.GoodsType[style];
        if (cfg == null) {
            return "";
        }
        return cfg.type_name;
    }
    public static GetAttrShowTxt(attr_cfg: string) {
        let name = WordManager.GetProperties(Number(attr_cfg[0]));
        return `${name}+${attr_cfg[1]}`;
    }
    public static ConvertNum(num, show_decimal?) {
        num = Number(num);
        if (num <= 9999)
            return num;
        else if (num >= 10000 && num < 100000000)
            return show_decimal ? `${(num / 10000).toFixed(2)}万` : `${Math.floor(num / 10000)}万`;
        else if (num >= 100000000 && num < 1000000000000)
            return show_decimal ? `${(num / 100000000).toFixed(2)}亿` : `${Math.floor(num / 100000000)}亿`;
        else
            return show_decimal ? `${(num / 1000000000000).toFixed(2)}万亿` : `${Math.floor(num / 1000000000000)}万亿`;
    }
    public static ConvertNumWithWan(num) {
        num = Number(num);
        if (num <= 9999)
            return num;
        else if (num >= 10000 && num < 100000000)
            return `${Math.floor(num / 10000)}万`;
        else if (num >= 100000000 && num < 1000000000000)
            return `${Math.floor(num / 100000000)}亿${Math.floor((num % 100000000) / 10000)}万`;
        else
            return `${Math.floor(num / 1000000000000)}万亿${Math.floor((num % 1000000000000) / 100000000)}亿${Math.floor((num % 100000000) / 10000)}万`;
    }
    public static FormatNumber(number) {
        number = Number(number);
        return number;
    }
    /**
     * @param isCN 中文显示 "万"
     * @param isCarry 是否需要进位
     */
    public static FormatNumber2(number, isCN: boolean = false, isCarry: boolean = true) {
        number = Number(number);
        if (number && number > 10000 && number < 100000000) {
            if (isCarry) {
                number = (number / 10000).toFixed(1)
            } else {
                number = (number / 10000).toFixed(2).slice(0, -1)
            }
            number = String(number).replace(".0", "")
            let str = isCN ? `万` : `W`
            number = `${number}${str}`
            return number
        } else if (number && number >= 100000000) {
            number = (number / 100000000).toFixed(2).slice(0, -1)
            number = String(number).replace(".0", "")
            let str = `亿`
            number = `${number}${str}`
            return number
        }
        return number;
    }
    static str1 = ["百", "十"];
    static str2 = ["一", "二", "三", "四", "五", "六", "七", "八", "九"];
    public static NumConvertStage(num) {
        let result = "";
        let bai = Math.floor(num / 100) % 10;
        if (bai > 0)
            result = result + WordManager.str2[bai - 1] + WordManager.str1[0];
        let shi = Math.floor(num / 10) % 10;
        if (shi > 0) {
            if (shi == 1)
                result = result + WordManager.str1[1];
            else
                result = result + WordManager.str2[shi - 1] + WordManager.str1[1];
        }
        let ge = num % 10;
        if (ge > 0)
            result = result + WordManager.str2[ge - 1];
        return result;
    }
    public static ConvertToPercentValue(id, value) {
        value = value || 0;

        let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr && Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr[id];
        if (cfg == null) {
            return value;
        }

        if(cfg.kind == 2){
            value = value / 100; //万分比
            value = value + "%";
        }
        return value;
    }
    //是否成长型属性
    public static IsGrowthProType(id) {
        return (id == 300 || id == 301 || id == 302 || id == 303 || id == 304 || id == 305 || id == 306 || id == 307);
    }
    static BabyPosName = [`长生护符`, `波波糖`, `启蒙之书`, `熊玩偶`, `童趣奶瓶`, `萌尚童装`];
    public static GetBabyPos(pos) {
        return this.BabyPosName[pos - 1] || `无类型`;
    }
    public static strSize(str: string) {
        let total = 0;
        for (let i = 0; i < str.length; i++) {
            var c = str.charAt(i);
            if (/^[\u0000-\u00ff]$/.test(c)) {
                total++;
            } else {
                total += 2;
            }
        }
        return total;
    }
}

window["WordManager"] = WordManager
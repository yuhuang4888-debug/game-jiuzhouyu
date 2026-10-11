import { SpecialCharKey } from "../common/SpecialCharKey";
//新样式 颜色
export enum Enum_ColorUtil_NEW {
    WHITE = "#ffffff",   //白色
    RED_GRAY = "#9b572f",//暗红色
    LIGHT_GREEN = "#00fa64",//亮绿色
    LIGHT_RED = "#ff7575"  //亮红色
}

//亮色(对应暗色面板)
export enum Enum_ColorUtil_Light {
    WHITE = "'#fefaf0'",
    GREEN = "'#4ec279'",
    BLUE = "'#5aaff0'",
    PURPLE = "'#c36ff2'",
    ORANGE = "'#f88452'",
    RED = "'#fa4d4d'",
    GOLDEN = "'#ffbc3d'",
    PINK = "'#ff72c2'",
    YELLOW = "'#ffef67'",
    GRAY = "'#9c9c9c'"
    
}
//暗色(对应亮色面板)
export enum Enum_ColorUtil_Dark {
    WHITE = "'#663915'",
    GREEN = "'#3cad66'",//639c12 
    BLUE = "'#5099dd'",
    PURPLE = "'#b55eec'",
    ORANGE = "'#e17547'",
    RED = "'#ef4848'",
    GOLDEN = "'#cd9222'",
    PINK = "'#f56ebd'",
    YELLOW = "'#ffef67'",
    GRAY = "'#8a8a8a'"
}
export enum ColorType {
    WHITE = 0,
    GREEN = 1,
    BLUE = 2,
    PURPLE = 3,
    ORANGE = 4,
    RED = 5,
    GOLDEN = 6,
    PINK = 7,
    GRAY = 8
}
window["Enum_ColorUtil_Light"] = Enum_ColorUtil_Light;
window["Enum_ColorUtil_Dark"] = Enum_ColorUtil_Dark;
window["ColorType"] = ColorType;
let local_ColorType = ColorType
export class ColorUtil {
    public constructor() {
    }
    //颜色描述
    public static GetColorName(color: number): string {
        switch(color)
        {
            case local_ColorType.WHITE:
                return "白色";
            case local_ColorType.GREEN:
                return "绿色";
            case local_ColorType.BLUE:
                return "蓝色";
            case local_ColorType.PURPLE:
                return "紫色";
            case local_ColorType.ORANGE:
                return "橙色";
            case local_ColorType.RED:
                return "红色";
            case local_ColorType.GOLDEN:
                return "暗金色";
            case local_ColorType.PINK:
                return "粉色";
            default:
                return "无色";
        }
    }
    //颜色描述
    public static GetColorNameOne(color: number): string {
        switch(color)
        {
            case local_ColorType.WHITE:
                return "白";
            case local_ColorType.GREEN:
                return "绿";
            case local_ColorType.BLUE:
                return "蓝";
            case local_ColorType.PURPLE:
                return "紫";
            case local_ColorType.ORANGE:
                return "橙";
            case local_ColorType.RED:
                return "红";
            case local_ColorType.GOLDEN:
                return "暗金";
            case local_ColorType.PINK:
                return "粉";
            default:
                return "无";
        }
    }
    //获取颜色类型对应的颜色 -亮色(对应暗色面板) not_replace_char 不去掉左右两边的冒号
    public static GetColorLight(color: number, not_replace_char = true): string {
        color = Number(color)
        switch(color)
        {
            case local_ColorType.WHITE:
                return not_replace_char ? Enum_ColorUtil_Light.WHITE : (Enum_ColorUtil_Light.WHITE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.GREEN:
                return not_replace_char ? Enum_ColorUtil_Light.GREEN : (Enum_ColorUtil_Light.GREEN).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.BLUE:
                return not_replace_char ? Enum_ColorUtil_Light.BLUE : (Enum_ColorUtil_Light.BLUE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.PURPLE:
                return not_replace_char ? Enum_ColorUtil_Light.PURPLE : (Enum_ColorUtil_Light.PURPLE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.ORANGE:
                return not_replace_char ? Enum_ColorUtil_Light.ORANGE : (Enum_ColorUtil_Light.ORANGE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.RED:
                return not_replace_char ? Enum_ColorUtil_Light.RED : (Enum_ColorUtil_Light.RED).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.GOLDEN:
                return not_replace_char ? Enum_ColorUtil_Light.GOLDEN : (Enum_ColorUtil_Light.GOLDEN).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.PINK:
                return not_replace_char ? Enum_ColorUtil_Light.PINK : (Enum_ColorUtil_Light.PINK).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.GRAY:
                return not_replace_char ? Enum_ColorUtil_Light.GRAY : (Enum_ColorUtil_Light.GRAY).replace(SpecialCharKey.ColorUtil1, "");
            default:
                return not_replace_char ? Enum_ColorUtil_Light.WHITE : (Enum_ColorUtil_Light.WHITE).replace(SpecialCharKey.ColorUtil1, "");
        }
    }
    //获取颜色类型对应的颜色 -暗色(对应亮色面板) not_replace_char 去掉左右两边的冒号
    public static GetColorDark(color: number, not_replace_char = true): string {
        color = Number(color)
        switch(color)
        {
            case local_ColorType.WHITE:
                return not_replace_char ? Enum_ColorUtil_Dark.WHITE : (Enum_ColorUtil_Dark.WHITE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.GREEN:
                return not_replace_char ? Enum_ColorUtil_Dark.GREEN : (Enum_ColorUtil_Dark.GREEN).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.BLUE:
                return not_replace_char ? Enum_ColorUtil_Dark.BLUE : (Enum_ColorUtil_Dark.BLUE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.PURPLE:
                return not_replace_char ? Enum_ColorUtil_Dark.PURPLE : (Enum_ColorUtil_Dark.PURPLE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.ORANGE:
                return not_replace_char ? Enum_ColorUtil_Dark.ORANGE : (Enum_ColorUtil_Dark.ORANGE).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.RED:
                return not_replace_char ? Enum_ColorUtil_Dark.RED : (Enum_ColorUtil_Dark.RED).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.GOLDEN:
                return not_replace_char ? Enum_ColorUtil_Dark.GOLDEN : (Enum_ColorUtil_Dark.GOLDEN).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.PINK:
                return not_replace_char ? Enum_ColorUtil_Dark.PINK : (Enum_ColorUtil_Dark.PINK).replace(SpecialCharKey.ColorUtil1, "");
            case local_ColorType.GRAY:
                return not_replace_char ? Enum_ColorUtil_Dark.GRAY : (Enum_ColorUtil_Dark.GRAY).replace(SpecialCharKey.ColorUtil1, "");
            default:
                return not_replace_char ? Enum_ColorUtil_Dark.WHITE : (Enum_ColorUtil_Dark.WHITE).replace(SpecialCharKey.ColorUtil1, "");
        }
    }
    //获取品质特效
    public static GetColorEffectStr(color): string {
        if (color == local_ColorType.ORANGE) {
            return "yellow";
        }
        else if (color == local_ColorType.RED) {
            return "red";
        }
        else if (color == local_ColorType.PINK) {
            return "pink";
        }
    }

    public static TryParseHtmlString(string){
        return string
    }

    public static GetReplaceChar(color_str):string{
        return color_str.replace(SpecialCharKey.ColorUtil1, "")
    }

    //"#ffffff"转成'"#ffffff"'
    public static TransHtmlColor(color_str):string{
       return `'${color_str}'`
    }
}

window["ColorUtil"] = ColorUtil
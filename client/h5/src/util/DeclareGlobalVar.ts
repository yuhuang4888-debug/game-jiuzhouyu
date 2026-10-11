// console.warn("DeclareGlobalVar@EventDispatcher")
import { EventDispatcher } from "./EventDispatcher";
// console.warn("DeclareGlobalVar")

// TypeScript file
export class DeclareGlobalVar {
}
export var GlobalEventSystem:EventDispatcher;
GlobalEventSystem = new EventDispatcher()
export let ClientConfig: any;
export function SetGlobalClientConfig(cfg){
    ClientConfig = cfg
}
export var LogicRealRatio_X: number;
export var LogicRealRatio_Y: number;
export var LogicRealRatio_Z: number;
LogicRealRatio_X = 60;
LogicRealRatio_Y = 30;
LogicRealRatio_Z = 76;
window["GlobalEventSystem"] = GlobalEventSystem;
window["LogicRealRatio_X"] = LogicRealRatio_X;
window["LogicRealRatio_Y"] = LogicRealRatio_Y;
window["LogicRealRatio_Z"] = LogicRealRatio_Z;

export enum LOAD_QUEUE {
    HIGHT,
    MIDDLE,
    LOW,
    SILENT //静默下载 最低等级
}
window["LOAD_QUEUE"] = LOAD_QUEUE;

//帧数类型
export enum FRAME_TYPE {
    total = 0,
    odd = 1,
    even = 2 //当前偶数帧数
}
window["FRAME_TYPE"] = FRAME_TYPE;


window["DeclareGlobalVar"] = DeclareGlobalVar
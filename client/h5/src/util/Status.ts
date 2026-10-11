// TypeScript file
let local_Laya = Laya
export class Status {
    public constructor() {
    }
    public static get NowTime() {
        return local_Laya.timer.currTimer * 0.001;
    }
}
window["Status"] = Status
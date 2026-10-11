/** 午间派对
 */
declare interface ProtoFmtInfo {
    28500: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    28501: {
        desc: "进入午间派对";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    28502: {
        desc: "退出午间派对";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    28503: {
        desc: "午间派对经验信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 累积经验 */
            exp: number;
        };
    };
    28504: {
        desc: "午间派对采集信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 采集普通宝箱数量 */
            low_box: number;
            /** 采集高级宝箱数量 */
            high_box: number;
        };
    };
    28505: {
        desc: "午间派对怪物复活时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 复活时间戳 */
            time: number;
        };
    };
    28506: {
        desc: "午间派对剩余时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动结束时间戳 */
            time: number;
        };
    };
}

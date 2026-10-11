/** 远古奥术
 */
declare interface ProtoFmtInfo {
    21101: {
        desc: "远古奥术信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 核心类型 */
            core_type: number;
            /** 远古奥术列表 */
            arcana_list: {
                /** 规则id */
                id: number;
                /** 等级 */
                lv: number;
                /** 突破等级 */
                break_lv: number;
            }[];
        };
    };
    21102: {
        desc: "升级";
        send: (number: 21102, fmt: "i", args: [id: number]) => never;
        sendFmt: "i";
        sendArgs: [id: number];
        recv: {
            error_code: number;
            id: number;
        };
    };
    21103: {
        desc: "突破";
        send: (number: 21103, fmt: "i", args: [id: number]) => never;
        sendFmt: "i";
        sendArgs: [id: number];
        recv: {
            error_code: number;
            id: number;
            /** 突破等级 */
            break_lv: number;
        };
    };
    21104: {
        desc: "核心类型选择";
        send: (number: 21104, fmt: "c", args: [core_type: number]) => never;
        sendFmt: "c";
        sendArgs: [core_type: number];
        recv: {
            error_code: number;
            core_type: number;
        };
    };
    21105: {
        desc: "重置";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
}

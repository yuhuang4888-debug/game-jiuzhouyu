/** 广告
 */
declare interface ProtoFmtInfo {
    19301: {
        desc: "广告奖励内容";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward: any;
        };
    };
    19302: {
        desc: "广告状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 331 定制的活动的不发 */
            ad_list: {
                mod_id: number;
                sub_id: number;
                /** 观看次数 */
                count: number;
            }[];
        };
    };
    19303: {
        desc: "开始观看广告";
        send: (
            number: 19303,
            fmt: "iii",
            args: [mod_id: number, sub_id: number, grade_id: number]
        ) => never;
        sendFmt: "iii";
        sendArgs: [mod_id: number, sub_id: number, grade_id: number];
        recv: {
            mod_id: number;
            sub_id: number;
            grade_id: number;
            code: number;
        };
    };
    19304: {
        desc: "通知打点";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            mod_id: number;
            sub_id: number;
            grade_id: number;
        };
    };
}

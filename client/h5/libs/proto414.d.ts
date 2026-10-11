/** 青云夺宝
 */
declare interface ProtoFmtInfo {
    41400: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    41401: {
        desc: "夺宝界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 夺宝次数 */
            times: number;
            /** 奖励领取情况列表 */
            lists: {
                /** 已经领取的次数 */
                times: number;
            }[];
        };
    };
    41402: {
        desc: "刷新宝箱通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 下次刷新时间戳 */
            utime: number;
        };
    };
    41404: {
        desc: "活动状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0: 活动关闭 1: 活动开启 */
            status: number;
            /** 当前阶段结束时间戳 */
            etime: number;
        };
    };
}
